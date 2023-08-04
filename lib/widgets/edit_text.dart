import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moa_app/constants/color_constants.dart';

import 'package:moa_app/constants/font_constants.dart';

OutlineInputBorder inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(100),
  borderSide: const BorderSide(
    color: AppColors.whiteColor,
  ),
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
    this.width,
    this.height,
    this.borderRadius,
    this.suffixIcon,
    this.backgroundColor = AppColors.textInputBackground,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.padding,
    this.inputPadding,
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
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Color backgroundColor;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? inputPadding;

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(100),
        color: widget.backgroundColor,
      ),
      height: widget.height,
      width: widget.width,
      child: TextField(
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        controller: widget.controller,
        obscureText: widget.obscureText,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        style: const Hash1TextStyle().merge(widget.style),
        decoration: InputDecoration(
          counterText: '',
          suffixIcon: widget.suffixIcon,
          contentPadding: widget.inputPadding ??
              const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
          hintText: widget.hintText,
          hintStyle: const Hash1TextStyle()
              .merge(TextStyle(
                color: AppColors.moaOpacity30,
              ))
              .merge(widget.style),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Colors.transparent,
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
    this.hintText,
    this.cursorColor,
    this.errorText,
    this.controller,
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
    this.textStyle,
    this.hintStyle,
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
    this.backgroundColor = AppColors.textInputBackground,
    this.suffixIcon,
  });

  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final InputDecoration? inputDecoration;
  final TextStyle labelStyle;
  final TextStyle? textStyle;
  final String? hintText;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final String? errorText;
  final TextStyle errorStyle;
  final bool isSecret;
  final bool hasChecked;
  final bool showBorder;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
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
  final Color backgroundColor;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,

      /// Set default [InputDecoration] below instead of constructor
      /// because we need to apply optional parameters given in other props.
      ///
      /// You can pass [inputDecoration] to replace default [InputDecoration].
      decoration: inputDecoration ??
          InputDecoration(
            fillColor: backgroundColor,
            filled: true,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            counterText: '',
            disabledBorder: inputBorder,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorder,
            hintText: hintText,
            hintStyle: const Hash1TextStyle()
                .merge(TextStyle(color: AppColors.moaOpacity30))
                .merge(hintStyle),
            errorText: errorText,
            errorMaxLines: 2,
            errorStyle: errorStyle,
          ),
      style: const Hash1TextStyle().merge(textStyle),

      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      onTap: onTap,
      autocorrect: false,
    );
  }
}
