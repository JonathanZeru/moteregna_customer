import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedButton extends StatefulWidget {
  final double width;
  final double height;
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onPressed;
  final String startText;
  final String stopText;
  final IconData startIcon;
  final IconData stopIcon;
  final Color startColor;
  final Color stopColor;
  final bool isDark;

  const AnimatedButton({
    super.key,
    required this.width,
    required this.height,
    required this.isActive,
    required this.isLoading,
    required this.onPressed,
    required this.startText,
    required this.stopText,
    required this.startIcon,
    required this.stopIcon,
    required this.startColor,
    required this.stopColor,
    this.isDark = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? widget.stopColor : widget.startColor;
    
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = true);
          _animationController.forward();
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = false);
          _animationController.reverse();
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        if (!widget.isLoading) {
          setState(() => _isPressed = false);
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(_isPressed ? 0.8 : 0.5),
                blurRadius: widget.isDark
                    ? (_isPressed ? 15 : 10)
                    : (_isPressed ? 10 : 5),
                spreadRadius: widget.isDark
                    ? (_isPressed ? 3 : 1)
                    : (_isPressed ? 2 : 0.5),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.isActive ? widget.stopIcon : widget.startIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.isActive ? widget.stopText : widget.startText,
                        style: GoogleFonts.orbitron(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

