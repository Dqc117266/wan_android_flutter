import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final ValueNotifier<bool> obscureTextNotifier;
  final bool isPassword;
  final FocusNode focusNode;
  final String? errorText;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.obscureTextNotifier,
    required this.focusNode,
    required this.errorText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? mErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.obscureTextNotifier,
      builder: (context, isObscured, child) {
        return TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: widget.isPassword && isObscured,
          onChanged: (value) {
            widget.obscureTextNotifier.value = value.isNotEmpty;
            _handleFocusChange();
          },
          decoration: InputDecoration(
            errorText: mErrorText,
            labelText: widget.labelText,
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            suffixIcon: widget.isPassword && widget.controller.text.isNotEmpty
                ? IconButton(
              icon: Icon(isObscured
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                widget.obscureTextNotifier.value = !isObscured;
              },
            )
                : widget.controller.text.isNotEmpty
                ? IconButton(
              onPressed: () {
                widget.controller.clear();
                widget.obscureTextNotifier.value = widget.controller.text.isNotEmpty;
              },
              icon: Icon(Icons.clear),
            )
                : null,
          ),
        );
      },
    );
  }

  // 添加监听焦点变化的方法
  void _handleFocusChange() {
    print("_handleFocusChange ${widget.controller.text.length} hasFocus: ${!widget.focusNode.hasFocus}");
    if (!widget.focusNode.hasFocus && widget.controller.text.length < 6 && !widget.controller.text.isEmpty) {
      // 当焦点失去并且文本长度小于6时，更新错误文本
      setState(() {
        mErrorText = widget.errorText;
      });
    } else {
      // 其他情况下清除错误文本
      setState(() {
        mErrorText = null;
      });
    }
  }
}
