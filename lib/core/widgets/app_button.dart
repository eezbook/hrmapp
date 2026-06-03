import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(label),
            ],
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label);

    final btn = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: color != null
                ? OutlinedButton.styleFrom(foregroundColor: color)
                : null,
            child: child,
          )
        : FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: color != null
                ? FilledButton.styleFrom(backgroundColor: color)
                : null,
            child: child,
          );

    if (width != null) {
      return SizedBox(width: width, child: btn);
    }
    return SizedBox(width: double.infinity, child: btn);
  }
}
