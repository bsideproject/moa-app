import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';

class _AlertDialog {
  factory _AlertDialog() {
    return _singleton;
  }

  _AlertDialog._internal();
  static final _AlertDialog _singleton = _AlertDialog._internal();

  void confirm(
    BuildContext context, {
    bool barrierDismissible = true,
    required String title,
    required String content,
    String? confirmText = '예',
    String? cancelText = '아니요',
    Color? confirmButtonBackgroundColor,
    Color? confirmTextColor,
    Function? onPress,
    void Function()? onPressCancel,
    bool showCancelButton = false,
    bool showRedButton = false,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(24),
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          actionsPadding: const EdgeInsets.all(24),
          title: Text(title, style: const H1TextStyle()),
          content: Text(content, style: const H2TextStyle()),
          actions: <Widget>[
            Button(
                width: MediaQuery.of(context).size.width,
                text: confirmText,
                onPress: () {
                  Navigator.of(context).pop();
                  if (onPress != null) onPress();
                },
                color: confirmTextColor ?? AppColors.textInputBackground,
                backgroundColor: showRedButton
                    ? AppColors.danger
                    : confirmButtonBackgroundColor ?? AppColors.primaryColor),
            showCancelButton
                ? Button(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    text: cancelText,
                    onPress: onPressCancel ?? () => Navigator.of(context).pop(),
                    backgroundColor: AppColors.blackColor,
                    color: AppColors.whiteColor,
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }
}

var alertDialog = _AlertDialog();
