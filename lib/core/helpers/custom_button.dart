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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    const Color lBase = Color(0xFFE8E8E8);
    const Color lShadowDark = Color(0xFFC5C5C5);
    const Color lShadowLight = Color(0xFFFFFFFF);

    const Color dBase = Color(0xFF2E3239);
    const Color dShadowDark = Color(0xFF1D2025);
    const Color dShadowLight = Color(0xFF3E444D);

    final Color baseColor = isDark ? dBase : lBase;
    final Color shadowDark = isDark ? dShadowDark : lShadowDark;
    final Color shadowLight = isDark ? dShadowLight : lShadowLight;
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF090909);

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
