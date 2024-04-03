import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/result_model.dart';
import 'package:wan_android_flutter/core/model/todo_model.dart';
import 'package:wan_android_flutter/core/utils/time_utils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

import '../../../../core/model/todolist_model.dart';
import 'addtodo/modal_bottom_sheet.dart';

class TodoListHelper {
  GlobalKey<RefreshableListViewState<Datas>> starTodokey;
  GlobalKey<RefreshableListViewState<Datas>> unDoneTodokey;
  GlobalKey<RefreshableListViewState<Datas>> doneTodokey;

  TodoListHelper(this.starTodokey, this.unDoneTodokey, this.doneTodokey);

  void markStarAndUpdateList(Datas item) async {
    final type = item.type! == TodoType.star.value
        ? TodoType.normal.value
        : TodoType.star.value;

    final TodoModel? todoModel = await HttpUtils.handleRequestData(() =>
        HttpCreator.todoUpdate(item.id!, item.title!, item.content!,
            item.dateStr!, item.status!, type, item.priority!));

    if (todoModel != null && unDoneTodokey.currentState != null) {
      unDoneTodokey.currentState!.items =
          setUnStarMark(unDoneTodokey.currentState!.items, todoModel.data!);
      unDoneTodokey.currentState!.refreshListView();

      if (starTodokey.currentState != null) {
        final items = starTodokey.currentState!.items;
        if (type == TodoType.star.value) {
          if (!items.contains(todoModel.data!)) {
            starTodokey.currentState!.items.add(todoModel.data!);

            sortTodoList(starTodokey.currentState!.items);
            starTodokey.currentState!.refreshListView();
          }
        } else {
          items.removeWhere((item) => item.id == todoModel.data!.id);

          unDoneTodokey.currentState!.items =
              setUnStarMark(unDoneTodokey.currentState!.items, todoModel.data!);
          unDoneTodokey.currentState!.refreshListView();

          starTodokey.currentState!.refreshListView();
        }
      }
    }
  }

  Future<bool> markDoneAndupdateList(Datas item) async {
    final status = item.status! == TodoStatus.done.value
        ? TodoStatus.unDone.value
        : TodoStatus.done.value;

    final TodoModel? todoModel = await HttpUtils.handleRequestData(() =>
        HttpCreator.todoUpdate(item.id!, item.title!, item.content!,
            item.dateStr!, status, item.type!, item.priority!));

    if (todoModel != null) {
      if (status == TodoStatus.done.value) {
        removeFromList(item, unDoneTodokey);
        removeFromList(item, starTodokey);
        addToList(todoModel.data!, doneTodokey);
      } else {
        removeFromList(item, doneTodokey);
        addToList(todoModel.data!, unDoneTodokey);
        if (todoModel.data!.type == TodoType.star.value) {
          addToList(todoModel.data!, starTodokey);
        }
      }
      return Future(() => true);
      // addToStarList(todoModel.data!, starTodokey);
    }

    return Future(() => false);
  }

  void addToList(Datas item, GlobalKey<RefreshableListViewState<Datas>> key) {
    int findIdIndex = -1;
    if (key.currentState != null) {
      findIdIndex =
          key.currentState!.items.indexWhere((todo) => todo.id == item.id!);
    }

    if (key.currentState != null && findIdIndex == -1) {
      //找不到id就不继续执行
      key.currentState!.items.add(item);
      sortTodoList(key.currentState!.items);
      key.currentState!.refreshListView();
    }
  }

  void removeFromList(
      Datas item, GlobalKey<RefreshableListViewState<Datas>> key) {
    if (key.currentState != null) {
      key.currentState!.items.removeWhere((element) => element.id == item.id);
      key.currentState!.refreshListView();
    }
  }

  List<Datas> setUnStarMark(List<Datas> items, Datas data) {
    return items.map((item) {
      if (item.id == data.id) {
        return data;
      } else {
        return item;
      }
    }).toList();
  }

  void sortTodoList(List<Datas> items) {
    items.sort((a, b) {
      // 先按照 date 从大到小排序
      int dateComparison = b.date!.compareTo(a.date!);
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        // 如果 date 相等，则按照 id 从小到大排序
        return a.id!.compareTo(b.id!);
      }
    });
  }

  void updateTodoDate(Datas item, DateTime selectDate) async {
    if (!TimeUtils.isSameDay(item.date!, selectDate)) {
      final todoModel =
          await HttpUtils.handleRequestData(() => HttpCreator.todoUpdate(
                item.id!,
                item.title!,
                item.content!,
                TimeUtils.formatDateYearTime(selectDate),
                item.status!,
                item.type!,
                item.priority!,
              ));

      if (todoModel != null) {
        findIndexUpdateItem(unDoneTodokey, todoModel);
        findIndexUpdateItem(starTodokey, todoModel);
      }
    }
  }

  findIndexUpdateItem(GlobalKey<RefreshableListViewState<Datas>> key, TodoModel todoModel) {
    if (key.currentState != null) {
      final items = key.currentState!.items;
      final findIndex =
      items.indexWhere((todo) => todo.id == todoModel.data!.id);

      if (findIndex != -1) {
        items[findIndex] = todoModel.data!;

        sortTodoList(key.currentState!.items);
        key.currentState!.refreshListView();
      }
    }
  }

  void showAddTodoModalBottom(BuildContext context, int tabIndex) {
    AddTodoModalBottomSheet.show(context, tabIndex, (todoModel) {
      if (todoModel != null) {
        if (todoModel.data!.type == TodoType.star.value) {
          addToList(todoModel.data!, starTodokey);
        }
        addToList(todoModel.data!, unDoneTodokey);
      }
    });
  }

  void deleteTodoItem(Datas item) async {
    ResultModel? resultModel = await HttpUtils.handleRequestData(
        () => HttpCreator.todoDelete(item.id!));
    if (resultModel != null) {
      if (item.status == TodoStatus.done.value) {
        removeFromList(item, doneTodokey);
      } else {
        removeFromList(item, unDoneTodokey);
        removeFromList(item, starTodokey);
      }
    }
  }

  void changedTitleAndContentUpdateTodo(
      String titleInputText, String contentInputText, Datas item) async {
    if (titleInputText.trim() != item.title ||
        contentInputText.trim() != item.content) {
      TodoModel? todoModel = await HttpUtils.handleRequestData(
        () => HttpCreator.todoUpdate(
            item.id!,
            titleInputText.trim(),
            contentInputText.trim(),
            item.dateStr!,
            item.status!,
            item.type!,
            item.priority!),
      );

      if (todoModel != null) {
        if (todoModel.data!.status == TodoStatus.done.value) {
          updateItemTitleAndContent(doneTodokey, titleInputText.trim(),
              contentInputText.trim(), item);
        } else {
          updateItemTitleAndContent(unDoneTodokey, titleInputText.trim(),
              contentInputText.trim(), item);

          updateItemTitleAndContent(starTodokey, titleInputText.trim(),
              contentInputText.trim(), item);

        }
      }
    }
  }

  void updateItemTitleAndContent(GlobalKey<RefreshableListViewState<Datas>> key,
      String title, String content, Datas item) {
    if (key.currentState != null) {
      final findIndex =
          key.currentState!.items.indexWhere((todo) => todo.id == item.id);
      if (findIndex != -1) {
        key.currentState!.items[findIndex].title = title;
        key.currentState!.items[findIndex].content = content;
        key.currentState!.refreshListView();
      }
    }
  }
}
