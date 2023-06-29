import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/navigations/main_bottom_tab.dart';
import 'package:moa_app/screens/file_sharing/file_sharing.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/folder_detail_view.dart';
import 'package:moa_app/screens/home/hashtag_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/on_boarding/input_name_view.dart';
import 'package:moa_app/screens/on_boarding/notice_view.dart';
import 'package:moa_app/screens/on_boarding/sign_in.dart';
import 'package:moa_app/screens/setting/edit_my_type_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum GoRoutes {
  /// on boarding
  signIn,
  inputName,
  notice,
  home,
  content,
  permission,
  fileSharing,
  userListing,
  folderDetail,
  hashtagDetail,
  setting,
  editMyType
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

CustomTransitionPage buildIosPageTransitions<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
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

List<String> onBoardingScreenList = [
  GoRoutes.signIn.fullPath,
  GoRoutes.inputName.fullPath,
  GoRoutes.notice.fullPath,
];

final routeProvider = Provider((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    // redirect: (context, state) {
    //   var token = ref.read(tokenStateProvider);
    //   if (token.value == null) {
    //     if (state.matchedLocation != GoRoutes.signIn.fullPath) {
    //       return GoRoutes.signIn.fullPath;
    //     }
    //   }
    //   return null;
    // },
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          //  알람 초기화
          /// 알람 권한 요청
          // * 알람기능 추가후 주석 해제
          // if (!kIsWeb && context.mounted) {
          //   FcmService.instance.requestIosFirebaseMessaging();
          //   FcmService.instance.foregroundMessageHandler();
          //   FcmService.instance.foregroundClickHandler(context);
          //   FcmService.instance.setupInteractedMessage(context);
          // }
          return MainBottomTab(child: child);
        },
        routes: [
          GoRoute(
            name: GoRoutes.home.name,
            path: '/',
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const Home(),
            ),
            routes: [
              GoRoute(
                name: GoRoutes.content.name,
                path: '${GoRoutes.content.path}/:id',
                pageBuilder: (context, state) {
                  var contentView = state.extra as ContentView;
                  return buildIosPageTransitions<void>(
                    context: context,
                    state: state,
                    child: ContentView(
                      contentId: contentView.contentId,
                    ),
                  );
                },
              ),
              GoRoute(
                name: GoRoutes.folderDetail.name,
                path: '${GoRoutes.folderDetail.path}/:id',
                pageBuilder: (context, state) {
                  var detailView = state.extra as FolderDetailView;
                  return buildIosPageTransitions<void>(
                    context: context,
                    state: state,
                    child: FolderDetailView(folderName: detailView.folderName),
                  );
                },
              ),
              GoRoute(
                name: GoRoutes.hashtagDetail.name,
                path: '${GoRoutes.hashtagDetail.path}/:id',
                pageBuilder: (context, state) {
                  var detailView = state.extra as HashtagDetailView;
                  return buildIosPageTransitions<void>(
                    context: context,
                    state: state,
                    child: HashtagDetailView(filterName: detailView.filterName),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: GoRoutes.setting.name,
            path: GoRoutes.setting.fullPath,
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const Settine(),
            ),
          ),
          GoRoute(
            name: GoRoutes.fileSharing.name,
            path: GoRoutes.fileSharing.fullPath,
            pageBuilder: (context, state) => buildIosPageTransitions<void>(
              context: context,
              state: state,
              child: const FileSharing(),
            ),
          ),
          GoRoute(
            name: GoRoutes.editMyType.name,
            path: GoRoutes.editMyType.fullPath,
            pageBuilder: (context, state) => buildIosPageTransitions<void>(
              context: context,
              state: state,
              child: const EditMyTypeView(),
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
      GoRoute(
        name: GoRoutes.inputName.name,
        path: GoRoutes.inputName.fullPath,
        builder: (context, state) {
          return const InputNameView();
        },
      ),
      GoRoute(
        name: GoRoutes.notice.name,
        path: GoRoutes.notice.fullPath,
        builder: (context, state) {
          return const NoticeView();
        },
      ),
    ],
  );
});
