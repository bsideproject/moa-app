import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/providers/folder_view_provider.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/snackbar.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class AddFolder extends HookConsumerWidget {
  const AddFolder({super.key, required this.onRefresh});
  final Function onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var folderAsync = ref.watch(folderViewProvider);
    var folderNameController = useTextEditingController();
    var folderName = useState('');
    var loading = useState(false);

    void folderOnChangedValue(String value) {
      folderName.value = value;
    }

    void emptyFolderName() {
      folderName.value = '';
      folderNameController.text = '';
    }

    void addFolder() async {
      if ((folderAsync.value?.length ?? 0) >= 20) {
        snackbar.alert(context, '폴더는 최대 20개까지 추가할 수 있습니다.');
        return;
      }
      if (folderNameController.text.isEmpty) {
        return;
      }

      try {
        loading.value = true;
        await FolderRepository.instance.addFolder(folderName: folderName.value);
        await ref
            .read(folderViewProvider.notifier)
            .addFolder(folderName: folderName.value);
        onRefresh();
        if (context.mounted) {
          context.pop();
        }
        emptyFolderName();
      } on DioError catch (e) {
        // 폴더 중복 에러 처리
        if (e.response?.statusCode == 409) {
          snackbar.alert(context, '이미 가지고 있는 폴더이름이에요');
        }
      } finally {
        loading.value = false;
      }
    }

    void closeBottomSheet() {
      context.pop();
      emptyFolderName();
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Center(
                  child: Text('폴더 추가', style: H2TextStyle()),
                ),
                const SizedBox(height: 30),
                EditFormText(
                  maxLength: 7,
                  controller: folderNameController,
                  onChanged: folderOnChangedValue,
                  hintText: '폴더명을 입력하세요.',
                  backgroundColor: AppColors.textInputBackground,
                  suffixIcon: CircleIconButton(
                    icon: Image(
                      fit: BoxFit.contain,
                      image: Assets.circleClose,
                      width: 16,
                      height: 16,
                    ),
                    onPressed: emptyFolderName,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      '${folderNameController.text.length}/7',
                      style: TextStyle(
                          color: folderNameController.text.length == 7
                              ? AppColors.danger
                              : AppColors.blackColor.withOpacity(0.3),
                          fontSize: 12,
                          fontFamily: FontConstants.pretendard),
                    ),
                  ],
                ),
                const Spacer(),
                Button(
                  loading: loading.value,
                  disabled: folderNameController.text.isEmpty,
                  margin: const EdgeInsets.only(bottom: 30),
                  text: '추가하기',
                  onPress: addFolder,
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 12,
          child: CircleIconButton(
            backgroundColor: Colors.white,
            onPressed: closeBottomSheet,
            icon: const Icon(
              Icons.close,
              color: AppColors.blackColor,
              size: 30,
            ),
          ),
        )
      ]),
    );
  }
}
