import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';

class EmptyContent extends HookWidget {
  const EmptyContent({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const H2TextStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Image(
            image: Assets.moaWalking,
            width: 200,
            height: 180,
          )
        ],
      ),
    );
  }
}
