import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/generated/l10n.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/utils/config.dart';
import 'package:moa_app/utils/router_config.dart';
import 'package:moa_app/utils/themes.dart';
import 'package:moa_app/widgets/model_theme.dart';

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

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: '.env');

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
    var themeNotifier = ref.watch(modelProvider);
    var token = ref.watch(tokenStateProvider);

    useEffect(() {
      if (!token.isLoading) {
        FlutterNativeSplash.remove();
      }
      return null;
    }, [token.isLoading]);

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
        themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
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
        routerConfig: routerConfig(
          (token.value != null)
              ? GoRoutes.home.fullPath
              : GoRoutes.signIn.fullPath,
        ),
      ),
    );
  }
}
