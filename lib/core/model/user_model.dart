import 'user_info_model.dart';

class UserModel {
  Data? data;
  int? errorCode;
  String? errorMsg;

  UserModel({this.data, this.errorCode, this.errorMsg});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class Data {
  CoinInfo? coinInfo;
  CollectArticleInfo? collectArticleInfo;
  UserData? userData;

  Data({this.coinInfo, this.collectArticleInfo, this.userData});

  Data.fromJson(Map<String, dynamic> json) {
    coinInfo = json['coinInfo'] != null
        ? new CoinInfo.fromJson(json['coinInfo'])
        : null;
    collectArticleInfo = json['collectArticleInfo'] != null
        ? new CollectArticleInfo.fromJson(json['collectArticleInfo'])
        : null;
    userData = json['userInfo'] != null
        ? new UserData.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coinInfo != null) {
      data['coinInfo'] = this.coinInfo!.toJson();
    }
    if (this.collectArticleInfo != null) {
      data['collectArticleInfo'] = this.collectArticleInfo!.toJson();
    }
    if (this.userData != null) {
      data['userInfo'] = this.userData!.toJson();
    }
    return data;
  }
}

class CoinInfo {
  int? coinCount;
  int? level;
  String? nickname;
  String? rank;
  int? userId;
  String? username;

  CoinInfo(
      {this.coinCount,
        this.level,
        this.nickname,
        this.rank,
        this.userId,
        this.username});

  CoinInfo.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json['level'];
    nickname = json['nickname'];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data['level'] = this.level;
    data['nickname'] = this.nickname;
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}

class CollectArticleInfo {
  int? count;

  CollectArticleInfo({this.count});

  CollectArticleInfo.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
