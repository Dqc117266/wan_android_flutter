import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:wan_android_flutter/network/api.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiService {
  final connectTimeout = Duration(seconds: 5);
  final receiveTimeout = Duration(seconds: 5);

  late final Dio _dio;

  ApiService() {
    BaseOptions options = BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    _dio = Dio(options);
    final cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));

  }

  Future<Response> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.post(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw e;
    }
  }

}