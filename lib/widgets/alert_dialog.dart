import 'package:flutter/material.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
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
          actionsPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          title: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Text(
                title,
                style: const H3TextStyle(),
                textAlign: TextAlign.center,
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
                width: double.infinity,
                text: confirmText,
                textStyle: const H3TextStyle(),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onPress != null) onPress();
                },
                color: confirmTextColor ?? AppColors.textInputBackground,
                backgroundColor: showRedButton
                    ? AppColors.danger
                    : confirmButtonBackgroundColor ?? AppColors.primaryColor),
            showCancelButton
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (onPressCancel != null) onPressCancel();
                      },
                      child: Container(
                        color: AppColors.whiteColor,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20),
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
    String? topText = '예',
    String? bottomText = '아니요',
    Color? topButtonBackgroundColor,
    Color? topTextColor,
    Function? onPressTop,
    void Function()? onPressBottom,
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
            Column(
              children: [
                Ink(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.grayBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    splashColor: AppColors.subTitle,
                    onTap: () {
                      Navigator.of(context).pop();
                      if (onPressTop != null) onPressTop();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width: 18,
                          height: 18,
                          image: Assets.image,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          topText!,
                          style: const H3TextStyle().merge(
                            TextStyle(
                              color: topTextColor ?? AppColors.blackColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Ink(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      if (onPressBottom != null) onPressBottom();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width: 18,
                          height: 18,
                          image: Assets.link,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          bottomText!,
                          style: const H3TextStyle().merge(
                            const TextStyle(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                      ],
                    ),
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
