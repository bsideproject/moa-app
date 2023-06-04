import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/utils/router_provider.dart';

enum ScreenType { social, generalMeetings }

class MainBottomTab extends HookWidget {
  const MainBottomTab({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var currentIndex = useState(0);

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
        context.goNamed(GoRoutes.fileSharing.name);
      } else if (index == 2) {
        context.goNamed(GoRoutes.permission.name);
      } else if (index == 3) {
        context.goNamed(GoRoutes.editProfile.name);
      }
    }

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          //Floating action button on Scaffold
          onPressed: () {
            //code to execute on button press
          },
          child: const Icon(
            size: 30,
            Icons.add,
          ), //icon inside button
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 25),
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 40,
            ),
          ],
        ),
        child: BottomAppBar(
          // color: Colors.green,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Bottom of the screen
                IconButton(
                  iconSize: 28,
                  onPressed: () => tap(context, 0),
                  icon: const Icon(Icons.home),
                  color: currentIndex.value == 0
                      ? AppColors.primaryColor
                      : AppColors.placeholder,
                ),
                IconButton(
                  iconSize: 28,
                  onPressed: () => tap(context, 1),
                  icon: const Icon(Icons.share),
                  color: currentIndex.value == 1
                      ? AppColors.primaryColor
                      : AppColors.placeholder,
                ),
                IconButton(
                  iconSize: 28,
                  onPressed: () => tap(context, 2),
                  icon: const Icon(Icons.lock),
                  color: currentIndex.value == 2
                      ? AppColors.primaryColor
                      : AppColors.placeholder,
                ),
                IconButton(
                  iconSize: 28,
                  onPressed: () => tap(context, 3),
                  icon: const Icon(Icons.person),
                  color: currentIndex.value == 3
                      ? AppColors.primaryColor
                      : AppColors.placeholder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
