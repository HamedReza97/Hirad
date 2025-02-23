import 'package:flutter/material.dart';

enum ShineDirection {
  current,  
  horizontal,
  vertical,
}

class ShinyWidget extends StatefulWidget {
  final Widget child;
  final double size;
  final Duration duration;
  final ShineDirection direction;

  const ShinyWidget({
    super.key,
    required this.child,
    this.size = 68,
    this.duration = const Duration(seconds: 2),
    this.direction = ShineDirection.current, 
  });

  @override
  ShinyWidgetState createState() => ShinyWidgetState();
}

class ShinyWidgetState extends State<ShinyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _getBeginAlignment() {
    switch (widget.direction) {
      case ShineDirection.horizontal:
        return Alignment(-1 + 2 * _controller.value, 0);
      case ShineDirection.vertical:
        return Alignment(0, -1 + 2 * _controller.value);
      case ShineDirection.current:
      return Alignment(-1 + 2 * _controller.value, -1); 
    }
  }

  Alignment _getEndAlignment() {
    switch (widget.direction) {
      case ShineDirection.horizontal:
        return Alignment(1 + 2 * _controller.value, 0);
      case ShineDirection.vertical:
        return Alignment(0, 1 + 2 * _controller.value); 
      case ShineDirection.current:
      return Alignment(1 + 2 * _controller.value, 1); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: _getBeginAlignment(),
              end: _getEndAlignment(),
              colors: [
                Colors.transparent,
                Colors.white.withAlpha(200),
                Colors.transparent,
              ],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
