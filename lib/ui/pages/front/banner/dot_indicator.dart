import 'package:flutter/material.dart';

class DotIndicatorRow extends StatefulWidget {
  final int length;

  DotIndicatorRow({Key? key, required this.length}): super(key: key);

  @override
  DotIndicatorRowState createState() => DotIndicatorRowState();
}

class DotIndicatorRowState extends State<DotIndicatorRow> {
  int _current = 0;

  void setCurrent(int index) {
    print("banner current index: $index");

    setState(() {
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 6.0,
          height: 6.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary
                .withOpacity(_current == index ? 1 : 0.4),
          ),
        );
      }),
    );
  }
}
