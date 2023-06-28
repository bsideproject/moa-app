import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';

class General {
  const General._();
  static General instance = const General._();

  void showBottomSheet({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double height = 300,
    // bottomSheet 내부에서 상태를 관리하면 false로 설정
    bool isContainer = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => isContainer
          ? Container(
              height: height,
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: child,
            )
          : child,
      // isDismissible: false,
      enableDrag: false,
    );
  }
}
