import 'package:flutter/material.dart';

class DayNightSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double scale;

  const DayNightSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.scale = 1.0,
  });

  @override
  State<DayNightSwitch> createState() => _DayNightSwitchState();
}

class _DayNightSwitchState extends State<DayNightSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Colors based on the CSS variables
  final Color _containerLightBg = const Color(0xFF3D7EAE);
  final Color _containerNightBg = const Color(0xFF1D1F2C);
  final Color _sunBg = const Color(0xFFECCA2F);
  final Color _moonBg = const Color(0xFFC4C9D1);
  final Color _spotColor = const Color(0xFF959DB1);
  final Color _cloudsColor = const Color(0xFFF3FDFF);
  final Color _backCloudsColor = const Color(0xFFAACADF);
  final Color _starsColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Replicating the CSS transition: cubic-bezier(0, -0.02, 0.4, 1.25)
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0, -0.02, 0.4, 1.25),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(DayNightSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaling factor (1em = ~24px to match standard toggle sizes)
    const double em = 12.0;
    const double width = 5.625 * em;
    const double height = 2.5 * em;
    const double toggleDiameter = 2.125 * em;
    const double circleContainerSize = 3.375 * em;
    final double circleEdgeShift = 0.42 * em;

    return Transform.scale(
      scale: widget.scale.clamp(0.5, 1.2),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          widget.onChanged(!widget.value);
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final isNight = _animation.value;

            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color.lerp(
                  _containerLightBg,
                  _containerNightBg,
                  isNight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, -1.5),
                    blurRadius: 1.5,
                  ),
                  BoxShadow(
                    color: Colors.white70,
                    offset: Offset(0, 1.5),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Stack(
                  children: [
                    // Inner Shadow Simulation using a gradient
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black12, Colors.transparent],
                        ),
                      ),
                    ),

                    // Stars
                    Positioned(
                      top:
                          height * 0.5 * isNight -
                          (height * 0.5) * (1 - isNight),
                      left: 0.312 * em,
                      child: Opacity(
                        opacity: isNight.clamp(0.0, 1.0),
                        child: _buildStars(em),
                      ),
                    ),

                    // Clouds
                    Positioned(
                      bottom: -0.625 * em - (4.062 * em * isNight),
                      left: 0.312 * em,
                      child: _buildClouds(em),
                    ),

                    // Toggle Button Container (The glowing circle area)
                    Positioned(
                      left:
                          ((width - circleContainerSize) * isNight) +
                          ((circleContainerSize - height) / 2 * -1) +
                          circleEdgeShift,
                      top: (height - circleContainerSize) / 2,
                      child: Container(
                        width: circleContainerSize,
                        height: circleContainerSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 0.625 * em,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: toggleDiameter,
                          height: toggleDiameter,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _sunBg,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1.5, 3),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Stack(
                              children: [
                                // Sun Base is the container color above
                                // Moon Overlay sliding in from the right
                                Positioned.fill(
                                  child: FractionalTranslation(
                                    translation: Offset(1.0 - isNight, 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _moonBg,
                                      ),
                                      child: Stack(
                                        children: [
                                          // Moon spots
                                          Positioned(
                                            top: 0.75 * em,
                                            left: 0.312 * em,
                                            child: _buildSpot(0.75 * em),
                                          ),
                                          Positioned(
                                            top: 0.937 * em,
                                            left: 1.375 * em,
                                            child: _buildSpot(0.375 * em),
                                          ),
                                          Positioned(
                                            top: 0.312 * em,
                                            left: 0.812 * em,
                                            child: _buildSpot(0.25 * em),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: _spotColor),
    );
  }

  // Translating the CSS box-shadow cloud drawing technique to Flutter
  Widget _buildClouds(double em) {
    return Container(
      width: 1.25 * em,
      height: 1.25 * em,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _cloudsColor,
        boxShadow: [
          BoxShadow(
            color: _cloudsColor,
            offset: Offset(0.937 * em, 0.312 * em),
          ),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(-0.312 * em, -0.312 * em),
          ),
          BoxShadow(
            color: _cloudsColor,
            offset: Offset(1.437 * em, 0.375 * em),
          ),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(0.5 * em, -0.125 * em),
          ),
          BoxShadow(color: _cloudsColor, offset: Offset(2.187 * em, 0)),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(1.25 * em, -0.062 * em),
          ),
          BoxShadow(
            color: _cloudsColor,
            offset: Offset(2.937 * em, 0.312 * em),
          ),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(2 * em, -0.312 * em),
          ),
          BoxShadow(
            color: _cloudsColor,
            offset: Offset(3.625 * em, -0.062 * em),
          ),
          BoxShadow(color: _backCloudsColor, offset: Offset(2.625 * em, 0)),
          BoxShadow(color: _cloudsColor, offset: Offset(4.5 * em, -0.312 * em)),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(3.375 * em, -0.437 * em),
          ),
          BoxShadow(
            color: _cloudsColor,
            offset: Offset(4.625 * em, -1.75 * em),
            spreadRadius: 0.437 * em,
          ),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(4 * em, -0.625 * em),
          ),
          BoxShadow(
            color: _backCloudsColor,
            offset: Offset(4.125 * em, -2.125 * em),
            spreadRadius: 0.437 * em,
          ),
        ],
      ),
    );
  }

  // Using a simplified representation of the SVG stars
  Widget _buildStars(double em) {
    return SizedBox(
      width: 2.75 * em,
      height: 2.75 * em,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0.5 * em,
            child: Icon(Icons.star, color: _starsColor, size: 0.5 * em),
          ),
          Positioned(
            top: 1 * em,
            left: 2 * em,
            child: Icon(Icons.star, color: _starsColor, size: 0.4 * em),
          ),
          Positioned(
            top: 2 * em,
            left: 0 * em,
            child: Icon(Icons.star, color: _starsColor, size: 0.3 * em),
          ),
          Positioned(
            top: 1.5 * em,
            left: 1 * em,
            child: Icon(Icons.circle, color: _starsColor, size: 0.15 * em),
          ),
          Positioned(
            top: 0.5 * em,
            left: 1.5 * em,
            child: Icon(Icons.circle, color: _starsColor, size: 0.15 * em),
          ),
        ],
      ),
    );
  }
}
