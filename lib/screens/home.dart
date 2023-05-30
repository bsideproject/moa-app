import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/services/fcm_service.dart';
import 'package:moa_app/utils/logger.dart';
import 'package:moa_app/utils/router_config.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleForegroundMessage() async {
      await FcmService.instance.foregroundMessageHandler();
      if (context.mounted) {
        await FcmService.instance.foregroundClickHandler(context);
      }
    }

    void handleBackgroundMessage(RemoteMessage message) {
      logger.d('message = ${message.notification?.title}');
      if (message.notification?.title != null) {
        context.go(GoRoutes.editProfile.fullPath);
      }
    }

    Future<void> setupInteractedMessage() async {
      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        handleBackgroundMessage(initialMessage);
      }

      // Also handle any interaction when the app is in the background via a
      // Stream listener
      FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
    }

    useEffect(() {
      // * 알람 권한 요청 (위치 이동 될 수 있음)
      FcmService.instance.requestIosFirebaseMessaging();
      handleForegroundMessage();
      setupInteractedMessage();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Column(
        children: [
          Flexible(
            flex: 1,
            child: Center(
              child: Text('Home'),
            ),
          ),
        ],
      ),
    );
  }
}
