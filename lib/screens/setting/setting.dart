import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/providers/token_provider.dart';
import 'package:moa_app/providers/user_provider.dart';
import 'package:moa_app/screens/setting/widgets/setting_list_tile.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/loading_indicator.dart';
import 'package:moa_app/widgets/snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Setting extends HookConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userAsync = ref.watch(userStateProvider);
    var editNicknameMode = useState(false);
    var nickname = useState('');
    var loading = useState(false);
    var appVersion = useState<String?>(null);

    void pickImage() {}

    void goEditMyType() {
      context.go('${GoRoutes.setting.fullPath}/${GoRoutes.editContent.path}');
    }

    void goContact() {
      context.go('${GoRoutes.setting.fullPath}/${GoRoutes.contact.path}');
    }

    void goTerms() {
      context.go('${GoRoutes.setting.fullPath}/${GoRoutes.terms.path}');
    }

    void goPrivacy() {
      context.go('${GoRoutes.setting.fullPath}/${GoRoutes.privacy.path}');
    }

    void goWithdraw() async {
      context.go('${GoRoutes.setting.fullPath}/${GoRoutes.withdraw.path}');
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
            if (context.mounted) {
              snackbar.alert(context,
                  kDebugMode ? e.toString() : '로그아웃에 실패했습니다 다시 시도해주세요.');
            }
          }
        },
        showCancelButton: true,
        title: '로그아웃',
        content: '로그아웃 하시겠습니까?',
      );
    }

    void changeEditNicknameMode() {
      editNicknameMode.value = true;
    }

    void editMyNickname({required String nickname}) async {
      await ref
          .read(userStateProvider.notifier)
          .editUserName(nickname: nickname);
      editNicknameMode.value = false;
      loading.value = false;
    }

    void getAppVersion() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = '${packageInfo.version}(${packageInfo.buildNumber})';
    }

    useEffect(() {
      getAppVersion();
      return null;
    }, []);

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
              userAsync.when(
                error: (error, stackTrace) {
                  return const SizedBox();
                },
                loading: () => const SizedBox(
                  height: 69,
                  child: LoadingIndicator(),
                ),
                data: (userInfo) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Image(
                          width: 78,
                          height: 69,
                          image: Assets.profileMoa,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          editNicknameMode.value
                              ? EditText(
                                  inputPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: 100,
                                  height: 30,
                                  onChanged: (value) {
                                    nickname.value = value;
                                  },
                                  hintText: userInfo?.nickname,
                                )
                              : InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                      AppColors.whiteColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2)),
                                  onTap: changeEditNicknameMode,
                                  child: Text(
                                    userInfo?.nickname ?? '',
                                    style: const H2TextStyle(),
                                  ),
                                ),
                          const SizedBox(width: 5),
                          editNicknameMode.value
                              ? Button(
                                  loading: loading.value,
                                  disabled: nickname.value == '',
                                  onPressed: () => editMyNickname(
                                    nickname: nickname.value,
                                  ),
                                  height: 30,
                                  text: '수정',
                                  textStyle: const Body1TextStyle(),
                                )
                              : CircleIconButton(
                                  width: 20,
                                  height: 20,
                                  splashColor:
                                      AppColors.whiteColor.withOpacity(0.3),
                                  backgroundColor: AppColors.blackColor,
                                  onPressed: changeEditNicknameMode,
                                  icon: Image(
                                    width: 10,
                                    height: 10,
                                    color: AppColors.whiteColor,
                                    image: Assets.pencil,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        userInfo?.email ?? '',
                        style: const Body1TextStyle().merge(TextStyle(
                            color: AppColors.blackColor.withOpacity(0.45))),
                      ),
                    ],
                  );
                },
              ),
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
                onPressed: goContact,
              ),
              SettingListTile(
                title: '이용약관',
                onPressed: goTerms,
              ),
              SettingListTile(
                title: '개인정보 처리방침',
                onPressed: goPrivacy,
              ),
              SettingListTile(
                title: '탈퇴하기',
                onPressed: goWithdraw,
              ),
              SettingListTile(
                  title: '앱 버전',
                  onPressed: () {},
                  trailing: AnimatedSwitcher(
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 300),
                    child: Text(appVersion.value ?? ''),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
