import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/firebase_options.dart';
import 'package:moa_app/generated/l10n.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/utils/config.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/utils/themes.dart';
import 'package:moa_app/utils/tools.dart';
import 'package:moa_app/widgets/snackbar.dart';

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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.d('Handling a background message: ${message.messageId}');
}

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // KaKao login setup
  KakaoSdk.init(
      nativeAppKey: Config().nativeAppKey,
      javaScriptAppKey: Config().javaScriptAppKey);
  runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  static const platform = MethodChannel('com.beside.moa/share');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var token = ref.watch(tokenStateProvider);
    var isShareScreen = useState(false);

    Future<void> sendShareSheetToken() async {
      try {
        var res = await platform.invokeMethod(
          'shareSheet',
          <String, dynamic>{
            'token': token.value,
          },
        );
        if (res == 'shareSheet') {
          isShareScreen.value = true;
        }
      } on PlatformException catch (e) {
        logger.d('e.message:${e.message}');
        snackbar.alert(context, kDebugMode ? e.toString() : 'error');
      }
    }

    useEffect(() {
      sendShareSheetToken();
      return null;
    }, [isShareScreen.value]);

    useEffect(() {
      if (!token.isLoading) {
        FlutterNativeSplash.remove();
      }
      return null;
    }, [token.isLoading]);

    if (isShareScreen.value) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0),
          bottomSheet: Center(
            child: Container(
              color: Colors.green,
              child: const Text('Share Screen'),
            ),
          ),
        ),
      );
    }

    if (token.isLoading) {
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
        // themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
        // themeMode: ThemeMode.system,
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        routerConfig: ref.watch(routeProvider),
      ),
    );
  }
}
