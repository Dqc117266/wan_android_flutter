class Datas {
  late int coinCount;
  late int level;
  late String nickname;
  late String rank;
  late int userId;
  late String username;

  Datas({
    required this.coinCount,
    required this.level,
    required this.nickname,
    required this.rank,
    required this.userId,
    required this.username,
  });

  Datas.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json['level'];
    nickname = json['nickname'];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coinCount'] = coinCount;
    data['level'] = level;
    data['nickname'] = nickname;
    data['rank'] = rank;
    data['userId'] = userId;
    data['username'] = username;
    return data;
  }
}

class Data {
  late int curPage;
  late List<Datas> datas;
  late int offset;
  late bool over;
  late int pageCount;
  late int size;
  late int total;

  Data({
    required this.curPage,
    required this.datas,
    required this.offset,
    required this.over,
    required this.pageCount,
    required this.size,
    required this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'];
    datas = List<Datas>.from(json['datas'].map((x) => Datas.fromJson(x)));
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['curPage'] = curPage;
    data['datas'] = List<dynamic>.from(datas.map((x) => x.toJson()));
    data['offset'] = offset;
    data['over'] = over;
    data['pageCount'] = pageCount;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

class RinksModel {
  late Data data;
  late int errorCode;
  late String errorMsg;

  RinksModel({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
  });

  RinksModel.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.toJson();
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}
