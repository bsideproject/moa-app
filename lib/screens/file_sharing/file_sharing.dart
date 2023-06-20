import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/screens/file_sharing/user_listing_screen.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class FileSharing extends HookConsumerWidget {
  const FileSharing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var text = useState('');
    // var files = useState(<SharedMediaFile>[]);

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
          extra: UserListingScreen(
            files: newFiles,
            text: '',
          ),
        );
      }
    }

    void navigateToShareText(BuildContext context, String? value) {
      if (value != null && value.toString().isNotEmpty && context.mounted) {
        text.value = value;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Sharing Files'),
      ),
      body: Column(
        children: [
          Button(
            text: '임시 로그아웃 버튼',
            onPress: () {
              alertDialog.confirm(
                context,
                onPress: () async {
                  await ref.watch(tokenStateProvider.notifier).removeToken();
                  if (context.mounted) {
                    context.go(GoRoutes.signIn.fullPath);
                  }
                },
                showCancelButton: true,
                title: '로그아웃',
                content: '로그아웃 하시겠습니까?',
              );
            },
          ),
          text.value.isEmpty
              ? const Expanded(child: Center(child: Text('File Sharing')))
              : UserListingScreen(text: text.value)
        ],
      ),
    );
  }
}
