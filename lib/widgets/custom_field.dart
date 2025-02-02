import 'package:flutter/material.dart';

import '../core/services/styles.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.controller,
    this.filled = false,
    this.obscureText = false,
    this.readOnly = false,
    this.validator,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.enabledBorderColor,
    this.backgroundColor,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.mainStyle,
    this.overrideValidator = false,
    this.defaultBorder = true,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColor;
  final Color? backgroundColor;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Color? enabledBorderColor;
  final Widget? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final bool defaultBorder;
  final TextStyle? hintStyle;
  final TextStyle? mainStyle;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: overrideValidator
          ? validator
          : (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return validator?.call(value);
            },
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      onTap: () => FocusScope.of(context).requestFocus(),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      style: mainStyle,
      decoration: InputDecoration(
        border: defaultBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              )
            : InputBorder.none,
        enabledBorder: defaultBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: enabledBorderColor ?? Styles.kPrimaryBlue,
                ),
              )
            : InputBorder.none,
        focusedBorder: defaultBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Styles.kPrimaryBlue,
                ),
              )
            : InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        filled: filled,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconColor: Styles.kPrimarySlateBlue,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        hintText: hintText,
        hintStyle: hintStyle ??
            Styles.bodyMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
