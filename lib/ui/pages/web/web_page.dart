import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/model/front_articles_model.dart';

class WebPageScreen extends StatefulWidget {
  static const routeName = "/webview";

  @override
  State<WebPageScreen> createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<WebPageScreen> {
  WebViewController? _controller;
  late List<Widget> _buttonList;
  double _progress = 0.0;
  bool _isLoading = true;

  Datas? datas;
  String? title;
  String? url;
  int? id;
  bool collect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialize();
    _initButtonItem();
  }

  void _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            _shareContent(url!);
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
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments is Map<String, dynamic>) {

      title = arguments['title'];
      url = arguments['url'];
      id = arguments['id'];
      collect = arguments['collect'];
    } else if (arguments is Datas) {

      datas = arguments;
      title = datas!.title;
      url = datas!.link;
      id = datas!.id;
      collect = datas!.collect!;
    }

    if (!isURL(url!)) {
      url = '${Api.baseUrl}$url';
    }

  }

  bool isURL(String string) {
    // URL 的正则表达式模式
    final RegExp urlRegex = RegExp(
      r'^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+(?:[\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
      caseSensitive: false,
      multiLine: false,
    );

    // 使用正则表达式匹配字符串
    return urlRegex.hasMatch(string);
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
    if (url == null || title == null || _controller == null) {
      // 还未初始化完成，显示 loading 状态
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        actions: [
          IconButton(
            onPressed: () {
              _collecAndUnCollec();
            },
            icon: collect ? Icon(Icons.favorite,
                color: Theme.of(context).colorScheme.primary) : Icon(Icons.favorite_border,
                color: Theme.of(context).colorScheme.primary),
          ),

          IconButton(
            icon: const Icon(Icons.more_vert),
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
          WebViewWidget(controller: _controller!),
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
      ToastUtils.showShortToast(
          LocaleKeys.webpage_toastContent_toastSuccess.tr());
    }).catchError((error) {
      print('Error copying to clipboard: $error');
      ToastUtils.showShortToast(
          LocaleKeys.webpage_toastContent_toastFailed.tr());
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _shareContent(String content) {
    Share.share(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller = null;
    super.dispose();
  }

  void _collecAndUnCollec() async {
    if (!collect) { //收藏
      final value = await HttpUtils.collectChapter(context, id!);
      if (value != null && value.errorCode == 0) {
        setState(() {
          collect = !collect;
        });

        final userInfo = await UserUtils.getUserInfo();
        final ids = userInfo!.data!.collectIds!;
        if (!ids.contains(id)) {
          ids.add(id!);
        }
        await UserUtils.saveUserInfo(userInfo);

        Provider.of<UserViewModel>(context, listen: false).updateUser();
      }
    } else {//取消收藏
      final value = await HttpUtils.unCollectChapter(context, id!);

      if (value != null && value.errorCode == 0) {
        setState(() {
          collect = !collect;
        });

        final userInfo = await UserUtils.getUserInfo();
        final ids = userInfo!.data!.collectIds!;
        if (ids.contains(id)) {
          ids.remove(id!);
        }
        await UserUtils.saveUserInfo(userInfo);

        Provider.of<UserViewModel>(context, listen: false).updateUser();
      }
    }
  }


}
