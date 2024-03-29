import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/utils/TimeUtils.dart';

class AddTodoModalBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return _ModalBottomSheetContent();
      },
    );
  }
}

class _ModalBottomSheetContent extends StatefulWidget {
  @override
  State<_ModalBottomSheetContent> createState() =>
      _ModalBottomSheetContentState();
}

class _ModalBottomSheetContentState extends State<_ModalBottomSheetContent> {
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
                  selectDate = await _selectTime(context);
                  setState(() {});
                },
                child: Text(TimeUtils.formatRelativeDate(selectDate)),
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
                      onPressed: () {},
                      child: Text("保存")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime> _selectTime(BuildContext context) async {
    // Show the time picker dialog
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2020), // Set the first allowable date
      lastDate: DateTime(2025), // Set the last allowable date
    );

    return selectedDate!;
  }

}
