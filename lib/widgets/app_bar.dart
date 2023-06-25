import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/widgets/button.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.isBottomBorderDisplayed = true,
    this.bottomBorderStyle = const BottomBorderStyle(),
  }) : super(key: key);
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isBottomBorderDisplayed;
  final BottomBorderStyle bottomBorderStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: CircleIconButton(
        backgroundColor: AppColors.whiteColor,
        icon: Image(
          width: 24,
          height: 24,
          image: Assets.arrowBack,
        ),
        onPressed: () {
          context.pop();
        },
      ),
      elevation: 0,
      titleSpacing: 0.0,
      centerTitle: true,
      bottom: isBottomBorderDisplayed
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomBorderStyle.height),
              child: Container(
                color: bottomBorderStyle.color,
                height: bottomBorderStyle.height,
              ),
            )
          : null,
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
