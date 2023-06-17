import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/screens/home/widgets/collapsible_tab_scroll.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.backgroundColor,
      child: const SafeArea(
        child: Scaffold(body: CollapsibleTabScroll()),
      ),
    );
  }
}
