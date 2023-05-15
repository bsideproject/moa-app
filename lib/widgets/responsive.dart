import 'package:flutter/material.dart';

const mobileMaxWidth = 850;
const tabletMaxWidth = 1100;

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    this.desktop,
    this.tablet,
    required this.mobile,
  }) : super(key: key);
  final Widget mobile;
  final Widget? desktop;
  final Widget? tablet;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletMaxWidth &&
      MediaQuery.of(context).size.width >= mobileMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (desktop != null && size.width >= tabletMaxWidth) {
      return desktop!;
    }

    if (tablet != null && size.width >= mobileMaxWidth) {
      return tablet!;
    }

    return mobile;
  }
}
