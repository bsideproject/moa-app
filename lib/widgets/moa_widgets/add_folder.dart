import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class AddFolder extends HookWidget {
  const AddFolder({super.key});

  @override
  Widget build(BuildContext context) {
    var folderNameController = useTextEditingController();
    var folderName = useState('');

    void folderOnChangedValue(String value) {
      folderName.value = value;
    }

    void emptyFolderName() {
      folderNameController.text = '';
    }

    void addFolder() {
      if (folderNameController.text.isEmpty) {
        return;
      }

      // todo 폴더 추가 api 연동후 성공하면 아래 코드 실행 실패시 snackbar 경고
      context.pop();
      emptyFolderName();
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
