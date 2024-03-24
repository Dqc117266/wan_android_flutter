import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';

import '../model/collects_model.dart';

class CollectsViewModel with ChangeNotifier {
  List<Datas> _collectedItems = [];
  int maxPage = 0;

  CollectsProvider() {
    fetchCollectedItems();
  }

  List<Datas> get collectedItems => _collectedItems;

  Future<void> fetchCollectedItems() async {
    print('_fetchCollectedItems');
    final CollectsModel? collectList = await HttpUtils.handleRequestData(() => HttpCreator.getCollectList(0));

    if (collectList != null) {
      maxPage = collectList.data!.pageCount!;
      _collectedItems.addAll(collectList.data!.datas!);
    }
    notifyListeners();
  }

  Future<List<Datas>> loadMorePage(int page) async {
    final CollectsModel? collectList = await HttpUtils.handleRequestData(() => HttpCreator.getCollectList(page));

    if (collectList != null) {
      _collectedItems.addAll(collectList.data!.datas!);
    }
    notifyListeners();
    return collectList!.data!.datas!;
  }

  Future<List<Datas>> refreshPage() async {
    final CollectsModel? collectList = await HttpUtils.handleRequestData(() => HttpCreator.getCollectList(0));

    if (collectList != null) {
      _collectedItems.clear();
      _collectedItems.addAll(collectList.data!.datas!);
    }

    notifyListeners();
    return _collectedItems;
  }

  void _addCollectedItem(Datas newItem) {
    _collectedItems.add(newItem);
    notifyListeners();
  }

  void removeCollectedItem(Datas itemToRemove) {
    _collectedItems.remove(itemToRemove);
    notifyListeners();
  }

// ...其他方法和属性
}