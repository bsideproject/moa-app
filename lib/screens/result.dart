import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/utils/localization.dart' show localization;
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/responsive.dart';

class Result extends HookWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    const count = '0';
    var t = localization(context);

    List<Widget> buildCountNumWidgets() {
      return [
        Text(
          t.count,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ];
    }

    return Scaffold(
      appBar: AppBarBack(
        title: Text(t.result),
      ),
      body: Center(
        child: Responsive(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildCountNumWidgets(),
          ),
          desktop: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildCountNumWidgets(),
          ),
        ),
      ),
    );
  }
}
