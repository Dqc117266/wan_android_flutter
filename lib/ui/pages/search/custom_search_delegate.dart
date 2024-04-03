import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/hotkey_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/search/search_page.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';
import 'package:wan_android_flutter/ui/shared/shared_preferences_helper.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  static final String historyKeysName = "history_keys";
  static final String hotKeysName = "hot_keys";

  List<String> _hotKeys =
      SharedPreferencesHelper.getStringList(hotKeysName) ?? [];
  late List<String>? _historyKeys =
      SharedPreferencesHelper.getStringList(historyKeysName) ?? [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // 在搜索栏右侧显示清除按钮
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () {
          if (!query.isEmpty) _clearQuery();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // 在搜索栏左侧显示返回按钮
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // _toSearchPage(context);
    // _clearQuery();
    return SizedBox.shrink();
  }

  @override
  void showResults(BuildContext context) {
    // TODO: implement showResults
    print("showResults search page");
    _toSearchAndClearQuery(context, query);
    super.showResults(context);

    showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.trim().isEmpty
        ? CustomFutureBuilder(
            future: _getHotKey(),
            builder: (context, snapshot) {
              final List<String>? filteredSuggestions = _historyKeys;

              return SingleChildScrollView(
                child: _buildSuggestionsLayout(
                    context, filteredSuggestions!, _hotKeys),
              );
            },
          )
        : _buildSearchingWidget(context);
  }

  Future<List<String?>> _getHotKey() async {
    if (!_hotKeys.isEmpty) {
      return _hotKeys;
    }

    HotKeyModel hotKeyModel = await HttpCreator.getHotKey();
    _hotKeys = hotKeyModel.data!.map((e) => e.name!).toList();

    SharedPreferencesHelper.setValue(hotKeysName, _hotKeys);

    return _hotKeys;
  }

  Widget _buildSearchingWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        _toSearchAndClearQuery(context, query);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).hintColor.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.search),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${LocaleKeys.search_searchName.tr()}"$query"',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsLayout(BuildContext context,
      List<String> filteredSuggestions, List<String?>? hotKeys) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_historyKeys!.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.search_historyTitle.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.bodyLarge!.fontSize),
                ),
                GestureDetector(
                  onTap: () => _openClearHistoryDialog(context),
                  child: Icon(Icons.delete_outline),
                ),
              ],
            ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: [
              ...filteredSuggestions.map((suggestion) {
                return GestureDetector(
                  onLongPress: () =>
                      _removeAtHistoryDialog(context, suggestion),
                  onTap: () {
                    query = suggestion;
                    _toSearchAndClearQuery(context, query);
                  },
                  child: Chip(label: Text(suggestion)),
                );
              }),
            ],
          ),
          SizedBox(height: 8),
          if (!_hotKeys.isEmpty)
            Text(
              LocaleKeys.search_hotKeysTitle.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
            ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: [
              ...hotKeys!.map((hotKey) {
                return GestureDetector(
                  onTap: () {
                    _toSearchAndClearQuery(context, hotKey);
                  },
                  child: Chip(label: Text(hotKey!)),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _clearQuery() {
    query = '';
  }

  Future<void> _saveSearchKey(String key) async {
    if (_historyKeys!.contains(key)) {
      _historyKeys!.remove(key);
    }

    _historyKeys!.insert(0, key);

    await SharedPreferencesHelper.setValue(historyKeysName, _historyKeys!);
  }

  void _openClearHistoryDialog(BuildContext context) {
    DialogHelper.showAlertDialog(
      context: context,
      title: Text(LocaleKeys.search_clearHistoryDialogTitle.tr()),
      content: Text(LocaleKeys.search_clearHistoryDialogContent.tr()),
      dismissText: LocaleKeys.dialogDismiss.tr(),
      actionText: LocaleKeys.dialogAction.tr(),
      onAction: () {
        _clearAllHistoryKeys();
        _clearQuery();
        showSuggestions(context);
      },
    );
  }

  void _removeAtHistoryDialog(BuildContext context, String content) {
    DialogHelper.showAlertDialog(
      context: context,
      title: Text(LocaleKeys.search_removeHistoryDialogTitle.tr()),
      content: Text(LocaleKeys.search_removeHistoryDialogContent.tr()),
      dismissText: LocaleKeys.dialogDismiss.tr(),
      actionText: LocaleKeys.dialogAction.tr(),
      onAction: () {
        _removeAtIndexHistoryKey(content);
        _clearQuery();
        showSuggestions(context);
      },
    );
  }

  Future<void> _clearAllHistoryKeys() async {
    _historyKeys!.clear();
    await SharedPreferencesHelper.remove(historyKeysName);
  }

  void _removeAtIndexHistoryKey(String content) {
    int index = _historyKeys!.indexOf(content);
    if (index != -1) {
      _historyKeys!.removeAt(index);
    }

    SharedPreferencesHelper.setValue(historyKeysName, _historyKeys);
  }

  void _toSearchPage(BuildContext context, String query) {
    if (!query.trim().isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(
            key: GlobalKey(), // 这里传递一个 GlobalKey 对象作为 key
            query: query,
          ),
        ),
      );
      _saveSearchKey(query);
    }
  }

  void _toSearchAndClearQuery(BuildContext context, query) {
    _toSearchPage(context, query);
    _clearQuery();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _hotKeys.clear();
    _historyKeys!.clear();
  }
}
