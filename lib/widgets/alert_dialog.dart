import 'package:flutter/material.dart';
import 'package:moa_app/constants/app_constants.dart';
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
    var width = MediaQuery.of(context).size.width;

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: width > Breakpoints.md ? 200 : 40,
          ),
          actionsPadding: const EdgeInsets.all(20),
          title: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      title,
                      style: const H3TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -25,
                top: -15,
                child: CircleIconButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackColor,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          content: Text(
            content,
            style: const H5TextStyle().merge(
              const TextStyle(
                color: Color(0xFF818181),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Button(
                width: MediaQuery.of(context).size.width,
                text: confirmText,
                textStyle: const H3TextStyle(),
                onPress: () {
                  Navigator.of(context).pop();
                  if (onPress != null) onPress();
                },
                color: confirmTextColor ?? AppColors.textInputBackground,
                backgroundColor: showRedButton
                    ? AppColors.danger
                    : confirmButtonBackgroundColor ?? AppColors.primaryColor),
            showCancelButton
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (onPressCancel != null) onPressCancel();
                        },
                        child: Text(
                          cancelText ?? '',
                          style: const InputLabelTextStyle().merge(
                            TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor.withOpacity(0.4),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }

  void select(
    BuildContext context, {
    bool barrierDismissible = true,
    required String title,
    required String content,
    String? leftText = '예',
    String? rightText = '아니요',
    Color? leftButtonBackgroundColor,
    Color? leftTextColor,
    Function? onPressLeft,
    void Function()? onPressRight,
  }) {
    var width = MediaQuery.of(context).size.width;

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: width > Breakpoints.md ? 200 : 40,
          ),
          actionsPadding: const EdgeInsets.all(20),
          title: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      title,
                      style: const H3TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -25,
                top: -15,
                child: CircleIconButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackColor,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          content: Text(
            content,
            style: const H5TextStyle().merge(
              const TextStyle(
                color: Color(0xFF818181),
              ),
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Button(
                    width: MediaQuery.of(context).size.width,
                    text: leftText,
                    textStyle: const H3TextStyle(),
                    onPress: () {
                      Navigator.of(context).pop();
                      if (onPressLeft != null) onPressLeft();
                    },
                    color: leftTextColor ?? AppColors.textInputBackground,
                    backgroundColor: AppColors.blackColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    width: MediaQuery.of(context).size.width,
                    text: rightText,
                    textStyle: const H3TextStyle(),
                    onPress: () {
                      Navigator.of(context).pop();
                      if (onPressRight != null) onPressRight();
                    },
                    color: leftTextColor ?? AppColors.textInputBackground,
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

var alertDialog = _AlertDialog();
