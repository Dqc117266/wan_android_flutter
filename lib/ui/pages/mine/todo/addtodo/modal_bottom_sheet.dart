import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/todo_model.dart';
import 'package:wan_android_flutter/core/utils/TimeUtils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

class AddTodoModalBottomSheet {
  static void show(BuildContext context, Function(TodoModel?) callback) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return _ModalBottomSheetContent(callback: callback,);
      },
    );
  }
}

class _ModalBottomSheetContent extends StatefulWidget {
  final Function(TodoModel?) callback;

  const _ModalBottomSheetContent({required this.callback});

  @override
  State<_ModalBottomSheetContent> createState() =>
      _ModalBottomSheetContentState();
}

class _ModalBottomSheetContentState extends State<_ModalBottomSheetContent> {
  final TextEditingController _titleEditcontroller = TextEditingController();
  final TextEditingController _contentEditcontroller = TextEditingController();

  bool isTitleNotEmpty = false;
  bool isAddDetailContent = false;
  bool isMarkStar = false;
  late DateTime selectDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    selectDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 24),
              child: TextField(
                controller: _titleEditcontroller,
                onChanged: (value) {
                  setState(() {
                    isTitleNotEmpty = value.isNotEmpty;
                  });
                },
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '新建待办事项',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (isAddDetailContent)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  controller: _contentEditcontroller,
                  decoration: InputDecoration(
                    hintText: '添加详细内容',
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 设置圆角大小
                    ),
                  ),
                ),
                onPressed: () async {
                  selectDate = (await TimeUtils.selectTime(context, selectDate))!;
                  setState(() {});
                },
                child: Text(TimeUtils.formatDateTime(selectDate)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          if (!isAddDetailContent) {
                            setState(() {
                              isAddDetailContent = true;
                            });
                          }
                        },
                        icon: Icon(Icons.notes_outlined)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isMarkStar = !isMarkStar;
                          });
                        },
                        icon: isMarkStar
                            ? Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : Icon(Icons.star_border_outlined)),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide.none),
                      ),
                      onPressed: isTitleNotEmpty ? () {
                        _addTodo(context);
                      } : null,
                      child: Text("保存")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo(BuildContext context) async {
    final content = _contentEditcontroller.text;

    final TodoModel? todoModel = await HttpUtils.handleRequestData(() => HttpCreator.todoAdd(
        _titleEditcontroller.text,
        content.isNotEmpty? content : " ",
        TimeUtils.formatDateYearTime(selectDate),
        isMarkStar ? TodoType.star.value : TodoType.normal.value,
        0));

    if (todoModel != null) {
      widget.callback(todoModel);
      Navigator.of(context).pop();
    }

  }
}
