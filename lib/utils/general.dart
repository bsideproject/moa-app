import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/widgets/button.dart';

class General {
  const General._();
  static General instance = const General._();

  void showBottomSheet({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? height,
    bool isCloseButton = false,
    bool isScrollControlled = false,
  }) {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      builder: (context) => Container(
        height: height,
        padding: padding ??
            const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 20,
            ),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: isCloseButton
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  child,
                  Positioned(
                    right: -25,
                    top: -10,
                    child: CircleIconButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blackColor,
                        size: 30,
                      ),
                    ),
                  )
                ],
              )
            : child,
      ),
    );
  }
}
