import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class ErrorText extends HookWidget {
  const ErrorText({
    super.key,
    required this.errorText,
    required this.errorValidate,
    this.padding,
  });
  final String errorText;
  final bool errorValidate;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      duration: const Duration(milliseconds: 100),
      child: errorValidate
          ? Padding(
              padding: padding ?? const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Image(
                    image: Assets.alert,
                    width: 13,
                    height: 13,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    errorText,
                    style: const Body1TextStyle().merge(
                      const TextStyle(color: AppColors.primaryColor),
                    ),
                  )
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
