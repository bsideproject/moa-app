import 'package:flutter/material.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class SettingListTile extends StatelessWidget {
  const SettingListTile({
    super.key,
    required this.title,
    required this.onPressed,
    this.trailing,
  });
  final String title;
  final Function() onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: const H3TextStyle().merge(
          const TextStyle(fontWeight: FontConstants.fontWeightMedium),
        ),
      ),
      trailing: trailing ??
          Transform.rotate(
            angle: 180 * 3.14 / 180,
            child: Image(
              image: Assets.arrowBack,
              width: 20,
              height: 20,
            ),
          ),
      onTap: onPressed,
    );
  }
}
