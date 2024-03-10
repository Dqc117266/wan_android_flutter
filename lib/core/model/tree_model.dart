class TreeModel {
  List<String>? articleList;
  String? author;
  List<String>? children;
  int? courseId;
  String? cover;
  String? desc;
  int? id;
  String? lisense;
  String? lisenseLink;
  String? name;
  int? order;
  int? parentChapterId;
  int? type;
  String? userControlSetTop;
  int? visible;

  TreeModel({
    this.articleList,
    this.author,
    this.children,
    this.courseId,
    this.cover,
    this.desc,
    this.id,
    this.lisense,
    this.lisenseLink,
    this.name,
    this.order,
    this.parentChapterId,
    this.type,
    this.userControlSetTop,
    this.visible,
  });

  factory TreeModel.fromJson(Map<String, dynamic> json) => TreeModel(
    articleList: List<String>.from(json["articleList"] ?? []),
    author: json["author"],
    children: List<String>.from(json["children"] ?? []),
    courseId: json["courseId"],
    cover: json["cover"],
    desc: json["desc"],
    id: json["id"],
    lisense: json["lisense"],
    lisenseLink: json["lisenseLink"],
    name: json["name"],
    order: json["order"],
    parentChapterId: json["parentChapterId"],
    type: json["type"],
    userControlSetTop: json["userControlSetTop"],
    visible: json["visible"],
  );

  Map<String, dynamic> toJson() => {
    "articleList": List<dynamic>.from(articleList ?? []),
    "author": author,
    "children": List<dynamic>.from(children ?? []),
    "courseId": courseId,
    "cover": cover,
    "desc": desc,
    "id": id,
    "lisense": lisense,
    "lisenseLink": lisenseLink,
    "name": name,
    "order": order,
    "parentChapterId": parentChapterId,
    "type": type,
    "userControlSetTop": userControlSetTop,
    "visible": visible,
  };
}

class DataItem {
  List<String>? articleList;
  String? author;
  List<TreeModel>? children;
  int? courseId;
  String? cover;
  String? desc;
  int? id;
  String? lisense;
  String? lisenseLink;
  String? name;
  int? order;
  int? parentChapterId;
  int? type;
  String? userControlSetTop;
  int? visible;

  DataItem({
    this.articleList,
    this.author,
    this.children,
    this.courseId,
    this.cover,
    this.desc,
    this.id,
    this.lisense,
    this.lisenseLink,
    this.name,
    this.order,
    this.parentChapterId,
    this.type,
    this.userControlSetTop,
    this.visible,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
    articleList: List<String>.from(json["articleList"] ?? []),
    author: json["author"],
    children: List<TreeModel>.from(
        (json["children"] ?? []).map((x) => TreeModel.fromJson(x))),
    courseId: json["courseId"],
    cover: json["cover"],
    desc: json["desc"],
    id: json["id"],
    lisense: json["lisense"],
    lisenseLink: json["lisenseLink"],
    name: json["name"],
    order: json["order"],
    parentChapterId: json["parentChapterId"],
    type: json["type"],
    userControlSetTop: json["userControlSetTop"],
    visible: json["visible"],
  );

  Map<String, dynamic> toJson() => {
    "articleList": List<dynamic>.from(articleList ?? []),
    "author": author,
    "children": List<dynamic>.from(children?.map((x) => x.toJson()) ?? []),
    "courseId": courseId,
    "cover": cover,
    "desc": desc,
    "id": id,
    "lisense": lisense,
    "lisenseLink": lisenseLink,
    "name": name,
    "order": order,
    "parentChapterId": parentChapterId,
    "type": type,
    "userControlSetTop": userControlSetTop,
    "visible": visible,
  };
}

class Root {
  List<DataItem>? data;
  int? errorCode;
  String? errorMsg;

  Root({
    this.data,
    this.errorCode,
    this.errorMsg,
  });

  factory Root.fromJson(Map<String, dynamic> json) => Root(
    data: List<DataItem>.from(
        (json["data"] ?? []).map((x) => DataItem.fromJson(x))),
    errorCode: json["errorCode"],
    errorMsg: json["errorMsg"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
    "errorCode": errorCode,
    "errorMsg": errorMsg,
  };
}
