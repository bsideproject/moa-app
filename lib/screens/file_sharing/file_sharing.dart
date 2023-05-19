import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/screens/file_sharing/user_listing_screen.dart';
import 'package:moa_app/utils/router_config.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class FileSharing extends HookWidget {
  const FileSharing({super.key});

  @override
  Widget build(BuildContext context) {
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
      if (value != null && value.toString().isNotEmpty) {
        context.push(
          '${GoRoutes.fileSharing.fullPath}/$value',
          extra: UserListingScreen(
            files: const [],
            text: value,
          ),
        );
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
      listenShareMediaFiles(context);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Sharing Files'),
      ),
      body: const Center(child: Text('File Sharing')),
    );
  }
}
