import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/todolist_model.dart';
import 'package:wan_android_flutter/core/utils/TimeUtils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/mine/todo/todo_detail/todo_detail_page.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

import 'todolist_helper.dart';

class TodoScreen extends StatefulWidget {
  static const routeName = "/todo";

  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late TodoListHelper _todoListHelper;
  late TabController _tabController;
  int firstPage = 1;
  int tabIndex = 1;

  GlobalKey<RefreshableListViewState<Datas>> starTodokey = GlobalKey();
  GlobalKey<RefreshableListViewState<Datas>> unDoneTodokey = GlobalKey();
  GlobalKey<RefreshableListViewState<Datas>> doneTodokey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabChange);
    _todoListHelper = TodoListHelper(starTodokey, unDoneTodokey, doneTodokey);
  }

  void _handleTabChange() {
    tabIndex = _tabController.index;

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
            _todoListHelper.showAddTodoModalBottom(context, tabIndex);
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
            final todoList = await HttpUtils.handleRequestData(() =>
                HttpCreator.todoListByStatus(page, TodoStatus.unDone.value));
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

  Widget _buildTabStarContent(BuildContext context, int firstPage) {
    return CustomFutureBuilder(
      future: HttpCreator.todoListByTypeAndStatus(
          firstPage, TodoType.star.value, TodoStatus.unDone.value),
      onRefresh: () {
        setState(() {});
      },
      builder: (context, snapshot) {
        final TodoListModel todoListModel = snapshot.data;

        return RefreshableListView<Datas>(
          key: starTodokey,
          initialItems: todoListModel.data!.datas!,
          loadMoreCallback: (page) async {
            final todoList = await HttpUtils.handleRequestData(() =>
                HttpCreator.todoListByTypeAndStatus(
                    page, TodoType.star.value, TodoStatus.unDone.value));
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
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item.date!);

    OutlinedButton outlineBtn = OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 设置圆角大小
          ),
        ),
      ),
      onPressed: () async {
        final selectDate = await TimeUtils.selectTime(context, dateTime);
        if (selectDate != null) {
          _todoListHelper.updateTodoDate(item, index, selectDate);
        }
      },
      child: Text(
        TimeUtils.formatRelativeDate(dateTime),
        style: TextStyle(
          color: TimeUtils.isLateTime(dateTime)
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    return ListTile(
      onTap: () {
        _toDetailPage(item);
      },
      leading: Checkbox(
        shape: CircleBorder(),
        value: false,
        onChanged: (bool? value) {
          _todoListHelper.markDoneAndupdateList(item, index);
        },
      ),
      title: Text(item.title!),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.content!.trim().isNotEmpty) Text(item.content!),
          outlineBtn,
        ],
      ),
      trailing: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _todoListHelper.markStarAndUpdateList(item, index);
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
              onTap: () {
                _toDetailPage(item);
              },
              leading: IconButton(
                icon: Icon(
                  Icons.done,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  _todoListHelper.markDoneAndupdateList(item, index);
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

  void _toDetailPage(Datas item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailScreen(
          key: GlobalKey(),
          data: item,
        ),
      ),
    );
  }


}
