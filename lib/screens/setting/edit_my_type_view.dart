import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/app_constants.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/screens/home/home.dart';
import 'package:moa_app/utils/general.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/folder_list.dart';
import 'package:moa_app/widgets/moa_widgets/add_folder.dart';
import 'package:moa_app/widgets/moa_widgets/dynamic_grid_list.dart';

class EditMyTypeView extends HookWidget {
  const EditMyTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    TabController tabController = useTabController(initialLength: 2);
    var tabIdx = useState(0);

    List<FolderModel> folderList = [
      const FolderModel(folderId: '0', folderName: '책', count: 2),
      const FolderModel(folderId: '1', folderName: '모바일', count: 32),
      const FolderModel(folderId: '2', folderName: '공부', count: 1),
      const FolderModel(folderId: '3', folderName: '컴퓨터', count: 5),
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
        child: AddFolder(
          onRefresh: () {
            // source.refresh(true);
          },
        ),
        isContainer: false,
      );
    }

    void goFolderDetailView(String id) {
      context.push(
        '${GoRoutes.folder.fullPath}/$id',
      );
    }

    void editFolderName(String id) {
      // General.instance.showBottomSheet(
      //   context: context,
      //   child: AddFolder(
      //     folderId: folderId,
      //     onRefresh: () {
      //       source.refresh(true);
      //     },
      //   ),
      //   isContainer: false,
      // );
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
        title: '내 취향 관리',
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
                  folderCount: 0,
                  contentCount: 0,
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
                    crossAxisCount: width > Breakpoints.md ? 3 : 2,
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
                            onPressMore: () => editFolderName(item.folderId),
                            onPress: () => goFolderDetailView(item.folderId),
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
