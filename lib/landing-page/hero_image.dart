import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/animated_line.dart';
import 'package:hirad/utils/enefty_icons.dart';

class HeroImage extends StatefulWidget {
  const HeroImage({super.key});

  @override
  HeroImageState createState() => HeroImageState();
}

class HeroImageState extends State<HeroImage>
    with SingleTickerProviderStateMixin {
  // Using const for immutable lists
  static const List<Map<String, String>> items = [
    {'title': 'فلنج و گسکت', 'subtitle': 'Flanges & Gaskets'},
    {'title': 'شیرآلات صنعتی', 'subtitle': 'Valves'},
    {'title': 'اتصالات', 'subtitle': 'Connectors'},
    {'title': 'ابزار دقیق', 'subtitle': 'Instrumentations'},
    {'title': 'لوله و تیوب', 'subtitle': 'Pipes'},
  ];

  // Initialize these lists once and modify when needed
  final List<double> _topFactors = [0.45, 0.2, 0.3, 0.45, 0.2];
  final List<double> _leftFactors = [0.10, 0.24, 0.45, 0.75, 0.65];
  final List<double> _topFactorsMobile = [0.5, 0.2, 0.34, 0.42, 0.25];
  final List<double> _leftFactorsMobile = [0.05, 0.05, 0.15, 0.5, 0.53];

  late AnimationController _controller;
  late Animation<double> _animation;
  
  // Cache calculation results
  late double _screenHeight;
  late double _screenWidth;
  late bool _isWideScreen;
  final List<Offset> _itemCenters = [];
  final List<Offset> _connectorStarts = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Precalculate positions based on screen size
  void _calculatePositions(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    _isWideScreen = _screenWidth / _screenHeight > 1.4;
    
    _itemCenters.clear();
    _connectorStarts.clear();
    
    final topFactors = _isWideScreen ? _topFactors : _topFactorsMobile;
    final leftFactors = _isWideScreen ? _leftFactors : _leftFactorsMobile;
    
    final double midpoint = _screenHeight * 0.30;
    final double verticalMidPoint = _screenWidth * 0.5;
    
    for (int i = 0; i < items.length; i++) {
      final double top = topFactors[i] * _screenHeight;
      final double left = leftFactors[i] * _screenWidth;
      final Offset center = Offset(left + 97.5, top + 60);
      _itemCenters.add(center);
      
      double startY;
      double startX;
      
      if (center.dy < midpoint) {
        startY = center.dy - 130;
      } else {
        startY = center.dy + 130;
      }
      
      if (center.dx < verticalMidPoint) {
        startX = 0;
      } else {
        startX = _screenWidth;
      }
      
      startY = startY.clamp(0, _screenHeight);
      _connectorStarts.add(Offset(startX, startY));
    }
  }

  // Memoize item widget creation
  Widget _buildItemWithAnimation(int index, double animValue) {
    final double top = (_isWideScreen ? _topFactors : _topFactorsMobile)[index] * _screenHeight;
    final double left = (_isWideScreen ? _leftFactors : _leftFactorsMobile)[index] * _screenWidth;
    
    return Positioned(
      top: top - (30 * (1 - animValue)),
      left: left,
      child: Transform.scale(
        scale: 0.3 + (0.7 * animValue),
        child: _buildItem(
          context,
          items[index]['title'] ?? '',
          items[index]['subtitle'] ?? '',
          const Icon(EneftyIcons.setting_2_outline),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculatePositions(context);
    
    return SizedBox(
      height: _isWideScreen ? _screenHeight * 0.85 : _screenHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Background blur - rarely changes, could be const
          Positioned(
            top: -_screenHeight / 2,
            left: 0,
            right: 0,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
              child: Container(
                width: _screenHeight,
                height: _screenHeight,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 255, 255, 0.05),
                ),
              ),
            ),
          ),
          
          // Animated lines
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                painter: AnimatedLinePainter(
                  starts: _connectorStarts,
                  ends: _itemCenters,
                  animationValue: _animation.value,
                ),
              );
            },
          ),
          
          // Positioned items with animation
          ..._buildPositionedItems(),
          
          // Title section
          Positioned(
            left: 0,
            right: 0,
            top: _screenHeight - _screenHeight / 2 + _screenHeight / 10,
            child: _buildTitle(context),
          ),
        ],
      ),
    );
  }

  // Extract positionedItems generation to a separate method for clarity
  List<Widget> _buildPositionedItems() {
    return List.generate(items.length, (i) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, _) => _buildItemWithAnimation(i, _animation.value),
      );
    });
  }

  Widget _buildItem(
      BuildContext context, String title, String subTitle, Icon icon) {
    return SizedBox(
      height: 120,
      width: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBorderContainer(
            shadowColor: const Color.fromRGBO(255, 255, 255, 0.08),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.02),
            size: const Size(170, 68),
            strokeWidth: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  subTitle,
                  style: (Theme.of(context).textTheme.bodyMedium)!
                      .copyWith(fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(39, 39, 39, 1),
              ),
              child: icon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "شرکت تجهیز فرآیند هیراد",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "کیفیتی سزاوار شما و اعتمادی خدشه ناپذیر",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 10),
          Text(
            "مهندسی دقیق، تأمین هوشمند، و تعهد به کیفیت—همراه شما در هر گام.",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: (Theme.of(context).textTheme.titleMedium)!.merge(
              TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBorderContainer.secondaryButton(
                size: const Size(160, 42),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    overlayColor: Colors.transparent,
                  ),
                  child: const Text("مشاهده محصولات"),
                ),
              ),
              const SizedBox(width: 20),
              AnimatedBorderContainer.primaryButton(
                size: const Size(160, 42),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    overlayColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("درباره شرکت"),
                      const SizedBox(width: 4),
                      Icon(
                        EneftyIcons.information_bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}