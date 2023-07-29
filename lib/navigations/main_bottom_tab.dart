import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/screens/add_content/folder_select.dart';
import 'package:moa_app/utils/my_platform.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class MainBottomTab extends HookConsumerWidget {
  const MainBottomTab({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = useState(0);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom == 0;
    var lifeCycle = useAppLifecycleState();

    void navigateToShareMedia(
        BuildContext context, List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        var newFiles = <File>[];
        for (var element in value) {
          newFiles.add(File(
            Platform.isIOS
                ? element.type == SharedMediaType.FILE
                    ? element.path
                        .toString()
                        .replaceAll(AppConstants.replaceableText, '')
                    : element.path
                : element.path,
          ));
        }

        context.push(
          '${GoRoutes.fileSharing.fullPath}/$newFiles',
        );
      }
    }

    var receiveUrl = useState('');

    void navigateToShareText(BuildContext context, String? value) {
      if (value != null && value.toString().isNotEmpty && context.mounted) {
        receiveUrl.value = value;
      }
    }

    //All listeners to listen Sharing media files & text
    void listenShareMediaFiles(BuildContext context) {
      // For sharing images coming from outside the app
      // while the app is in the memory
      ReceiveSharingIntent.getMediaStream().listen((value) {
        navigateToShareMedia(context, value);
      }, onError: (err) {
        debugPrint('$err');
      });

      // For sharing images coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialMedia().then((value) {
        navigateToShareMedia(context, value);
      });

      // For sharing or opening urls/text coming from outside the app while the app is in the memory
      ReceiveSharingIntent.getTextStream().listen((value) {
        navigateToShareText(context, value);
      }, onError: (err) {
        debugPrint('$err');
      });

      // For sharing or opening urls/text coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialText().then((value) {
        navigateToShareText(context, value);
      });
    }

    useEffect(() {
      if (!kIsWeb) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          listenShareMediaFiles(context);
        });
      }
      return null;
    }, []);

    useEffect(() {
      /// 외부에서 url 공유로 들어왔을경우 폴더선택화면으로 이동
      if (receiveUrl.value.isNotEmpty &&
          lifeCycle == AppLifecycleState.resumed) {
        context.push(
          GoRoutes.folderSelect.fullPath,
          extra: FolderSelect(receiveUrl: receiveUrl.value),
        );
        receiveUrl.value = '';
        return;
      }
      return null;
    }, [lifeCycle]);

    void tap(BuildContext context, int index) {
      if (index == currentIndex.value) {
        // If the tab hasn't changed, do nothing
        return;
      }
      currentIndex.value = index;
      if (index == 0) {
        // Note: this won't remember the previous state of the route
        // More info here:
        // https://github.com/flutter/flutter/issues/99124
        context.goNamed(GoRoutes.home.name);
      } else if (index == 1) {
        context.goNamed(GoRoutes.setting.name);
      }
    }

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: Visibility(
          maintainAnimation: true,
          maintainState: true,
          visible: keyboardIsOpen,
          child: AnimatedOpacity(
            opacity: keyboardIsOpen ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              onPressed: () {
                context.push(GoRoutes.folderSelect.fullPath);
              },
              child: const Icon(
                size: 40,
                Icons.add,
              ), //icon inside button
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -4),
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            padding: EdgeInsets.only(
              top: 10,
              bottom: MyPlatform().isAndroid ? 10 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Bottom of the screen
                Expanded(
                  child: IconButton(
                    iconSize: 28,
                    onPressed: () => tap(context, 0),
                    icon: Image(
                      color: currentIndex.value == 0
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      image: Assets.home,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 28,
                    onPressed: () => tap(context, 1),
                    icon: Image(
                      color: currentIndex.value == 1
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      image: Assets.setting,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
