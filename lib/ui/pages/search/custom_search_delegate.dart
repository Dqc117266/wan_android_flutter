import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android_flutter/core/model/hotkey_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';

class CustomSearchDelegate extends SearchDelegate<String> {

  late List<String?> _hotKeys = [];

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
          if (!query.isEmpty)
            query = '';
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
    return Center(
      child: Text('搜索结果：$query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? FutureBuilder(
            future: _getHotKey(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final List<String> suggestions = ['flutter', 'test aa'];

                final List<String?>? hotKeys = snapshot.data;
                final List<String> filteredSuggestions = suggestions
                    .where((suggestion) =>
                        suggestion.toLowerCase().contains(query.toLowerCase()))
                    .toList();

                return _buildSuggestionsLayout(
                    context, filteredSuggestions, hotKeys!);
              }
            },
          )
        : _buildSearchingWidget(context);
  }

  Future<List<String?>> _getHotKey() async {
    if (!_hotKeys.isEmpty) {
      return _hotKeys;
    }

    HotKeyModel hotKeyModel = await HttpCreator.getHotKey();
    _hotKeys = hotKeyModel.data!.map((e) => e.name).toList();

    return _hotKeys;
  }

  Widget _buildSearchingWidget(BuildContext context) {
    return InkWell(
      onTap: () {},
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
              SizedBox(
                width: 16,
              ),
              Icon(Icons.search),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  '搜索"$query"',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsLayout(BuildContext context,
      List<String> filteredSuggestions, List<String?> hotKeys) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "历史搜索",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.delete_outline),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8.0,
            children: [
              ...filteredSuggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () {
                    // query = suggestion;
                    // showResults(context);
                  },
                  child: Chip(label: Text(suggestion)),
                );
              }),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "搜索热词",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8.0,
            children: [
              ...hotKeys.map((hotKey) {
                return GestureDetector(
                  onTap: () {
                    // query = hotKey!;
                    // showResults(context);
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
}
