import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';
import 'package:moa_app/widgets/edit_text.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class EditContent extends HookWidget {
  const EditContent({
    super.key,
    required this.title,
    required this.updatedContentName,
    required this.contentName,
    required this.onPressed,
  });
  final String title;
  final ValueNotifier<String> updatedContentName;
  final String contentName;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    var controller = useTextEditingController();
    var forRender = useState('');

    void onChangedContentValue(String value) {
      forRender.value = value;

      updatedContentName.value = value;
    }

    void emptyContentName() {
      forRender.value = '';

      updatedContentName.value = '';
      controller.text = '';
    }

    void editContent() {
      if (controller.text.isEmpty) {
        return;
      }

      onPressed();
      context.pop();
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
                  maxLength: 7,
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
                const Spacer(),
                Button(
                  disabled: controller.text.isEmpty,
                  margin: const EdgeInsets.only(bottom: 30),
                  text: '수정하기',
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
