import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class _Snackbar {
  factory _Snackbar() {
    return _singleton;
  }

  _Snackbar._internal();
  static final _Snackbar _singleton = _Snackbar._internal();

  void alert(
    BuildContext context,
    String message, {
    TextStyle? textStyle,
    Color? backgroundColor = AppColors.primaryColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    var snackBar = SnackBar(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
      dismissDirection: DismissDirection.down,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: message.contains('#')
                ? RichText(
                    text: TextSpan(
                        style: const H3TextStyle()
                            .merge(
                              const TextStyle(
                                color: AppColors.whiteColor,
                              ),
                            )
                            .merge(textStyle),
                        children: [
                        TextSpan(
                          style: const TextStyle(
                            fontWeight: FontConstants.fontWeightBold,
                          ),
                          text: message.substring(
                            0,
                            message.indexOf('로'),
                          ),
                        ),
                        TextSpan(
                          style: const TextStyle(
                            fontWeight: FontConstants.fontWeightNormal,
                          ),
                          text: message.substring(message.indexOf('로')),
                        ),
                      ]))
                : Text(
                    message,
                    style: const H3TextStyle()
                        .merge(
                          const TextStyle(
                            fontWeight: FontConstants.fontWeightNormal,
                            color: AppColors.whiteColor,
                          ),
                        )
                        .merge(textStyle),
                  ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

var snackbar = _Snackbar();
