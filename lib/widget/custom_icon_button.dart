import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final String? isActiveIcon;
  final String? notActiveIcon;
  final IconData? activeIconData;
  final IconData? inactiveIconData;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final double activeSize;
  final double inactiveSize;

  const CustomIconButton({
    super.key,
    this.isActiveIcon,
    this.notActiveIcon,
    this.activeIconData,
    this.inactiveIconData,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.activeSize = 28.0,
    this.inactiveSize = 24.0,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.15,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - _controller.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(8.0),
          child: (widget.isActiveIcon != null || widget.notActiveIcon != null)
              ? Image.asset(
                  widget.isActive ? (widget.isActiveIcon ?? "") : (widget.notActiveIcon ?? ""),
                  width: widget.isActive ? widget.activeSize : widget.inactiveSize,
                  height: widget.isActive ? widget.activeSize : widget.inactiveSize,
                  color: widget.isActive ? (widget.activeColor ?? Colors.red) : (widget.inactiveColor ?? Colors.grey.shade500),
                  errorBuilder: (context, error, stackTrace) => Icon(
                    widget.isActive ? (widget.activeIconData ?? Icons.error) : (widget.inactiveIconData ?? Icons.error_outline),
                    size: widget.isActive ? widget.activeSize : widget.inactiveSize,
                    color: widget.isActive ? (widget.activeColor ?? Colors.red) : (widget.inactiveColor ?? Colors.grey.shade500),
                  ),
                )
              : Icon(
                  widget.isActive ? (widget.activeIconData ?? Icons.error) : (widget.inactiveIconData ?? Icons.error_outline),
                  size: widget.isActive ? widget.activeSize : widget.inactiveSize,
                  color: widget.isActive ? (widget.activeColor ?? Colors.red) : (widget.inactiveColor ?? Colors.grey.shade500),
                ),
        ),
      ),
    );
  }
}
