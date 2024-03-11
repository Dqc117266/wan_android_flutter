class Api {
  static const String baseUrl = "https://www.wanandroid.com";

  static const String frontList = "/article/list/";
  static const String frontBanner = "/banner/json";
  static const String treesList = "/tree/json";
  static const String treesDetailList = "/article/list/";
  static const String projectClassify = "/project/tree/json";
  static const String projectList = "/project/list/"; //https://www.wanandroid.com/project/list/1/json?cid=294
  static const String login = "/user/login";
  static const String register = "/user/register";
  static const String logout = "/user/logout/json";
  static const String userInfo = "/user/lg/userinfo/json";
  static const String collectList = "/lg/collect/list/";   ///lg/collect/list/0/json
  static const String collect = "/lg/collect/";  ///lg/collect/1165/json
  static const String collectOut = "/lg/collect/add/json";
  static const String unCollect = "/lg/uncollect_originId/";
  static const String unMyCollect = "/lg/uncollect/";
  static const String query = "/article/query/";

  static const String todoAdd = "/lg/todo/add/json";
  static const String todoUpdate = "/lg/todo/update/";
  static const String todoDelete = "/lg/todo/delete/";
  static const String todoDone = "/lg/todo/done/";
  static const String todoList = "/lg/todo/v2/list/";

  static const String wxarticleChapters = "/wxarticle/chapters/json";
  static const String wxarticleList = "/wxarticle/list/";
}