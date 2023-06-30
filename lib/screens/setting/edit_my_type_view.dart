import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/screens/home/folder_detail_view.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/dynamic_grid_list.dart';
import 'package:moa_app/widgets/folder_list.dart';
import 'package:moa_app/widgets/moa_widgets/add_folder.dart';

class EditMyTypeView extends HookWidget {
  const EditMyTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    TabController tabController = useTabController(initialLength: 2);
    var tabIdx = useState(0);

    List<FolderModel> folderList = [
      const FolderModel(id: 0, title: 'title', content: 'content'),
      const FolderModel(id: 0, title: 'title2', content: 'content2'),
      const FolderModel(id: 0, title: 'title3', content: 'content3'),
      const FolderModel(id: 0, title: 'title4', content: 'content4'),
    ];

    Future<void> folderPullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    Future<void> hashtagPullToRefresh() async {
      return Future.delayed(
        const Duration(seconds: 2),
        () {},
      );
    }

    void showAddFolderModal() {
      General.instance.showBottomSheet(
        context: context,
        child: const AddFolder(),
        isContainer: false,
      );
    }

    void goFolderDetailView(String title) {
      context.push(
        '${GoRoutes.home.fullPath}/${GoRoutes.folderDetail.path}/$title',
        extra: FolderDetailView(folderName: title),
      );
    }

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
        isBottomBorderDisplayed: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: ExtendedNestedScrollView(
          onlyOneScrollInBody: true,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                delegate: PersistentTabBar(
                  backgroundColor: AppColors.whiteColor,
                  tabController: tabController,
                  isClick: true,
                  isEditScreen: true,
                ),
                pinned: true,
                // floating: true,
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              RefreshIndicator(
                onRefresh: folderPullToRefresh,
                child: GridView.builder(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  itemCount: folderList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > Breakpoints.md ? 4 : 2,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 12.0,
                  ),
                  itemBuilder: (context, index) {
                    var item = folderList[index];
                    return index == 0
                        ? InkWell(
                            splashColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            onTap: showAddFolderModal,
                            child: Image(image: Assets.emptyFolder),
                          )
                        : FolderList(
                            folder: item,
                            folderColor: folderColors[index % 4],
                            onPress: () => goFolderDetailView(item.title),
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: DynamicGridList(
                  pullToRefresh: hashtagPullToRefresh,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
