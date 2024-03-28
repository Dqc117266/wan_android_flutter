import 'package:flutter/material.dart';

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

class _ModalBottomSheetContent extends StatelessWidget {
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.access_time)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.star_border_outlined)),
                  ],
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(16),
                //     onTap: () {},
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //       child: Text("保存"),
                //     ),
                //   ),
                // )

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
}
