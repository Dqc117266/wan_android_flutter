class WxartcleModel {
  List<String>? articleList;
  String? author;
  List<String>? children;
  int? courseId;
  String? cover;
  String? desc;
  int? id;
  String? license;
  String? licenseLink;
  String? name;
  int? order;
  int? parentChapterId;
  int? type;
  bool? userControlSetTop;
  int? visible;

  WxartcleModel({
    this.articleList,
    this.author,
    this.children,
    this.courseId,
    this.cover,
    this.desc,
    this.id,
    this.license,
    this.licenseLink,
    this.name,
    this.order,
    this.parentChapterId,
    this.type,
    this.userControlSetTop,
    this.visible,
  });

  factory WxartcleModel.fromJson(Map<String, dynamic> json) {
    return WxartcleModel(
      articleList: (json['articleList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      author: json['author'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      courseId: json['courseId'] as int?,
      cover: json['cover'] as String?,
      desc: json['desc'] as String?,
      id: json['id'] as int?,
      license: json['lisense'] as String?, // 注意这里的命名可能需要调整
      licenseLink: json['lisenseLink'] as String?,
      name: json['name'] as String?,
      order: json['order'] as int?,
      parentChapterId: json['parentChapterId'] as int?,
      type: json['type'] as int?,
      userControlSetTop: json['userControlSetTop'] as bool?,
      visible: json['visible'] as int?,
    );
  }
}

class Root {
  List<WxartcleModel>? data;
  int? errorCode;
  String? errorMsg;

  Root({
    this.data,
    this.errorCode,
    this.errorMsg,
  });

  factory Root.fromJson(Map<String, dynamic> json) {
    return Root(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WxartcleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorCode: json['errorCode'] as int?,
      errorMsg: json['errorMsg'] as String?,
    );
  }
}
