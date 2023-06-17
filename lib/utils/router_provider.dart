import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/models/item_model.dart';
import 'package:moa_app/navigations/main_bottom_tab.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/screens/file_sharing/file_sharing.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/item_detail.dart';
import 'package:moa_app/screens/sign_in.dart';
import 'package:moa_app/services/fcm_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum GoRoutes {
  authSwitch,
  signIn,
  home,
  permission,
  fileSharing,
  userListing,
  itemDetail,
  editProfile,
  sample,
  result
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 120),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

extension GoRoutesName on GoRoutes {
  String get name => describeEnum(this);

  /// Convert to `lower-snake-case` format.
  String get path {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result =
        name.replaceAllMapped(exp, (m) => '-${m.group(0)}').toLowerCase();
    return result;
  }

  /// Convert to `lower-snake-case` format with `/`.
  String get fullPath {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result =
        name.replaceAllMapped(exp, (m) => '-${m.group(0)}').toLowerCase();
    return '/$result';
  }
}

final routeProvider = Provider((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: GoRoutes.home.fullPath,
    redirect: (context, state) {
      var token = ref.read(tokenStateProvider);
      if (token.value == null) {
        if (state.matchedLocation != GoRoutes.signIn.fullPath) {
          return GoRoutes.signIn.fullPath;
        }
      }
      return null;
    },
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          //  알람 초기화
          /// 알람 권한 요청
          if (!kIsWeb && context.mounted) {
            FcmService.instance.requestIosFirebaseMessaging();

            FcmService.instance.foregroundMessageHandler();
            FcmService.instance.foregroundClickHandler(context);
            FcmService.instance.setupInteractedMessage(context);
          }

          return MainBottomTab(child: child);
        },
        routes: [
          GoRoute(
            name: GoRoutes.home.name,
            path: GoRoutes.home.fullPath,
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const Home(),
            ),
            routes: [
              GoRoute(
                name: GoRoutes.itemDetail.name,
                path: ':id',
                builder: (context, state) {
                  var item = state.extra as ItemModel;
                  return ItemDetail(item: item);
                },
              ),
            ],
          ),
          GoRoute(
            name: GoRoutes.fileSharing.name,
            path: GoRoutes.fileSharing.fullPath,
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const FileSharing(),
            ),
          ),
        ],
      ),
      GoRoute(
        name: GoRoutes.signIn.name,
        path: GoRoutes.signIn.fullPath,
        builder: (context, state) {
          return const SignIn();
        },
      ),
    ],
  );
});
