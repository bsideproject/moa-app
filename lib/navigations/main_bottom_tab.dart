import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/utils/my_platform.dart';
import 'package:moa_app/utils/router_provider.dart';

class MainBottomTab extends HookWidget {
  const MainBottomTab({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var currentIndex = useState(0);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom == 0;

    void tap(BuildContext context, int index) {
      if (index == currentIndex.value) {
        // If the tab hasn't changed, do nothing
        return;
      }
      currentIndex.value = index;
      if (index == 0) {
        // Note: this won't remember the previous state of the route
        // More info here:
        // https://github.com/flutter/flutter/issues/99124
        context.goNamed(GoRoutes.home.name);
      } else if (index == 1) {
        context.goNamed(GoRoutes.setting.name);
      }
    }

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: Visibility(
          maintainAnimation: true,
          maintainState: true,
          visible: keyboardIsOpen,
          child: AnimatedOpacity(
            opacity: keyboardIsOpen ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              //Floating action button on Scaffold
              onPressed: () {
                //code to execute on button press
              },
              child: const Icon(
                size: 40,
                Icons.add,
              ), //icon inside button
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -4),
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            padding: EdgeInsets.only(
              top: 10,
              bottom: MyPlatform().isAndroid ? 10 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Bottom of the screen
                Expanded(
                  child: IconButton(
                    iconSize: 28,
                    onPressed: () => tap(context, 0),
                    icon: Image(
                      color: currentIndex.value == 0
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      image: Assets.home,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 28,
                    onPressed: () => tap(context, 1),
                    icon: Image(
                      color: currentIndex.value == 1
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      image: Assets.setting,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
