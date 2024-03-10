class UserInfoModel {
  int? coinCount;
  int? level;
  String? nickname;
  String? rank;
  int? userId;
  String? username;

  UserInfoModel({
    this.coinCount,
    this.level,
    this.nickname,
    this.rank,
    this.userId,
    this.username,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    coinCount: json["coinCount"],
    level: json["level"],
    nickname: json["nickname"],
    rank: json["rank"],
    userId: json["userId"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "coinCount": coinCount,
    "level": level,
    "nickname": nickname,
    "rank": rank,
    "userId": userId,
    "username": username,
  };
}

class CollectArticleInfo {
  int? count;

  CollectArticleInfo({
    this.count,
  });

  factory CollectArticleInfo.fromJson(Map<String, dynamic> json) =>
      CollectArticleInfo(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
    "count": count,
  };
}

class UserInfo {
  String? admin;
  List<String>? chapterTops;
  int? coinCount;
  List<String>? collectIds;
  String? email;
  String? icon;
  int? id;
  String? nickname;
  String? password;
  String? publicName;
  String? token;
  int? type;
  String? username;

  UserInfo({
    this.admin,
    this.chapterTops,
    this.coinCount,
    this.collectIds,
    this.email,
    this.icon,
    this.id,
    this.nickname,
    this.password,
    this.publicName,
    this.token,
    this.type,
    this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    admin: json["admin"],
    chapterTops: List<String>.from(json["chapterTops"] ?? []),
    coinCount: json["coinCount"],
    collectIds: List<String>.from(json["collectIds"] ?? []),
    email: json["email"],
    icon: json["icon"],
    id: json["id"],
    nickname: json["nickname"],
    password: json["password"],
    publicName: json["publicName"],
    token: json["token"],
    type: json["type"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "admin": admin,
    "chapterTops": chapterTops,
    "coinCount": coinCount,
    "collectIds": collectIds,
    "email": email,
    "icon": icon,
    "id": id,
    "nickname": nickname,
    "password": password,
    "publicName": publicName,
    "token": token,
    "type": type,
    "username": username,
  };
}

class Data {
  UserInfoModel? coinInfo;
  CollectArticleInfo? collectArticleInfo;
  UserInfo? userInfo;

  Data({
    this.coinInfo,
    this.collectArticleInfo,
    this.userInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    coinInfo: UserInfoModel.fromJson(json["coinInfo"]),
    collectArticleInfo:
    CollectArticleInfo.fromJson(json["collectArticleInfo"]),
    userInfo: UserInfo.fromJson(json["userInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "coinInfo": coinInfo?.toJson(),
    "collectArticleInfo": collectArticleInfo?.toJson(),
    "userInfo": userInfo?.toJson(),
  };
}

class Root {
  Data? data;
  int? errorCode;
  String? errorMsg;

  Root({
    this.data,
    this.errorCode,
    this.errorMsg,
  });

  factory Root.fromJson(Map<String, dynamic> json) => Root(
    data: Data.fromJson(json["data"]),
    errorCode: json["errorCode"],
    errorMsg: json["errorMsg"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "errorCode": errorCode,
    "errorMsg": errorMsg,
  };
}
