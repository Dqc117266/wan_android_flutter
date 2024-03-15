
import 'package:wan_android_flutter/core/model/front_articles_model.dart';

class FrontTopArtclesModel {
  List<Datas>? data;
  int? errorCode;
  String? errorMsg;

  FrontTopArtclesModel({this.data, this.errorCode, this.errorMsg});

  FrontTopArtclesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Datas>[];
      json['data'].forEach((v) {
        data!.add(new Datas.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}
