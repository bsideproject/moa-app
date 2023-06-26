import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class General {
  const General._();
  static General instance = const General._();

  void showBottomSheet(
    BuildContext context,
    Widget child,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
      // isDismissible: false,
      enableDrag: false,
    );
  }
}

class MyBottomSheet extends HookWidget {
  const MyBottomSheet({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: child,
    );
  }
}
