import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/providers/hashtag_provider.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/screens/setting/widgets/edit_folder.dart';
import 'package:moa_app/screens/setting/widgets/edit_hashtag.dart';
import 'package:moa_app/widgets/app_bar.dart';

class EditMyTypeView extends HookConsumerWidget {
  const EditMyTypeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var folderAsync = ref.watch(folderViewProvider);
    var hashtagAsync = ref.watch(hashtagProvider);
    TabController tabController = useTabController(initialLength: 2);
    var tabIdx = useState(0);

    useEffect(() {
      /// SliverPersistentHeader의 tab icon 색깔 리렌더를 위해서 addListener 사용
      tabController.addListener(() {
        if (tabController.index == 0) {
          tabIdx.value = 0;
        } else {
          tabIdx.value = 1;
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarBack(
        title: '내 취향 관리',
        isBottomBorderDisplayed: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: ExtendedNestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          onlyOneScrollInBody: true,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                delegate: PersistentTabBar(
                  backgroundColor: AppColors.whiteColor,
                  tabController: tabController,
                  folderCount: folderAsync.value?.length ?? 0,
                  contentCount: hashtagAsync.value?.$1.length ?? 0,
                  isClick: true,
                  isEditScreen: true,
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: const <Widget>[
              EditFolder(),
              EditHashtag(),
            ],
          ),
        ),
      ),
    );
  }
}
