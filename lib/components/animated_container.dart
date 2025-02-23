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
    this.strokeWidth = 2,
    this.duration = const Duration(seconds: 2),
    this.gradientColors = const [
      Color.fromRGBO(60, 60, 60, 0.7),
      Colors.transparent
    ],
    this.radius = 24,
    this.shadowColor = Colors.transparent,
    this.backgroundColor = Colors.transparent,
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
  // ignore: unused_field
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (_isHovered) {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size!.height,
        width: widget.size!.width,
        child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovered = true;
                _controller.repeat();
              });
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
                if (!widget.isAnimated) {
                  _controller.stop();
                  _controller.reset();
                }
              });
            },
            child: Stack(children: [
              SizedBox(
                  height: widget.size!.height,
                  width: widget.size!.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.transparent,
                        )),
                  )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius),
                  child: Container(
                    height: widget.size!.height,
                    width: widget.size!.width,
                    color: widget.backgroundColor,
                    child: widget.child,
                  )),
              ClipPath(
                  clipper: CenterCutPath(
                      radius: widget.radius, thickness: widget.strokeWidth),
                  child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Container(
                          height: widget.size!.height,
                          width: widget.size!.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(widget.radius),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,
                                  colors: widget.gradientColors,
                                  transform: GradientRotation(
                                      _controller.value * 2 * pi))),
                        );
                      }))
            ])));
  }
}

class CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;
  CenterCutPath({this.radius = 0, this.thickness = 1});
  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(
        -size.width, -size.width, size.width * 2, size.height * 2);
    final double width = size.width - thickness * 2;
    final double height = size.height - thickness * 2;

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(thickness, thickness, width, height),
          Radius.circular(radius - thickness)))
      ..addRect(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}
