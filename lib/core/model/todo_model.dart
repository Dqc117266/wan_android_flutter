import 'package:wan_android_flutter/core/model/todolist_model.dart';

class TodoModel {
  Datas? data;
  int? errorCode;
  String? errorMsg;

  TodoModel({this.data, this.errorCode, this.errorMsg});

  TodoModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Datas.fromJson(json['data']) : null;
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
