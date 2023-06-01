import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lunar_calendar/domain/model/index.dart';
import 'package:lunar_calendar/presentation/base/index.dart';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;

import 'package:rxdart/rxdart.dart';
import 'push_notification_payload.dart';

abstract class NotificationEvent extends BaseEvent {}

// user tap into notification banner
class NotificationTapEvent extends NotificationEvent {
  NotificationModel notification;

  NotificationTapEvent({required this.notification});
}

// notification comes
class DidReceiveNotificationEvent extends NotificationEvent {
  bool appInBackground;

  DidReceiveNotificationEvent({this.appInBackground = false});
}

class PushNotificationHandler {
  static PushNotificationHandler shared = PushNotificationHandler._();

  // tracking user tapped int notification event
  final PublishSubject<NotificationEvent> _notificationEventManager =
      PublishSubject<NotificationEvent>(sync: true);

  Stream<NotificationEvent> get notificationEventStream =>
      _notificationEventManager.stream.asBroadcastStream();

  // NotificationTapEvent? _initialEvent;

  PushNotificationHandler._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupPushNotification() async {
    // iOS request firebase message request permission
    await FirebaseMessaging.instance.requestPermission();

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // force-ground notification comes
    FirebaseMessaging.onMessage.listen((event) {
      Logger().d(
          'FirebaseMessaging listen ${event.data} ${event.notification?.toString()}');
      _notificationEventManager
          .add(DidReceiveNotificationEvent(appInBackground: false));
      if (Platform.isAndroid) {
        _showLocalNotification(PushNotificationPayload.fromJson(
          event.data,
          notification: event.notification,
        ));
      }
    });

    // app in background, tapped remote notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Logger().d('FirebaseMessaging onMessageOpenedApp background');
      _notificationTappedHandler(NotificationResponse(
          payload: PushNotificationPayload.fromJson(
            event.data,
            notification: event.notification,
          ).data?.toJsonString(),
          notificationResponseType:
              NotificationResponseType.selectedNotification));
    });
    // background notification comes
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> getNotifyToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token ?? 'undefine';
  }

  Future<NotificationTapEvent?> getInitialEvent() async {
    // check app open from remote notification
    NotificationTapEvent? event = await _checkAppOnPenFromRemoteNotification();

    //Android only: check if app open from local-notification
    if (event == null && Platform.isAndroid) {
      event = await _checkAppOpenFromLocalNotification();
    }
    return event;
  }

  Future<void> clear() async {
    // remove init event
    await getInitialEvent();
    await FirebaseMessaging.instance.deleteToken();
  }

  /* In Android when application in background or killed, incoming notification will be shown by system
    * but when application in fore-ground, the application have to show the banner by using local notification
    * In iOS: all incoming notification will be shown by system
    */
  Future<void> _showLocalNotification(PushNotificationPayload data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('id', 'channel',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    // only for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _notificationTappedHandler);

    await _flutterLocalNotificationsPlugin.show(
        1, data.title, data.body, platformChannelSpecifics,
        payload: data.data?.toJsonString());
  }

  Future<NotificationTapEvent?> _checkAppOpenFromLocalNotification() async {
    //Android only: check if app open from local-notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    final jsonString =
        notificationAppLaunchDetails?.notificationResponse?.payload ?? '';
    final json = jsonString.isNotEmpty ? jsonDecode(jsonString) : {};

    return (json is Map<String, dynamic> && json.isNotEmpty)
        ? NotificationTapEvent(notification: NotificationModel.fromJson(json))
        : null;
  }

  Future<NotificationTapEvent?> _checkAppOnPenFromRemoteNotification() async {
    // Check if app open from push - notification
    final noti = await FirebaseMessaging.instance.getInitialMessage();
    if (noti != null) {
      // open from push notification
      NotificationModel? data = PushNotificationPayload.fromJson(
        noti.data,
        notification: noti.notification,
      ).data;
      return (data != null) ? NotificationTapEvent(notification: data) : null;
    }
    return null;
  }

  /*
   * Call when notification come  
   */
  Future _notificationTappedHandler(NotificationResponse? detail) async {
    if (detail?.payload?.isNotEmpty ?? false) {
      final json = jsonDecode(detail!.payload!);
      final notification = NotificationModel.fromJson(json);
      _notificationEventManager.add(NotificationTapEvent(
        notification: notification,
      ));
    }
  }

// firebase messaging android
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
}

// must be outside of class
//a top-level named handler which background/terminated messages will
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final port = IsolateNameServer.lookupPortByName(backgroundMessageIsolateName);
  port?.send(message.data);
}

final ReceivePort backgroundMessagePort = ReceivePort();
const String backgroundMessageIsolateName = 'fcm_background_msg_isolate';

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {}

void backgroundMessagePortHandler(message) {
  PushNotificationHandler.shared._notificationEventManager
      .add(DidReceiveNotificationEvent(
    appInBackground: true,
  ));
  // Here I can access and update my top-level variables.
}
