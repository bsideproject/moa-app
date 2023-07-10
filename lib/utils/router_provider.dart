import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/navigations/main_bottom_tab.dart';
import 'package:moa_app/screens/add_content/add_image_content.dart';
import 'package:moa_app/screens/add_content/add_link_content.dart';
import 'package:moa_app/screens/add_content/folder_select.dart';
import 'package:moa_app/screens/file_sharing/file_sharing.dart';
import 'package:moa_app/screens/home/content_view.dart';
import 'package:moa_app/screens/home/folder_detail_view.dart';
import 'package:moa_app/screens/home/hashtag_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/on_boarding/greeting_view.dart';
import 'package:moa_app/screens/on_boarding/input_name_view.dart';
import 'package:moa_app/screens/on_boarding/notice_view.dart';
import 'package:moa_app/screens/on_boarding/sign_in.dart';
import 'package:moa_app/screens/setting/edit_my_type_view.dart';
import 'package:moa_app/screens/setting/setting.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum GoRoutes {
  /// on boarding
  greeting,
  signIn,
  inputName,
  notice,

  /// main
  home,
  content,
  permission,
  fileSharing,
  userListing,
  folder,
  hashtag,
  setting,
  editContent,

  /// add folder
  folderSelect,
  addImageContent,
  addLinkContent
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

Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();

final routeProvider = Provider(
  (ref) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) async {
        SharedPreferences prefs = await prefs0;
        var isInitRunApp = prefs.getBool('isInitRunApp');
        if (isInitRunApp ?? true) {
          // 앱 최초 실행시 인사말 페이지로 이동
          return GoRoutes.greeting.fullPath;
        }
        return null;
        // todo 토큰있으면 signin 페이지로 이동 못하게 해야됨
        // var token = ref.read(tokenStateProvider);
        // if (token.value == null) {
        //   if (state.matchedLocation != GoRoutes.signIn.fullPath) {
        //     return GoRoutes.signIn.fullPath;
        //   }
        // }
        // return null;
      },
      routes: <RouteBase>[
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
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
                  parentNavigatorKey: _rootNavigatorKey,
                  name: GoRoutes.folder.name,
                  path: '${GoRoutes.folder.path}/:id',
                  pageBuilder: (context, state) {
                    return buildIosPageTransitions<void>(
                      context: context,
                      state: state,
                      child: FolderDetailView(
                        folderId: state.pathParameters['id']!,
                      ),
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  name: GoRoutes.hashtag.name,
                  path: '${GoRoutes.hashtag.path}/:hashtag',
                  pageBuilder: (context, state) {
                    return buildIosPageTransitions<void>(
                      context: context,
                      state: state,
                      child: HashtagDetailView(
                          filterName: state.pathParameters['hashtag']!),
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  name: GoRoutes.content.name,
                  path: '${GoRoutes.content.path}/:id',
                  pageBuilder: (context, state) {
                    return buildIosPageTransitions<void>(
                      context: context,
                      state: state,
                      child: ContentView(
                        id: state.pathParameters['id']!,
                      ),
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
                child: const Setting(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  name: GoRoutes.editContent.name,
                  path: GoRoutes.editContent.path,
                  pageBuilder: (context, state) =>
                      buildIosPageTransitions<void>(
                    context: context,
                    state: state,
                    child: const EditMyTypeView(),
                  ),
                ),
              ],
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
          ],
        ),
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            name: GoRoutes.folderSelect.name,
            path: GoRoutes.folderSelect.fullPath,
            pageBuilder: (context, state) => buildIosPageTransitions<void>(
                  context: context,
                  state: state,
                  child: const FolderSelect(),
                ),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                name: GoRoutes.addImageContent.name,
                path: GoRoutes.addImageContent.path,
                pageBuilder: (context, state) => buildIosPageTransitions<void>(
                  context: context,
                  state: state,
                  child: const AddImageContent(),
                ),
              ),
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                name: GoRoutes.addLinkContent.name,
                path: GoRoutes.addLinkContent.path,
                pageBuilder: (context, state) => buildIosPageTransitions<void>(
                  context: context,
                  state: state,
                  child: const AddLinkContent(),
                ),
              ),
            ]),
        GoRoute(
          name: GoRoutes.greeting.name,
          path: GoRoutes.greeting.fullPath,
          builder: (context, state) {
            return const GreetingView();
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
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
            var inputName = state.extra as InputNameView;
            return InputNameView(isMember: inputName.isMember);
          },
        ),
        GoRoute(
          name: GoRoutes.notice.name,
          path: GoRoutes.notice.fullPath,
          builder: (context, state) {
            var notice = state.extra as NoticeView;
            return NoticeView(
              nickname: notice.nickname,
            );
          },
        ),
      ],
    );
  },
);
