import 'package:flutter/material.dart';

enum ButtonVariant { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? iconSize;
  final double iconSpacing;
  final bool isLoading;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment contentAlignment;
  final bool useTheme;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height = 50,
    this.borderRadius = 8,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = 24,
    this.iconSpacing = 12,
    this.isLoading = false,
    this.textStyle,
    this.padding,
    this.contentAlignment = MainAxisAlignment.center,
    this.useTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textTheme = theme.textTheme;

    // Default colors based on theme
    final defaultFilledBgColor = backgroundColor ?? primaryColor;
    final defaultFilledTextColor = textColor ?? Colors.white;
    final defaultOutlinedBorderColor = borderColor ?? primaryColor;
    final defaultOutlinedTextColor = textColor ?? primaryColor;
    final defaultTextButtonColor = textColor ?? primaryColor;

    // Determine colors based on variant
    Color bgColor;
    Color txtColor;
    Color bdColor;

    switch (variant) {
      case ButtonVariant.filled:
        bgColor = defaultFilledBgColor;
        txtColor = defaultFilledTextColor;
        bdColor = bgColor;
        break;
      case ButtonVariant.outlined:
        bgColor = Colors.transparent;
        txtColor = defaultOutlinedTextColor;
        bdColor = defaultOutlinedBorderColor;
        break;
      case ButtonVariant.text:
        bgColor = Colors.transparent;
        txtColor = defaultTextButtonColor;
        bdColor = Colors.transparent;
        break;
    }

    // Button style based on variant
    final ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(bgColor),
      foregroundColor: MaterialStateProperty.all(txtColor),
      side: MaterialStateProperty.all(BorderSide(color: bdColor)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      padding: MaterialStateProperty.all(
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      minimumSize: MaterialStateProperty.all(
        Size(width ?? double.infinity, height),
      ),
    );

    // Default text style
    TextStyle defaultStyle =
        textStyle ??
        textTheme.labelLarge?.copyWith(
          color: txtColor,
          fontWeight: FontWeight.bold,
        ) ??
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: txtColor);

    // Button content
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: contentAlignment,
      children: [
        if (isLoading)
          Padding(
            padding: EdgeInsets.only(right: iconSpacing),
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(txtColor),
              ),
            ),
          )
        else if (prefixIcon != null)
          Padding(
            padding: EdgeInsets.only(right: iconSpacing),
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: prefixIcon,
            ),
          ),
        Text(text, style: defaultStyle),
        if (suffixIcon != null && !isLoading)
          Padding(
            padding: EdgeInsets.only(left: iconSpacing),
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: suffixIcon,
            ),
          ),
      ],
    );

    // Return the appropriate button based on variant
    switch (variant) {
      case ButtonVariant.filled:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
    }
  }
}
