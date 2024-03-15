import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageScreen extends StatefulWidget {
  static final routeName = "/webview";

  @override
  State<WebPageScreen> createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<WebPageScreen> {
  late WebViewController _controller;
  late List<Widget> _buttonList;
  double _progress = 0.0;
  bool _isLoading = true;
  String? title;
  String? url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialize();
    _initButtonItem();
  }

  void _initialize() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initModalRoute();
      _initWebViewController();
      setState(() {});
    });
  }

  void _initButtonItem() {
    final List<Widget> buttonList = <Widget>[
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            _initialize();
          },
          icon: const Icon(Icons.refresh)),
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            _launchUrl(url!);
          },
          icon: const Icon(Icons.open_in_browser)),
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.share)),
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            _copyToClipboard(url!);
          },
          icon: const Icon(Icons.copy)),
    ];

    final List<Text> labelList = <Text>[
      Text(LocaleKeys.webpage_labelList_refresh.tr()),
      Text(LocaleKeys.webpage_labelList_toBrowser.tr()),
      Text(LocaleKeys.webpage_labelList_share.tr()),
      Text(LocaleKeys.webpage_labelList_copyLink.tr()),
    ];

    _buttonList = List.generate(
        buttonList.length,
        (index) => Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 30.0, 20.0, 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buttonList[index],
                  labelList[index],
                ],
              ),
            ));
  }

  Future<void> _initModalRoute() async {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    title = data["title"];
    url = data["url"];
  }

  Future<void> _initWebViewController() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(url!));
  }

  @override
  Widget build(BuildContext context) {
    if (title == null || url == null) {
      // 还未初始化完成，显示loading状态
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet<void>(
                showDragHandle: true,
                context: context,
                constraints: const BoxConstraints(maxWidth: 640),
                builder: (context) {
                  return SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: _buttonList,
                      ),
                    ),
                  );
                },
              );
              // 点击更多按钮时的操作
              // _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            LinearProgressIndicator(
              value: _progress,
              minHeight: 2.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary),
            ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      print('Text copied to clipboard: $text');
      _showToast(LocaleKeys.webpage_toastContent_toastSuccess.tr());
    }).catchError((error) {
      print('Error copying to clipboard: $error');
      _showToast(LocaleKeys.webpage_toastContent_toastFailed.tr());
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _shareContent(String content) {}

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }
}
