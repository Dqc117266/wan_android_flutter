import 'dart:convert';

import 'package:universal_io/io.dart' show Cookie;

import 'package:cookie_jar/cookie_jar.dart';
import 'package:wan_android_flutter/ui/shared/shared_preferences_helper.dart';

/// [PersistCookieJar] is a cookie manager which implements
/// the standard cookie policy declared in RFC.
/// [PersistCookieJar]  persists the cookies in files, if the application exit,
/// the cookies always exist unless user explicitly called [delete].
class PersistCookieJarSp extends DefaultCookieJar {
  /// [persistSession] is whether persisting the cookies that without
  /// "expires" or "max-age" attribute.
  /// If tbe value is false, the session cookies will be discarded.
  /// Otherwise, the session cookies will be persisted.
  ///
  /// [ignoreExpires] will determine whether to save/load expired cookies.
  ///
  /// [storage] is defaults to [FileStorage].
  PersistCookieJarSp({
    this.persistSession = true,
    bool ignoreExpires = false,
    Storage? storage,
    this.deleteHostCookiesWhenLoadFailed = true,
  })  : super(ignoreExpires: ignoreExpires);

  /// Whether persisting cookies without "expires" or "max-age" attribute.
  final bool persistSession;
  final bool deleteHostCookiesWhenLoadFailed;

  static const _indexKey = '.index';
  static const _domainsKey = '.domains';

  Set<String> _hostSet = {};

  bool _initialized = false;

  Future<void> forceInit() => _checkInitialized(force: true);

  Future<void> _checkInitialized({bool force = false}) async {
    if (!force && _initialized) {
      return;
    }

    // Load domain cookies.
    String? str = await SharedPreferencesHelper.getString(_domainsKey);
    if (str != null && str.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonData = json.decode(str);
        final Map<String, Map<String, Map<String, SerializableCookie>>>
        cookies = jsonData.map((domain, cookies) {
          final domainCookies = cookies
              .cast<String, dynamic>()
              .map<String, Map<String, SerializableCookie>>(
                (path, map) {
              final cookieForPath = map.cast<String, String>();
              final realCookies =
              cookieForPath.map<String, SerializableCookie>((
                  String cookieName,
                  String cookie,
                  ) {
                return MapEntry<String, SerializableCookie>(
                  cookieName,
                  SerializableCookie.fromJson(cookie),
                );
              });
              return MapEntry<String, Map<String, SerializableCookie>>(
                path,
                realCookies,
              );
            },
          );
          return MapEntry<String, Map<String, Map<String, SerializableCookie>>>(
            domain,
            domainCookies,
          );
        });
        domainCookies
          ..clear()
          ..addAll(cookies);
      } catch (e) {
        await SharedPreferencesHelper.remove(_domainsKey);
      }
    }
    str = await SharedPreferencesHelper.getString(_indexKey);
    if ((str != null && str.isNotEmpty)) {
      try {
        final list = json.decode(str);
        _hostSet = Set<String>.from(list);
      } catch (e) {
        await SharedPreferencesHelper.remove(_indexKey);
      }
    } else {
      _hostSet = <String>{};
    }
    _initialized = true;
  }

  @override
  Future<List<Cookie>> loadForRequest(Uri uri) async {
    await _checkInitialized();
    await _load(uri);
    return super.loadForRequest(uri);
  }

  @override
  Future<void> saveFromResponse(Uri uri, List<Cookie> cookies) async {
    await _checkInitialized();
    if (cookies.isNotEmpty) {
      await super.saveFromResponse(uri, cookies);
      if (cookies.every((Cookie e) => e.domain == null)) {
        await _save(uri);
      } else {
        await _save(uri, true);
      }
    }
  }

  Map<String, Map<String, SerializableCookie>> _filter(
      Map<String, Map<String, SerializableCookie>> domain,
      ) {
    return domain.cast<String, Map<String, dynamic>>().map(
          (path, cookies) {
        final result = cookies.cast<String, SerializableCookie>().map(
              (key, cookie) {
            final isSession =
                cookie.cookie.expires == null && cookie.cookie.maxAge == null;
            if ((isSession && persistSession) ||
                (persistSession && !cookie.isExpired())) {
              return MapEntry(key, cookie);
            } else {
              return MapEntry(null, cookie);
            }
          },
        )..removeWhere((k, v) => k == null);
        return MapEntry(path, result.cast<String, SerializableCookie>());
      },
    );
  }

  /// Delete cookies for specified [uri].
  /// This API will delete all cookies for the `uri.host`, it will ignored the `uri.path`.
  ///
  /// [withDomainSharedCookie] `true` will delete the domain-shared cookies.
  @override
  Future<void> delete(Uri uri, [bool withDomainSharedCookie = false]) async {
    await _checkInitialized();
    await super.delete(uri, withDomainSharedCookie);
    final host = uri.host;
    if (_hostSet.remove(host)) {
      await SharedPreferencesHelper.setValue(_indexKey, json.encode(_hostSet.toList()));
    }
    await SharedPreferencesHelper.remove(host);
    if (withDomainSharedCookie) {
      await SharedPreferencesHelper.setValue(_domainsKey, json.encode(domainCookies));
    }
  }

  /// Delete all cookies files in the [storage] and the memory.
  @override
  Future<void> deleteAll() async {
    await _checkInitialized();
    await super.deleteAll();
    final keys = _hostSet.toList(growable: true)
      ..addAll([_indexKey, _domainsKey]);
    keys.forEach((element) async {
      await SharedPreferencesHelper.remove(element);
    });
    _hostSet.clear();
  }

  Future<void> _save(Uri uri, [bool withDomainSharedCookie = false]) async {
    final host = uri.host;
    if (!_hostSet.contains(host)) {
      _hostSet.add(host);
      await SharedPreferencesHelper.setValue(_indexKey, json.encode(_hostSet.toList()));
    }
    final cookies = hostCookies[host];
    if (cookies != null) {
      await SharedPreferencesHelper.setValue(host, json.encode(_filter(cookies)));
    }
    if (withDomainSharedCookie) {
      final filterDomainCookies = domainCookies.map(
            (key, value) => MapEntry(key, _filter(value)),
      );
      await SharedPreferencesHelper.setValue(_domainsKey, json.encode(filterDomainCookies));
    }
  }

  Future<void> _load(Uri uri) async {
    final host = uri.host;
    if (!_hostSet.contains(host) || hostCookies[host] != null) {
      return;
    }
    final str = await SharedPreferencesHelper.getString(host);
    if (str == null || str.isEmpty) {
      return;
    }
    try {
      final cookies = json.decode(str).cast<String, Map<String, dynamic>>();
      cookies.forEach((String path, Map<String, dynamic> map) {
        map.forEach((String k, dynamic v) {
          map[k] = SerializableCookie.fromJson(v);
        });
      });
      hostCookies[host] =
          cookies.cast<String, Map<String, SerializableCookie>>();
    } catch (e) {
      if (deleteHostCookiesWhenLoadFailed) {
        await SharedPreferencesHelper.remove(host);
      }
      rethrow;
    }
  }
}
