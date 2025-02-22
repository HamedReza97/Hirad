import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class GlowingSpinningContainer extends StatefulWidget {
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

  const GlowingSpinningContainer({
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
  GlowingSpinningContainerState createState() =>
      GlowingSpinningContainerState();
}

class GlowingSpinningContainerState extends State<GlowingSpinningContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // ignore: unused_field
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.isAnimated) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = widget.size?.width ??
              (constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.of(context).size.width);
          final double height = widget.size?.height ??
              (constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : MediaQuery.of(context).size.height);

          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.radius),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height,
                width: width,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RotatingGradientPainter(
                        strokeWidth: widget.strokeWidth,
                        gradientColors: widget.gradientColors,
                        radius: widget.radius,
                        rotation: _controller.value * 2 * pi,
                      ),
                      child: child,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius),
                    child: InnerGlow(
                      padding: widget.padding,
                      glowRadius: widget.radius,
                      thickness: height / 4,
                      glowBlur: height / 4,
                      strokeLinearGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [widget.shadowColor, Colors.transparent],
                      ),
                      baseDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.radius),
                        color: widget.backgroundColor,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class RotatingGradientPainter extends CustomPainter {
  final double strokeWidth;
  final List<Color> gradientColors;
  final double radius;
  final double rotation;

  RotatingGradientPainter({
    required this.strokeWidth,
    required this.gradientColors,
    required this.radius,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final shader = LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
      transform: GradientRotation(rotation),
    ).createShader(rect);

    final Paint paint = Paint()
      ..shader = shader
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rRect =
        RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant RotatingGradientPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors ||
        oldDelegate.radius != radius;
  }
}

/// **Inner glow effect using a CustomPainter**
class CustomPainterInnerGlow extends CustomPainter {
  final double stroke, blur, radius;
  final LinearGradient linearGradient;

  CustomPainterInnerGlow(this.stroke, this.blur, this.radius, this.linearGradient);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    final borderRadius = Radius.circular(radius);
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius,
      topRight: borderRadius,
      bottomLeft: borderRadius,
      bottomRight: borderRadius,
    );

    final path = Path()..addRRect(rect);

    paint.shader = linearGradient.createShader(path.getBounds());

    canvas.clipPath(path);
    canvas.saveLayer(rect.outerRect, paint);
    canvas.drawRRect(rect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// **Inner glow wrapper widget**
class InnerGlow extends StatelessWidget {
  const InnerGlow({
    super.key,
    required this.glowRadius,
    this.thickness = 10,
    this.glowBlur = 5,
    this.child,
    this.padding = const EdgeInsets.all(4),
    this.blurBackground = 0,
    this.strokeLinearGradient =
        const LinearGradient(colors: [Colors.white, Colors.white]),
    this.baseDecoration = const BoxDecoration(color: Colors.transparent),
    this.margin = const EdgeInsets.all(0),
  });

  final double glowBlur, glowRadius, thickness, blurBackground;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final LinearGradient strokeLinearGradient;
  final BoxDecoration baseDecoration;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: baseDecoration,
      child: ClipRect(
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaY: blurBackground, sigmaX: blurBackground),
          child: CustomPaint(
            painter: CustomPainterInnerGlow(thickness, glowBlur, glowRadius, strokeLinearGradient),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
