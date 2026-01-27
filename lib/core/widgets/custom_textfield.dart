import 'package:flutter/material.dart';
import 'package:smart_health_consultation/core/constants/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          textInputAction: textInputAction,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          initialValue: initialValue,
          decoration: AppStyles.inputDecoration.copyWith(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}