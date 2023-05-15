import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  final List? actions;
  final bool isBottomBorderDisplayed;
  final BottomBorderStyle bottomBorderStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_outlined,
        ),
        onPressed: () => context.pop(),
      ),
      bottom: isBottomBorderDisplayed
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomBorderStyle.height),
              child: Container(
                color: bottomBorderStyle.color,
                height: bottomBorderStyle.height,
              ),
            )
          : null,
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
