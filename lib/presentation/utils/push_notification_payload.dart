import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lazi_chat/domain/model/index.dart';

class PushNotificationPayload {
  NotificationModel? data;
  String? title;
  String? body;

  PushNotificationPayload.fromJson(Map<String, dynamic> json,
      {RemoteNotification? notification}) {
    // final json = jsonDecode(jsonData);
    data = NotificationModel.fromJson(json);
    title = notification?.title;
    body = notification?.body;
  }
}
