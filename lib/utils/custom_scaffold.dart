import 'package:flutter/material.dart';

typedef CustomBuilder = Widget Function(
  BuildContext context,
  double x,
  double y,
);

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.body, required this.builder});
  final Widget body;
  final CustomBuilder builder;

  static Widget responsive({required CustomBuilder builder}) {
    return _buildSafeScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return builder(context, constraints.maxWidth, constraints.maxHeight);
      }),
    );
  }

  static Scaffold _buildSafeScaffold({required Widget child}) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: body,
      ),
    );
  }
}
