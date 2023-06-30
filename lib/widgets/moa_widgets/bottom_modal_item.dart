import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class BottomModalItem extends HookWidget {
  const BottomModalItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final AssetImage icon;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onTap: onPressed,
          minLeadingWidth: 0,
          leading: SizedBox(
            height: double.infinity,
            child: Image(
              width: 16,
              height: 16,
              image: icon,
            ),
          ),
          title: Text(
            title,
            style: const H3TextStyle().merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
