import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/firebase_options.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/utils/config.dart';
import 'package:moa_app/utils/custom_scaffold.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/utils/themes.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "oldValue": "$previousValue",
  "newValue": "$newValue"
}''');
    }
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   logger.d('Handling a background message: ${message.messageId}');
// }

void main() async {
  usePathUrlStrategy();
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // KaKao login setup
  KakaoSdk.init(
      nativeAppKey: Config().nativeAppKey,
      javaScriptAppKey: Config().javaScriptAppKey);

  runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var token = ref.watch(tokenStateProvider);

    useEffect(() {
      if (!token.isLoading) {
        FlutterNativeSplash.remove();
      }
      return null;
    }, [token.isLoading]);

    if (token.isLoading && !kIsWeb) {
      return const MaterialApp(
        home: Scaffold(body: SizedBox()),
      );
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeMode.light,
        routerConfig: ref.watch(routeProvider),
        // 웹에서 scaffold를 사용할 때 최대 너비를 제한하기 위해 사용
        builder: (context, child) {
          return CustomScaffold.responsive(
            builder: (context, x, y) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: x > Breakpoints.md ? Breakpoints.md : x),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
