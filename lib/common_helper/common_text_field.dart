import 'package:flutter/material.dart';
import 'package:pro_product_explorer/common_helper/style_helper.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  double? height;
  EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? readOnly;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  Color? fillColor;

  CommonTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.keyboardType,
    this.maxLines,
    this.readOnly,
    this.onChanged,
    this.contentPadding,
    this.validator,
    this.fillColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height ?? 50,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines ?? 1,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        validator: validator,
        style: StyleHelper.inputText(context),
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? theme.inputDecorationTheme.fillColor ?? theme.cardColor,
          labelText: label,
          hintText: hint,
          hintStyle: StyleHelper.hintText(context),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          border: _border(context),
          enabledBorder: _border(context),
          focusedBorder: _border(context),
          errorBorder: _border(context),
          focusedErrorBorder: _border(context),
          disabledBorder: _border(context),
        ),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Theme.of(context).dividerColor, // Theme-aware border
        width: 1.2,
      ),
    );
  }
}
