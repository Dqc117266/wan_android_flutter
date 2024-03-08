class FriendModel {
  List<Data>? _data;
  int? _errorCode;
  String? _errorMsg;

  FriendModel({List<Data>? data, int? errorCode, String? errorMsg}) {
    if (data != null) {
      this._data = data;
    }
    if (errorCode != null) {
      this._errorCode = errorCode;
    }
    if (errorMsg != null) {
      this._errorMsg = errorMsg;
    }
  }

  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;
  int? get errorCode => _errorCode;
  set errorCode(int? errorCode) => _errorCode = errorCode;
  String? get errorMsg => _errorMsg;
  set errorMsg(String? errorMsg) => _errorMsg = errorMsg;

  FriendModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
    _errorCode = json['errorCode'];
    _errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this._errorCode;
    data['errorMsg'] = this._errorMsg;
    return data;
  }
}

class Data {
  String? _category;
  String? _icon;
  int? _id;
  String? _link;
  String? _name;
  int? _order;
  int? _visible;

  Data(
      {String? category,
        String? icon,
        int? id,
        String? link,
        String? name,
        int? order,
        int? visible}) {
    if (category != null) {
      this._category = category;
    }
    if (icon != null) {
      this._icon = icon;
    }
    if (id != null) {
      this._id = id;
    }
    if (link != null) {
      this._link = link;
    }
    if (name != null) {
      this._name = name;
    }
    if (order != null) {
      this._order = order;
    }
    if (visible != null) {
      this._visible = visible;
    }
  }

  String? get category => _category;
  set category(String? category) => _category = category;
  String? get icon => _icon;
  set icon(String? icon) => _icon = icon;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get link => _link;
  set link(String? link) => _link = link;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get order => _order;
  set order(int? order) => _order = order;
  int? get visible => _visible;
  set visible(int? visible) => _visible = visible;

  Data.fromJson(Map<String, dynamic> json) {
    _category = json['category'];
    _icon = json['icon'];
    _id = json['id'];
    _link = json['link'];
    _name = json['name'];
    _order = json['order'];
    _visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this._category;
    data['icon'] = this._icon;
    data['id'] = this._id;
    data['link'] = this._link;
    data['name'] = this._name;
    data['order'] = this._order;
    data['visible'] = this._visible;
    return data;
  }
}
