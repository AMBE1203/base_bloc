import 'dart:convert';

import 'package:lazi_chat/core/utils/index.dart';

class NotificationModel {
  int? notificationId;
  String? contentVn;
  String? contentKr;
  String? titleVn;
  String? titleKr;

  NotificationModel({
    this.notificationId,
    this.contentVn,
    this.contentKr,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId']?.toString().toIntValue() ?? -1;
    contentVn = json['contentVn'];
    contentKr = json['contentKr'];
    titleKr = json['titleKr'];
    titleVn = json['titleVn'];
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'contentVn': contentVn,
      'contentKr': contentKr,
      'titleKr': titleKr,
      'titleVn': titleVn,
    };
  }

  String toJsonString() {
    final json = toJson();
    return jsonEncode(json);
  }
}
