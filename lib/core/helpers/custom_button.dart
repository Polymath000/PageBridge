import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  const CustomButton({super.key, this.onPressed});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    if (widget.onPressed != null) setState(() => _isPressed = true);
  }

  void _onPointerUp(PointerUpEvent event) {
    if (widget.onPressed != null) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const Color lBase = AppColors.neumorphicBaseLight;
    const Color lShadowDark = AppColors.neumorphicShadowDarkLight;
    const Color lShadowLight = AppColors.neumorphicShadowLightLight;

    const Color dBase = AppColors.neumorphicBaseDark;
    const Color dShadowDark = AppColors.neumorphicShadowDarkDark;
    const Color dShadowLight = AppColors.neumorphicShadowLightDark;

    final Color baseColor = isDark ? dBase : lBase;
    final Color shadowDark = isDark ? dShadowDark : lShadowDark;
    final Color shadowLight = isDark ? dShadowLight : lShadowLight;
    final Color textColor = isDark ? AppColors.white70 : AppColors.neumorphicTextDark;

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Center(
        child: Listener(
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 35),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isPressed
                    ? [
                        // "Pressed" state: Shadows are inverted/tightened to look inset
                        BoxShadow(
                          color: shadowDark,
                          offset: const Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: shadowLight,
                          offset: const Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: shadowDark,
                          offset: const Offset(6, 6),
                          blurRadius: 12,
                        ),
                        BoxShadow(
                          color: shadowLight,
                          offset: const Offset(-6, -6),
                          blurRadius: 12,
                        ),
                      ],
              ),
              child: Text(
                'CREATE NEW PAGE',
                style: TextStyle(
                  color: _isPressed
                      ? textColor.withValues(alpha: 0.5)
                      : textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
