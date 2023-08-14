import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/widgets/app_bar.dart';

class Contact extends HookWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarBack(
        title: '문의하기',
      ),
    );
  }
}
