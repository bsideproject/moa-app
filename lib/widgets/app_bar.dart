import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack({
    Key? key,
    this.title,
    this.text,
    this.leading,
    this.actions,
    this.isBottomBorderDisplayed = false,
    this.bottomBorderStyle = const BottomBorderStyle(),
    this.onPressedBack,
    this.isBackButton = true,
  }) : super(key: key);
  final String? title;
  final Widget? text;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isBottomBorderDisplayed;
  final BottomBorderStyle bottomBorderStyle;
  final VoidCallback? onPressedBack;
  final bool isBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      title: text ??
          Text(
            title ?? '',
            style: const H2TextStyle(),
          ),
      leading: !isBackButton
          ? const SizedBox()
          : CircleIconButton(
              backgroundColor: AppColors.whiteColor,
              icon: Image(
                width: 24,
                height: 24,
                image: Assets.arrowBack,
              ),
              onPressed: () {
                if (onPressedBack != null) {
                  onPressedBack!();
                  return;
                }
                context.pop();
              },
            ),
      elevation: 0,
      titleSpacing: 0.0,
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(bottomBorderStyle.height),
        child: Container(
          color: isBottomBorderDisplayed
              ? bottomBorderStyle.color
              : AppColors.whiteColor,
          height: bottomBorderStyle.height,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BottomBorderStyle {
  const BottomBorderStyle({
    this.color = Colors.grey,
    this.height = 1,
  });
  final Color color;
  final double height;
}
