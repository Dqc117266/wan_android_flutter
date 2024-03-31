import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/todo_model.dart';
import 'package:wan_android_flutter/core/utils/TimeUtils.dart';
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

  void markStarAndUpdateList(Datas item, index) async {
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

  void markDoneAndupdateList(Datas item, index) async {
    final status = item.status! == TodoStatus.done.value
        ? TodoStatus.unDone.value
        : TodoStatus.done.value;

    final TodoModel? todoModel = await HttpUtils.handleRequestData(() =>
        HttpCreator.todoUpdate(item.id!, item.title!, item.content!,
            item.dateStr!, status, item.type!, item.priority!));

    if (todoModel != null) {
      if (status == TodoStatus.done.value) {
        removeFromList(item, index, unDoneTodokey);
        removeFromList(item, index, starTodokey);
        addToList(todoModel.data!, doneTodokey);
      } else {
        removeFromList(item, index, doneTodokey);
        addToList(todoModel.data!, unDoneTodokey);
        if (todoModel.data!.type == TodoType.star.value) {
          addToList(todoModel.data!, starTodokey);
        }
      }
      // addToStarList(todoModel.data!, starTodokey);
    }
  }

  void addToList(Datas item, GlobalKey<RefreshableListViewState<Datas>> key) {
    if (key.currentState != null && !key.currentState!.items.contains(item)) {
      key.currentState!.items.add(item);
      sortTodoList(key.currentState!.items);
      key.currentState!.refreshListView();
    }
  }

  void removeFromList(
      Datas item, int index, GlobalKey<RefreshableListViewState<Datas>> key) {
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

  void updateTodoDate(Datas item, int index, DateTime selectDate) async {
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
        updateTodoItem(todoModel, index);
      }
    }
  }

  void updateTodoItem(TodoModel todoModel, int index) {
    if (unDoneTodokey.currentState != null) {
      unDoneTodokey.currentState!.items[index] = todoModel.data!;
      sortTodoList(unDoneTodokey.currentState!.items);
      unDoneTodokey.currentState!.refreshListView();
    }

    if (starTodokey.currentState != null) {
      final items = starTodokey.currentState!.items;
      final findIndex = items.indexWhere((todo) => todo.id == todoModel.data!.id);

      items[findIndex] = todoModel.data!;

      sortTodoList(starTodokey.currentState!.items);
      starTodokey.currentState!.refreshListView();
    }
  }

  void showAddTodoModalBottom(BuildContext context) {
    AddTodoModalBottomSheet.show(context, (todoModel) {
      if (todoModel != null) {
        if (todoModel.data!.type == TodoType.star) {
          addToList(todoModel.data!, starTodokey);
        }
        addToList(todoModel.data!, unDoneTodokey);
      }
    });
  }


}