import 'package:flutter/material.dart';

class _BottomSheet {
  factory _BottomSheet() {
    return _singleton;
  }

  _BottomSheet._internal();
  static final _BottomSheet _singleton = _BottomSheet._internal();

  void confirm(
    BuildContext context, {
    double? height,
    required Widget child,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Container(
          padding: padding ?? const EdgeInsets.all(20),
          height: height,
          child: child,
        );
      },
    );
  }
}

var bottomSheet = _BottomSheet();
