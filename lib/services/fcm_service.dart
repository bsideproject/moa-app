import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:moa_app/utils/config.dart';
import 'package:moa_app/utils/tools.dart';

class FcmService {
  FcmService._();
  static FcmService instance = FcmService._();

  String? token;

  Future<void> requestIosFirebaseMessaging() async {
    var messaging = FirebaseMessaging.instance;

    var settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      try {
        await messaging.subscribeToTopic('all');

        token = kIsWeb
            ? await messaging.getToken(
                vapidKey: Config().webFcmKey,
              )
            : await messaging.getToken();

        if (token != null) {
          // todo 알람토큰 저장
          // await NotificationRepository.instance.addToken(token: token!);
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }

  Future<void> foregroundMessageHandler() async {
    var channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((message) {
      logger.d('Got a message whilst in the foreground!');
      logger.d('Message data: ${message.data}');

      if (message.notification != null) {
        logger.d(
            'Message also contained a notification: ${message.notification}');
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(
              badgeNumber: 1,
              subtitle: 'the subtitle',
              sound: 'slow_spring_board.aiff',
            ),
          ),
        );
      }
    });
  }

  Future<void> backgroundClickHandler() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
    if (initialMessage != null) _handleMessage(initialMessage);

    // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    logger.d('message = ${message.notification!.title}');
    if (message.data['type'] == 'chat') {
      // todo 해당화면으로 이동
      // Get.toNamed('/chat', arguments: message.data);
    }
  }

  Future<void> foregroundClickHandler() async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      // todo 해당화면으로 이동
      // Get.to(const NextPage(), arguments: payload);
    });
  }

  Future<void> getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }
}
