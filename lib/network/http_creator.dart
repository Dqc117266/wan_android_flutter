import 'package:dio/dio.dart';
import 'package:wan_android_flutter/core/extensions/string_extension.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/core/model/hotkey_model.dart';
import 'package:wan_android_flutter/core/model/rinks_model.dart';
import 'package:wan_android_flutter/core/model/todo_model.dart';
import 'package:wan_android_flutter/core/model/tree_model.dart';
import 'package:wan_android_flutter/core/model/user_rink_list_model.dart';
import 'package:wan_android_flutter/core/model/user_rink_model.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/network/api.dart';
import '../core/model/collects_model.dart';
import '../core/model/front_top_artcles_model.dart';
import '../core/model/result_model.dart';
import '../core/model/todolist_model.dart';
import '../core/model/user_info_model.dart';
import '../core/model/wxartcle_model.dart';
import 'api_service.dart';

class HttpCreator {
  static ApiService apiService = ApiService();

  static Future<T> fetchData<T>(
    String path,
    T Function(dynamic json) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = queryParameters != null
          ? await apiService.post(path, queryParameters: queryParameters)
          : await apiService.get(path);

      print("HttpCreator: $response");

      if (response.data["errorCode"] == -1001) { //未登陆
        UserUtils.clearUserInfo();
      }
      return fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      return fromJson({});
    }
  }

  static Future<FrontArtclesModel> getFrontList(int page) async {
    return fetchData<FrontArtclesModel>(Api.frontList.addCeilUrl(page),
        (json) => FrontArtclesModel.fromJson(json));
  }

  static Future<FrontTopArtclesModel> getFrontTopList() async {
    return fetchData<FrontTopArtclesModel>(Api.frontTopList,
            (json) => FrontTopArtclesModel.fromJson(json));
  }

  static Future<FrontBannerModel> getBanner() async {
    return fetchData<FrontBannerModel>(
        Api.frontBanner, (json) => FrontBannerModel.fromJson(json));
  }

  //项目分类
  static Future<TreeModel> getProjectClassify() {
    return fetchData(Api.projectClassify, (json) => TreeModel.fromJson(json));
  }

  //项目列表数据
  static Future<FrontArtclesModel> getProjectList(int page, int cid) {
    return fetchData("${Api.projectList}$page/json?cid=$cid",
        (json) => FrontArtclesModel.fromJson(json));
  }

  static Future<UserInfoModel> login(String username, String password) {
    Map<String, dynamic> data = {"username": username, "password": password};

    return fetchData(Api.login, (json) => UserInfoModel.fromJson(json),
        queryParameters: data);
  }

  static Future<UserInfoModel> register(
      String username, password, String repassword) {
    Map<String, dynamic> data = {
      "username": username,
      "password": password,
      "repassword": repassword
    };

    return fetchData(Api.register, (json) => UserInfoModel.fromJson(json),
        queryParameters: data);
  }

  static Future<UserInfoModel> logout() {
    return fetchData(Api.logout, (json) => UserInfoModel.fromJson(json));
  }

  //收藏文章列表
  static Future<CollectsModel> getCollectList(int page) {
    return fetchData(
        Api.collectList.addCeilUrl(page), (json) => CollectsModel.fromJson(json));
  }

  //收藏站内文章 POST请求
  static Future<ResultModel> collectChapter(int id) {
    return fetchData(
        Api.collect.addCeilUrl(id), (json) => ResultModel.fromJson(json),
        queryParameters: {});
  }

  //收藏站外文章 POST请求
  static Future<CollectsModel> collectOutChapter(
      String title, String author, String link) {
    return fetchData(Api.collectOut, (json) => CollectsModel.fromJson(json),
        queryParameters: {"title": title, "author": author, "link": link});
  }

  //取消收藏
  static Future<ResultModel> uncollect(int id) {
    return fetchData(
        Api.unCollect.addCeilUrl(id), (json) => ResultModel.fromJson(json),
        queryParameters: {});
  }

  //取消我的收藏页面  (我的收藏页面（该页面包含自己录入的内容）)
  static Future<ResultModel> unMyCollect(int id, int originId) {
    return fetchData(
        Api.unMyCollect.addCeilUrl(id), (json) => ResultModel.fromJson(json),
        queryParameters: {"originId": originId});
  }

  //搜索页面
  static Future<FrontArtclesModel> query(int page, String k) {
    return fetchData(
        Api.query.addCeilUrl(page), (json) => FrontArtclesModel.fromJson(json),
        queryParameters: {"k": k});
  }

  static Future<HotKeyModel> getHotKey() {
    return fetchData(Api.hotkey, (json) => HotKeyModel.fromJson(json));
  }

  //新增一个TODO
  static Future<TodoModel> todoAdd(
      String title, String content, String date, int type, int priority) {
    final Map<String, dynamic> data = {
      "title": title,
      "content": content,
      "date": date,
      "type": type,
      "priority": priority
    };

    return fetchData(Api.todoAdd, (json) => TodoModel.fromJson(json),
        queryParameters: data);
  }

  //新增一个TODO

  /*
  *
  * 参数：
	id: 拼接在链接上，为唯一标识，列表数据返回时，每个todo 都会有个id标识 （必须）
	title: 更新标题 （必须）
	content: 新增详情（必须）
	date: 2018-08-01（必须）
	status: 0 // 0为未完成，1为完成
	type: ；
	priority: ；
  *
  * */
  static Future<TodoModel> todoUpdate(int id, String title, String content,
      String date, int status, int type, int priority) {

    final Map<String, dynamic> data = {
      "id": id,
      "title": title,
      "content": content,
      "date": date,
      "status": status,
      "type": type,
      "priority": priority
    };

    return fetchData(Api.todoUpdate.addCeilUrl(id), (json) => TodoModel.fromJson(json),
        queryParameters: data);
  }

  static Future<ResultModel> todoDelete(int id) {

    return fetchData(Api.todoDelete.addCeilUrl(id), (json) => ResultModel.fromJson(json),
        queryParameters: {});
  }

  //4. 仅更新完成状态Todo

  /*
  * 参数：
	id: 拼接在链接上，为唯一标识
	status: 0或1，传1代表未完成到已完成，反之则反之。
  * */
  static Future<ResultModel> todoDone(int id, int status) {

    return fetchData(Api.todoDone.addCeilUrl(id), (json) => ResultModel.fromJson(json),
        queryParameters: {"status" : status});
  }


  /*
  *
  * 	页码从1开始，拼接在url 上
	status 状态， 1-完成；0未完成; 默认全部展示；
	type 创建时传入的类型, 默认全部展示
	priority 创建时传入的优先级；默认全部展示
	orderby 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
  *
  * */
  static Future<TodoListModel> todoList(int page) {

    return fetchData(Api.todoList.addCeilUrl(page), (json) => TodoListModel.fromJson(json),
        queryParameters: {});
  }

  static Future<UserInfoModel> getUserInfo() {

    return fetchData(Api.userInfo, (json) => UserInfoModel.fromJson(json));
  }

  //获取公众号列表
  static Future<WxartcleModel> wxarticleChapters() {

    return fetchData(Api.wxarticleChapters, (json) => WxartcleModel.fromJson(json));
  }

  //查看某个公众号历史数据
  static Future<FrontArtclesModel> wxarticleList(int id, int page) {

    return fetchData("${Api.wxarticleList}$id/$page/json", (json) => FrontArtclesModel.fromJson(json));
  }

  //积分排行榜接口
  static Future<RinksModel> getRinksTop(int page) {
    return fetchData(Api.coinTop.addCeilUrl(page), (json) => RinksModel.fromJson(json));
  }

  //获取个人积分排行
  static Future<UserRinkModel> getUserRink() {

    return fetchData(Api.coinUser, (json) => UserRinkModel.fromJson(json));
  }

  //获取个人积分获取列表
  static Future<UserRinkListModel> getCoinUserList(int page) {

    return fetchData(Api.coinUserList.addCeilUrl(page), (json) => UserRinkListModel.fromJson(json));
  }


}
