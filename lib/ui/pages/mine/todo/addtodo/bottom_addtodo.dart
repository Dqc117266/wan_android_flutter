import 'package:flutter/material.dart';

class KeyboardAwareBottomWidget extends StatefulWidget {
  @override
  _KeyboardAwareBottomWidgetState createState() =>
      _KeyboardAwareBottomWidgetState();
}

class _KeyboardAwareBottomWidgetState extends State<KeyboardAwareBottomWidget> {
  double _keyboardHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('Keyboard Aware Bottom Widget'),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showBottomSheet(context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        child: Center(
                          child: TextField(),
                        ),
                      );
                    },);
                },
                child: Text('Show Bottom Sheet'),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: _keyboardHeight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type something...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().addListener(_keyboardVisibility);
  }

  @override
  void dispose() {
    KeyboardVisibilityController().removeListener(_keyboardVisibility);
    super.dispose();
  }

  void _keyboardVisibility() {
    setState(() {
      _keyboardHeight =
      KeyboardVisibilityController().isVisible ? 0.0 : kToolbarHeight;
    });
  }
}

class KeyboardVisibilityController extends ChangeNotifier {
  factory KeyboardVisibilityController() => _instance;
  KeyboardVisibilityController._internal();
  static final KeyboardVisibilityController _instance =
  KeyboardVisibilityController._internal();

  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void setVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
  }
}
