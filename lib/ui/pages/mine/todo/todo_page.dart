import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/todo_model.dart';
import 'package:wan_android_flutter/core/model/todolist_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/mine/todo/addtodo/modal_bottom_sheet.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class TodoScreen extends StatefulWidget {
  static const routeName = "/todo";

  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int firstPage = 1;

  GlobalKey<RefreshableListViewState<Datas>> starTodokey = GlobalKey();
  GlobalKey<RefreshableListViewState<Datas>> unDoneTodokey = GlobalKey();
  GlobalKey<RefreshableListViewState<Datas>> doneTodokey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // 在这里处理选项卡切换的逻辑
    //第一次切换页面currentState为空导致该无法更新，所以这种情况重新build页面
    if (_tabController.index == 0 && starTodokey.currentState == null ||
        _tabController.index == 2 && doneTodokey.currentState == null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 指定选项卡的数量
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.mine_todo.tr(),
          ),
          bottom: TabBar(
            controller: _tabController,
            // 在AppBar的底部添加TabBar
            tabs: [
              Tab(
                child: Icon(Icons.star),
              ), // 第一个选项卡
              Tab(text: '待办事项'), // 第二个选项卡
              Tab(text: '已完成'), // 第二个选项卡
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AddTodoModalBottomSheet.show(context);
          },
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabStarContent(context, firstPage),
            _buildTabUndoneContent(context, firstPage),
            _buildTabDoneContent(context, firstPage),
          ],
        ),
      ),
    );
  }

  // 构建选项卡的内容，这里是您原来的页面内容
  Widget _buildTabUndoneContent(BuildContext context, int firstPage) {
    return CustomFutureBuilder(
      future: HttpCreator.todoListByStatus(firstPage, TodoStatus.unDone.value),
      onRefresh: () {
        setState(() {});
      },
      builder: (context, snapshot) {
        final TodoListModel todoListModel = snapshot.data;

        return RefreshableListView<Datas>(
          key: unDoneTodokey,
          initialItems: todoListModel.data!.datas!,
          loadMoreCallback: (page) async {
            final todoList = await HttpUtils.handleRequestData(
                () => HttpCreator.todoListByStatus(page, TodoStatus.unDone.value));
            if (todoList != null) {
              return todoList.data!.datas;
            }
            return null;
          },
          itemBuilder: (context, item, index, length) {
            return _buildTodoListTile(item, index);
          },
          maxPage: todoListModel.data!.pageCount!,
          firstPage: firstPage,
        );
      },
    );
  }

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

  void removeFromList(Datas item, int index, GlobalKey<RefreshableListViewState<Datas>> key) {
    if (key.currentState != null) {
      key.currentState!.items.removeWhere((element) => element.id == item.id);
      key.currentState!.refreshListView();
    }
  }

  void addToList(Datas item, GlobalKey<RefreshableListViewState<Datas>> key) {
    if (key.currentState != null && !key.currentState!.items.contains(item)) {
      key.currentState!.items.add(item);
      sortTodoList(key.currentState!.items);
      key.currentState!.refreshListView();
    }
  }

  void addToStarList(Datas item, GlobalKey<RefreshableListViewState<Datas>> key) {
    if (key.currentState != null) {
      key.currentState!.items.removeWhere((element) => element.id == item.id);
      key.currentState!.items.add(item);
      key.currentState!.refreshListView();
    }
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

  List<Datas> setUnStarMark(List<Datas> items, Datas data) {
    return items.map((item) {
      if (item.id == data.id) {
        return data;
      } else {
        return item;
      }
    }).toList();
  }

  Widget _buildTabStarContent(BuildContext context, int firstPage) {
    return CustomFutureBuilder(
      future: HttpCreator.todoListByTypeAndStatus(firstPage, TodoType.star.value, TodoStatus.unDone.value),
      onRefresh: () {
        setState(() {});
      },
      builder: (context, snapshot) {
        final TodoListModel todoListModel = snapshot.data;

        return RefreshableListView<Datas>(
          key: starTodokey,
          initialItems: todoListModel.data!.datas!,
          loadMoreCallback: (page) async {
            final todoList = await HttpUtils.handleRequestData(
                () => HttpCreator.todoListByTypeAndStatus(page, TodoType.star.value, TodoStatus.unDone.value));
            if (todoList != null) {
              return todoList.data!.datas;
            }
            return null;
          },
          itemBuilder: (context, item, index, length) {
            return _buildTodoListTile(item, index);
          },
          maxPage: todoListModel.data!.pageCount!,
          firstPage: firstPage,
        );
      },
    );
  }

  Widget _buildTodoListTile(Datas item, index) {
    return ListTile(
      onTap: () {},
      leading: Checkbox(
        shape: CircleBorder(),
        value: false,
        onChanged: (bool? value) {
          markDoneAndupdateList(item, index);
          print('chenge $value');
        },
      ),
      title: Text(item.title!),
      subtitle: item.content!.trim().isNotEmpty ? Text(item.content!) : null,
      trailing: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          markStarAndUpdateList(item, index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: item.type == TodoType.star.value
              ? Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                )
              : Icon(
                  Icons.star_border_outlined,
                  color: Theme.of(context).colorScheme.outline,
                ),
        ),
      ),
    );
  }

  Widget _buildTabDoneContent(BuildContext context, int firstPage) {
    return CustomFutureBuilder(
      future: HttpCreator.todoListByStatus(firstPage, TodoStatus.done.value),
      onRefresh: () {
        setState(() {});
      },
      builder: (context, snapshot) {
        final TodoListModel todoListModel = snapshot.data;

        return RefreshableListView<Datas>(
          key: doneTodokey,
          initialItems: todoListModel.data!.datas!,
          loadMoreCallback: (page) async {
            final todoList = await HttpUtils.handleRequestData(() =>
                HttpCreator.todoListByStatus(page, TodoStatus.done.value));
            if (todoList != null) {
              return todoList.data!.datas;
            }
            return null;
          },
          itemBuilder: (context, item, index, length) {
            return ListTile(
              onTap: () {},
              leading: IconButton(
                icon: Icon(
                  Icons.done,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  markDoneAndupdateList(item, index);
                },
              ),
              title: Text(
                item.title!,
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              subtitle:
                  item.content!.trim().isNotEmpty ? Text(item.content!) : null,
            );
          },
          maxPage: todoListModel.data!.pageCount!,
          firstPage: firstPage,
        );
      },
    );
  }
}
