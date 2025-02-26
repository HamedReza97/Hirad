import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBorderContainer extends StatefulWidget {
  final double strokeWidth;
  final Duration duration;
  final List<Color> gradientColors;
  final double radius;
  final Color backgroundColor;
  final Color shadowColor;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Size? size;
  final bool isAnimated;

  const AnimatedBorderContainer({
    super.key,
    this.strokeWidth = 1,
    this.duration = const Duration(seconds: 2),
    this.gradientColors = const [
      Color.fromRGBO(60, 60, 60, 0.7),
      Colors.transparent
    ],
    this.radius = 24,
    this.shadowColor = const Color.fromRGBO(255, 255, 255, 0.08),
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.04),
    this.padding = const EdgeInsets.all(8),
    this.size,
    required this.child,
    this.isAnimated = false,
  });

  const AnimatedBorderContainer.primaryButton({
    super.key,
    this.strokeWidth = 1,
    this.duration = const Duration(seconds: 2),
    this.gradientColors = const [
      Color.fromRGBO(131, 35, 57, 1),
      Colors.transparent
    ],
    this.radius = 24,
    this.shadowColor = const Color.fromRGBO(131, 35, 57, 0.7),
    this.backgroundColor = const Color.fromRGBO(81, 25, 34, 1),
    this.padding = const EdgeInsets.all(4),
    this.size,
    required this.child,
    this.isAnimated = false,
  });

  const AnimatedBorderContainer.secondaryButton({
    super.key,
    this.strokeWidth = 1,
    this.duration = const Duration(seconds: 2),
    this.gradientColors = const [
      Color.fromRGBO(255, 255, 255, 0.14),
      Colors.transparent
    ],
    this.radius = 24,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.10),
    this.shadowColor = const Color.fromRGBO(255, 255, 255, 0.10),
    this.padding = const EdgeInsets.all(4),
    this.size,
    required this.child,
    this.isAnimated = false,
  });

  @override
  AnimatedBorderContainerState createState() => AnimatedBorderContainerState();
}

class AnimatedBorderContainerState extends State<AnimatedBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  
  late BorderRadius _borderRadius;
  late CenterCutPath _clipPath;
  
  late BoxDecoration _shadowDecoration;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _updateCachedValues();
    
    if (widget.isAnimated) {
      _controller.repeat();
    }
  }
  
  @override
  void didUpdateWidget(AnimatedBorderContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.radius != widget.radius || 
        oldWidget.strokeWidth != widget.strokeWidth ||
        oldWidget.shadowColor != widget.shadowColor) {
      _updateCachedValues();
    }
  }
  
  void _updateCachedValues() {
    _borderRadius = BorderRadius.circular(widget.radius);
    _clipPath = CenterCutPath(radius: widget.radius, thickness: widget.strokeWidth);
    _shadowDecoration = BoxDecoration(
      borderRadius: _borderRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, widget.shadowColor],
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleMouseEnter(_) {
    if (_isHovered) return;
    
    setState(() {
      _isHovered = true;
      _controller.repeat();
    });
  }

  void _handleMouseExit(_) {
    if (!_isHovered) return;
    
    setState(() {
      _isHovered = false;
      if (!widget.isAnimated) {
        _controller.stop();
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size?.height,
      width: widget.size?.width,
      child: MouseRegion(
        onEnter: _handleMouseEnter,
        onExit: _handleMouseExit,
        child: Stack(
          children: [
            // Blur effect - costly operation
            // ignore: deprecated_member_use
            if (widget.backgroundColor.opacity > 0)
              ClipRRect(
                borderRadius: _borderRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: widget.size?.height,
                    width: widget.size?.width,
                    color: Colors.transparent),
                ),
              ),
              
            // Shadow container
            Container(
              height: widget.size?.height,
              width: widget.size?.width,
              decoration: _shadowDecoration,
            ),
            
            // Content container
            ClipRRect(
              borderRadius: _borderRadius,
              child: Container(
                height: widget.size?.height,
                width: widget.size?.width,
                padding: widget.padding,
                color: widget.backgroundColor,
                child: widget.child,
              ),
            ),
            
            // Animated border
            RepaintBoundary(
              child: ClipPath(
                clipper: _clipPath,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Container(
                      height: widget.size?.height,
                      width: widget.size?.width,
                      decoration: BoxDecoration(
                        borderRadius: _borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          colors: widget.gradientColors,
                          transform: GradientRotation(_controller.value * 2 * pi),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;
  
  const CenterCutPath({this.radius = 0, this.thickness = 1});
  
  @override
  Path getClip(Size size) {
    final double width = size.width - thickness * 2;
    final double height = size.height - thickness * 2;
    final double borderRadius = max(0, radius - thickness);
    
    final inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(thickness, thickness, width, height),
      Radius.circular(borderRadius)
    );
    
    final outer = Rect.fromLTWH(-thickness, -thickness, 
      size.width + thickness * 2, size.height + thickness * 2);
    
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(inner)
      ..addRect(outer);
      
    return path;
  }

  @override
  bool shouldReclip(covariant CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}