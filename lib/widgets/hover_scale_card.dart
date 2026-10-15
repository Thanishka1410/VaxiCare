import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_animations.dart';

/// Interactive card wrapper that provides subtle desktop hover elevation and mobile press feedback
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double hoverElevation;
  final double hoverTranslateY;
  final Color? borderColor;
  final Color? hoverBorderColor;

  const HoverScaleCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.hoverElevation = 6.0,
    this.hoverTranslateY = -3.0,
    this.borderColor,
    this.hoverBorderColor,
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(16);
    final currentBorder = _isHovered
        ? (widget.hoverBorderColor ?? AppColors.primaryBlue.withValues(alpha: 0.35))
        : (widget.borderColor ?? AppColors.border);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.defaultCurve,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? widget.hoverTranslateY : (_isPressed ? 1.0 : 0.0))
            ..scale(_isPressed ? 0.985 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: currentBorder, width: _isHovered ? 1.2 : 1.0),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.08),
                      blurRadius: widget.hoverElevation * 2,
                      offset: Offset(0, widget.hoverElevation),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
