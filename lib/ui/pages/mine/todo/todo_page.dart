import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/todolist_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class TodoScreen extends StatelessWidget {
  static const routeName = "/todo";
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int firstPage = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.mine_todo.tr(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottom(context);
        },
        child: Icon(Icons.add),
      ),
      body: DefaultTabController(
        length: 3, // 指定选项卡的数量
        initialIndex: 1,
        child: Column(
          children: [
            TabBar(
              // 在AppBar的底部添加TabBar
              tabs: [
                Tab(
                  child: Icon(Icons.star),
                ), // 第一个选项卡
                Tab(text: '待办事项'), // 第二个选项卡
                Tab(text: '已完成'), // 第二个选项卡
              ],
            ),
            Expanded(
                child: TabBarView(
              children: [
                _buildTabStarContent(context, firstPage),
                _buildTabUndoneContent(context, firstPage),
                _buildTabDoneContent(context, firstPage),
              ],
            )),
          ],
        ),
      ),
    );
  }

  // 构建选项卡的内容，这里是您原来的页面内容
  Widget _buildTabUndoneContent(BuildContext context, int firstPage) {
    return CustomFutureBuilder(
      future: HttpCreator.todoList(firstPage),
      builder: (context, snapshot) {
        final TodoListModel todoListModel = snapshot.data;

        return RefreshableListView<Datas>(
          initialItems: todoListModel.data!.datas!,
          loadMoreCallback: (page) async {
            final todoList = await HttpUtils.handleRequestData(
                () => HttpCreator.todoList(page));
            if (todoList != null) {
              return todoList.data!.datas;
            }
            return null;
          },
          itemBuilder: (context, item, index, length) {
            return ListTile(
              onTap: () {},
              leading: Checkbox(
                shape: CircleBorder(),
                value: false,
                onChanged: (bool? value) {},
              ),
              title: Text(item.title!),
              trailing: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(Icons.star_border_outlined),
                ),
              ),
            );
          },
          maxPage: todoListModel.data!.pageCount!,
          firstPage: firstPage,
        );
      },
    );
  }

  Widget _buildTabStarContent(BuildContext context, int firstPage) {
    return CustomFutureBuilder(
      future: HttpCreator.todoList(firstPage),
      builder: (context, snapshot) {
        final TodoListModel todoListModel = snapshot.data;
        List<Datas> starItems = getStarItems(todoListModel.data!.datas!);

        return RefreshableListView<Datas>(
          initialItems: starItems,
          loadMoreCallback: (page) async {
            final todoList = await HttpUtils.handleRequestData(
                () => HttpCreator.todoList(page));
            if (todoList != null) {
              List<Datas> starItems = getStarItems(todoListModel.data!.datas!);
              return starItems;
            }
            return null;
          },
          itemBuilder: (context, item, index, length) {
            return ListTile(
              onTap: () {},
              leading: Checkbox(
                shape: CircleBorder(),
                value: false,
                onChanged: (bool? value) {},
              ),
              title: Text(item.title!),
              trailing: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(Icons.star_border_outlined),
                ),
              ),
            );
          },
          maxPage: todoListModel.data!.pageCount!,
          firstPage: firstPage,
        );
      },
    );
  }

  List<Datas> getStarItems(List<Datas> todoList) {
    return todoList.where((item) => item.type == 2).toList();
  }

  Widget _buildTabDoneContent(BuildContext context, int firstPage) {
    return Center(
      child: Text("Star"),
    );
  }

  void showModalBottom(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true, // !important
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // !important
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom), // !important
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '新建待办事项',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.access_time)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.star_border_outlined)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text("保存"),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
