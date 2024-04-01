import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/todolist_model.dart';
import 'package:wan_android_flutter/core/utils/TimeUtils.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/ui/pages/mine/todo/todolist_helper.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class TodoDetailScreen extends StatefulWidget {
  static const routeName = "/detail";
  GlobalKey<RefreshableListViewState<Datas>>? starTodokey;
  GlobalKey<RefreshableListViewState<Datas>>? unDoneTodokey;
  GlobalKey<RefreshableListViewState<Datas>>? doneTodokey;

  final GlobalKey? key;
  final Datas? data;

  TodoDetailScreen(
      {this.key,
      this.data,
      this.starTodokey,
      this.unDoneTodokey,
      this.doneTodokey})
      : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final String deleteValue = 'delete';

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  late TodoListHelper _todoListHelper;
  late DateTime curDateTime;

  bool isSelectStar = false;
  bool isDonedTodo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _titleController = TextEditingController(text: widget.data!.title);
    _contentController =
        TextEditingController(text: widget.data!.content!.trim());

    _todoListHelper = TodoListHelper(
        widget.starTodokey!, widget.unDoneTodokey!, widget.doneTodokey!);

    isSelectStar = widget.data!.type == TodoType.star.value;
    isDonedTodo = widget.data!.status == TodoStatus.done.value;

    curDateTime = TimeUtils.getDateTime(widget.data!.date!);
    print("type: ..${widget.data!.type}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 在这里定义您想要的操作
            _todoListHelper.changedTitleAndContentUpdateTodo(
                _titleController.text, _contentController.text, widget.data!);
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!isDonedTodo)
            IconButton(
              onPressed: () {
                setState(() {
                  _todoListHelper.markStarAndUpdateList(widget.data!);
                  isSelectStar = !isSelectStar;

                  widget.data!.type = isSelectStar
                      ? TodoType.star.value
                      : TodoType.normal.value;
                });
              },
              icon: isSelectStar
                  ? Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(Icons.star_border_outlined),
            ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == deleteValue) {
                // 在这里执行删除操作
                _todoListHelper.deleteTodoItem(widget.data!);
                Navigator.of(context).pop();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: deleteValue,
                child: Text('删除'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '输入标题',
                border: InputBorder.none,
              ),
              controller: _titleController,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  decoration: isDonedTodo ? TextDecoration.lineThrough : null),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.notes_outlined),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: '添加详细信息',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.access_time_outlined),
              SizedBox(width: 16),
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 设置圆角大小
                    ),
                  ),
                ),
                onPressed: () async {
                  curDateTime =
                      (await TimeUtils.selectTime(context, curDateTime))!;

                  widget.data!.dateStr = TimeUtils.formatDateYearTime(curDateTime);
                  setState(() {});
                },
                child: Text(TimeUtils.formatDateTime(curDateTime)),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 96,
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: 16, right: 16),
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            child: InkWell(
              onTap: () async {
                if (isDonedTodo) {
                  bool isChanged =
                      await _todoListHelper.markDoneAndupdateList(widget.data!);
                  if (isChanged) {
                    setState(() {
                      isDonedTodo = !isDonedTodo;
                    });
                    ToastUtils.showShortToast('已标记为未完成');
                  }
                } else {
                  bool isChanged =
                      await _todoListHelper.markDoneAndupdateList(widget.data!);
                  if (isChanged) {
                    setState(() {
                      isDonedTodo = !isDonedTodo;
                    });
                    ToastUtils.showShortToast('已标记为已完成');
                  }
                }

                widget.data!.status = isDonedTodo
                    ? TodoStatus.done.value
                    : TodoStatus.unDone.value;
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isDonedTodo ? "标记为未完成" : "标记为已完成",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
