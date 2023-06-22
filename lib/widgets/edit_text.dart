import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';

import 'package:moa_app/constants/font_constants.dart';

OutlineInputBorder focusedOutlineBorder = const OutlineInputBorder(
  // borderSide: BorderSide(width: 1.5, color: AppColors.role.basic),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

OutlineInputBorder outlineBorder = const OutlineInputBorder(
  // borderSide: BorderSide(width: 1, color: AppColors.role.basic),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

OutlineInputBorder disableBorder = const OutlineInputBorder(
  // // borderSide: BorderSide(width: 1, color: AppColors.bg.borderContrast),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

OutlineInputBorder focusedErrorBorder = const OutlineInputBorder(
  // // borderSide: BorderSide(width: 1.5, color: AppColors.role.danger),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

OutlineInputBorder errorBorder = const OutlineInputBorder(
  // // borderSide: BorderSide(width: 1, color: AppColors.role.danger),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

class EditText extends StatefulWidget {
  const EditText({
    super.key,
    required this.onChanged,
    this.style,
    this.decoration,
    this.keyboardType,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.height,
    this.borderRadius = 50,
    this.suffixIcon,
    this.backgroundColor = AppColors.textInputBackground,
  });

  final void Function(String) onChanged;
  final TextStyle? style;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final double? height;
  final double borderRadius;
  final Widget? suffixIcon;
  final Color backgroundColor;

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: widget.backgroundColor,
      ),
      height: widget.height,
      child: TextField(
        obscureText: widget.obscureText,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        style: widget.style,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 25,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.moaOpacity30,
            fontSize: 16,
            fontFamily: FontConstants.pretendard,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              width: 0,
              color: Colors.white,
            ),
          ),
        ),
        onChanged: (txt) => widget.onChanged(txt),
        keyboardType: widget.keyboardType,
      ),
    );
  }
}

class EditFormText extends HookWidget {
  const EditFormText({
    super.key,
    this.focusNode,
    this.margin,
    this.padding,
    this.label = '',
    this.hintText,
    this.cursorColor,
    this.errorText,
    this.textEditingController,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.validator,
    this.keyboardType,
    this.isSecret = false,
    this.hasChecked = false,
    this.showBorder = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputDecoration,
    this.labelStyle = const InputLabelTextStyle(),
    this.textStyle = const TextStyle(
      fontSize: 16.0,
    ),
    this.hintStyle = const TextStyle(
      fontSize: 16.0,
    ),
    this.errorStyle = const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    this.onTap,
    this.prefixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.initialValue,
  });

  final FocusNode? focusNode;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String label;
  final int minLines;
  final int maxLines;
  final InputDecoration? inputDecoration;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final String? hintText;
  final Color? cursorColor;
  final TextStyle hintStyle;
  final String? errorText;
  final TextStyle errorStyle;
  final bool isSecret;
  final bool hasChecked;
  final bool showBorder;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Widget? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLength;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    label,
                    style: labelStyle,
                  ),
                )
              : const SizedBox(),
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              TextFormField(
                initialValue: initialValue,
                key: key,
                maxLength: maxLength,
                validator: validator,
                keyboardType: keyboardType,
                obscureText: isSecret,
                focusNode: focusNode,
                minLines: minLines,
                cursorColor: cursorColor,
                maxLines: maxLines,
                controller: textEditingController,
                enabled: enabled,
                readOnly: readOnly,
                autofocus: autofocus,

                /// Set default [InputDecoration] below instead of constructor
                /// because we need to apply optional parameters given in other props.
                ///
                /// You can pass [inputDecoration] to replace default [InputDecoration].
                decoration: inputDecoration ??
                    InputDecoration(
                      prefixIcon: prefixIcon,
                      counterText: '',
                      // focusColor: AppColors.text.basic,
                      // fillColor: !enabled
                      //     ? AppColors.bg.borderContrast
                      //     : AppColors.bg.basic,
                      filled: !enabled,
                      disabledBorder:
                          showBorder ? disableBorder : InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      focusedBorder:
                          showBorder ? focusedOutlineBorder : InputBorder.none,
                      enabledBorder:
                          showBorder ? outlineBorder : InputBorder.none,
                      errorBorder: showBorder ? errorBorder : InputBorder.none,
                      focusedErrorBorder:
                          showBorder ? focusedErrorBorder : InputBorder.none,
                      hintText: hintText,
                      hintStyle: hintStyle,
                      errorText: errorText,
                      errorMaxLines: 2,
                      errorStyle: errorStyle,
                    ),
                style: textStyle.merge(const TextStyle(
                    // color: !enabled ? AppColors.text.placeholder : null,
                    )),
                onChanged: onChanged,
                onFieldSubmitted: onSubmitted,
                onEditingComplete: onEditingComplete,
                textInputAction: textInputAction,
                onTap: onTap,
                autocorrect: false,
              ),
              hasChecked
                  ? const Positioned(
                      right: 0.0,
                      top: 16.0,
                      child: Icon(
                        Icons.check,
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
