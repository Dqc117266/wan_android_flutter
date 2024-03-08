class FrontBannerModel {
  List<Data>? _data;
  int? _errorCode;
  String? _errorMsg;

  FrontBannerModel({List<Data>? data, int? errorCode, String? errorMsg}) {
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

  FrontBannerModel.fromJson(Map<String, dynamic> json) {
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
  String? _desc;
  int? _id;
  String? _imagePath;
  int? _isVisible;
  int? _order;
  String? _title;
  int? _type;
  String? _url;

  Data(
      {String? desc,
        int? id,
        String? imagePath,
        int? isVisible,
        int? order,
        String? title,
        int? type,
        String? url}) {
    if (desc != null) {
      this._desc = desc;
    }
    if (id != null) {
      this._id = id;
    }
    if (imagePath != null) {
      this._imagePath = imagePath;
    }
    if (isVisible != null) {
      this._isVisible = isVisible;
    }
    if (order != null) {
      this._order = order;
    }
    if (title != null) {
      this._title = title;
    }
    if (type != null) {
      this._type = type;
    }
    if (url != null) {
      this._url = url;
    }
  }

  String? get desc => _desc;
  set desc(String? desc) => _desc = desc;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get imagePath => _imagePath;
  set imagePath(String? imagePath) => _imagePath = imagePath;
  int? get isVisible => _isVisible;
  set isVisible(int? isVisible) => _isVisible = isVisible;
  int? get order => _order;
  set order(int? order) => _order = order;
  String? get title => _title;
  set title(String? title) => _title = title;
  int? get type => _type;
  set type(int? type) => _type = type;
  String? get url => _url;
  set url(String? url) => _url = url;

  Data.fromJson(Map<String, dynamic> json) {
    _desc = json['desc'];
    _id = json['id'];
    _imagePath = json['imagePath'];
    _isVisible = json['isVisible'];
    _order = json['order'];
    _title = json['title'];
    _type = json['type'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this._desc;
    data['id'] = this._id;
    data['imagePath'] = this._imagePath;
    data['isVisible'] = this._isVisible;
    data['order'] = this._order;
    data['title'] = this._title;
    data['type'] = this._type;
    data['url'] = this._url;
    return data;
  }
}
