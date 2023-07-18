import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';
import 'package:moa_app/widgets/moa_widgets/error_text.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class EditContent extends HookWidget {
  const EditContent({
    super.key,
    required this.title,
    required this.updatedContentName,
    required this.contentName,
    required this.onPressed,
    this.buttonText,
    this.maxLength,
    this.validator,
  });
  final String title;
  final ValueNotifier<String> updatedContentName;
  final String contentName;
  final Function() onPressed;
  final String? buttonText;
  final int? maxLength;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    var controller = useTextEditingController();
    var forRender = useState('');
    var errorText = useState('');

    void onChangedContentValue(String value) {
      forRender.value = value;
      updatedContentName.value = value;
    }

    void emptyContentName() {
      forRender.value = '';

      updatedContentName.value = '';
      controller.text = '';
    }

    void editContent() async {
      var error = await onPressed();
      errorText.value = error ?? '';
      if (controller.text.isEmpty || error != '') {
        return;
      }

      if (context.mounted) {
        context.pop();
      }
      emptyContentName();
    }

    void closeBottomSheet() {
      context.pop();
      emptyContentName();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                Center(
                  child: Text(title, style: const H2TextStyle()),
                ),
                const SizedBox(height: 30),
                EditFormText(
                  maxLength: maxLength ?? 7,
                  controller: controller,
                  onChanged: onChangedContentValue,
                  hintText: contentName,
                  backgroundColor: AppColors.textInputBackground,
                  suffixIcon: CircleIconButton(
                    icon: Image(
                      fit: BoxFit.contain,
                      image: Assets.circleClose,
                      width: 16,
                      height: 16,
                    ),
                    onPressed: emptyContentName,
                  ),
                ),
                ErrorText(
                    errorText: errorText.value,
                    errorValidate: errorText.value != ''),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      '${controller.text.length}/${maxLength ?? 7}',
                      style: TextStyle(
                          color: controller.text.length >= (maxLength ?? 7)
                              ? AppColors.danger
                              : AppColors.blackColor.withOpacity(0.3),
                          fontSize: 12,
                          fontFamily: FontConstants.pretendard),
                    ),
                  ],
                ),
                const Spacer(),
                Button(
                  disabled: controller.text.isEmpty,
                  margin: const EdgeInsets.only(bottom: 30),
                  text: buttonText ?? '수정하기',
                  onPress: editContent,
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
              color: Colors.black,
              size: 30,
            ),
          ),
        )
      ]),
    );
  }
}
