import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/todolist_model.dart';
import 'package:wan_android_flutter/core/utils/TimeUtils.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

class TodoDetailScreen extends StatefulWidget {
  static const routeName = "/detail";

  final GlobalKey? key;
  final Datas? data;

  const TodoDetailScreen({this.key, this.data}) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final String deleteValue = 'delete';

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool isSelectStar = false;
  bool isDonedTodo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _titleController = TextEditingController(text: widget.data!.title);
    _contentController =
        TextEditingController(text: widget.data!.content!.trim());

    isSelectStar = widget.data!.type == TodoType.star.value;
    isDonedTodo = widget.data!.status == TodoStatus.done.value;

    print("type: ..${widget.data!.type}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isDonedTodo)
            IconButton(
              onPressed: () {
                setState(() {
                  isSelectStar = !isSelectStar;
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
                  TimeUtils.selectTime(
                      context, TimeUtils.getDateTime(widget.data!.date!));
                },
                child: Text(TimeUtils.formatDateTime(
                    TimeUtils.getDateTime(widget.data!.date!))),
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
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isDonedTodo ?
                  "标记为已完成" : "标记为未完成",
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
