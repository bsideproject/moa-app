import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/user_model.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/repositories/user_repository.dart';
import 'package:moa_app/screens/setting/widgets/setting_list_tile.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';
import 'package:moa_app/widgets/snackbar.dart';

class Setting extends HookConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void pickImage() {}

    void goEditMyType() {
      context.go('${GoRoutes.setting.fullPath}/${GoRoutes.editContent.path}');
    }

    void handleContact() {}

    void handleTerms() {}

    void showRemoveUserPopup() async {
      alertDialog.confirm(
        context,
        onPress: () async {
          try {
            await UserRepository.instance.removeUser();
            await ref.read(tokenStateProvider.notifier).removeToken();
            if (context.mounted) {
              context.go(GoRoutes.signIn.fullPath);
            }
          } catch (e) {
            snackbar.alert(
                context, kDebugMode ? e.toString() : '회원탈퇴에 실패했습니다 다시 시도해주세요.');
          }
        },
        showCancelButton: true,
        title: '회원탈퇴',
        content: '회원탈퇴 하시겠습니까?',
      );
    }

    void showLogoutPopup() {
      alertDialog.confirm(
        context,
        onPress: () async {
          try {
            await ref.read(tokenStateProvider.notifier).removeToken();
            if (context.mounted) {
              context.go(GoRoutes.signIn.fullPath);
            }
          } catch (e) {
            snackbar.alert(
                context, kDebugMode ? e.toString() : '로그아웃에 실패했습니다 다시 시도해주세요.');
          }
        },
        showCancelButton: true,
        title: '로그아웃',
        content: '로그아웃 하시겠습니까?',
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: showLogoutPopup,
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontConstants.pretendard,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<UserModel?>(
                  future: UserRepository.instance.getUser(),
                  builder: (context, snapshot) {
                    var userInfo = snapshot.data;
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: Stack(
                              children: [
                                Image(
                                  width: 78,
                                  height: 69,
                                  image: Assets.profileMoa,
                                ),
                                // const CircleAvatar(
                                //   radius: 50,
                                //   backgroundImage: NetworkImage(
                                //       'https://avatars.githubusercontent.com/u/73378472?v=4'),
                                // ),
                                // Positioned(
                                //   bottom: 0,
                                //   right: 0,
                                //   child: Container(
                                //     width: 25,
                                //     height: 25,
                                //     padding: const EdgeInsets.all(6),
                                //     decoration: BoxDecoration(
                                //       color: AppColors.blackColor,
                                //       borderRadius: BorderRadius.circular(50),
                                //     ),
                                //     child: Image(
                                //       color: AppColors.whiteColor,
                                //       image: Assets.pencil,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userInfo?.nickname ?? '',
                            style: const H2TextStyle(),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            userInfo?.email ?? '',
                            style: const Body1TextStyle().merge(TextStyle(
                                color: AppColors.blackColor.withOpacity(0.45))),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),
              const SizedBox(height: 30),
              const Divider(
                thickness: 10,
                color: AppColors.textInputBackground,
              ),
              SettingListTile(
                title: '내 취향관리',
                onPressed: goEditMyType,
              ),
              SettingListTile(
                title: '1:1 문의하기',
                onPressed: handleContact,
              ),
              SettingListTile(
                title: '이용약관',
                onPressed: handleTerms,
              ),
              SettingListTile(
                title: '탈퇴하기',
                onPressed: showRemoveUserPopup,
              )
            ],
          ),
        ),
      ),
    );
  }
}
