import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/animated_line.dart';
// import 'package:hirad/utils/interactive_background/particle_system.dart';
import 'package:hirad/utils/enefty_icons.dart';

class HeroImage extends StatefulWidget{
  const HeroImage({super.key});

  @override
  HeroImageState createState() => HeroImageState();
}

class HeroImageState extends State<HeroImage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> items = [
    {'title': 'فلنج و گسکت', 'subtitle': 'Flanges & Gaskets'},
    {'title': 'شیرآلات صنعتی', 'subtitle': 'Valves'},
    {'title': 'اتصالات', 'subtitle': 'Connectors'},
    {'title': 'ابزار دقیق', 'subtitle': 'Instrumentations'},
    {'title': 'لوله و تیوب', 'subtitle': 'Pipes'},
  ];

  List<double> topFactors = [0.45, 0.2, 0.3, 0.45, 0.2];
  List<double> leftFactors = [0.10, 0.24, 0.45, 0.75, 0.65];

  late AnimationController _controller;
  late Animation<double> _animation;

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth/screenHeight > 1.4){
      topFactors = [0.45, 0.2, 0.3, 0.45, 0.2];
      leftFactors = [0.10, 0.24, 0.45, 0.75, 0.65];
    }
    else{
      topFactors = [0.5, 0.2, 0.34, 0.42, 0.25];
      leftFactors = [0.05, 0.05, 0.15, 0.5, 0.53];
    }
    List<Offset> itemCenters = [];
    List<Offset> connectorStarts = [];
    List<Widget> positionedItems = [];

    for (int i = 0; i < items.length; i++) {
      double top = topFactors[i] * screenHeight;
      double left = leftFactors[i] * screenWidth;
      Offset center = Offset(left + 97.5, top + 60);
      itemCenters.add(center);
      double midpoint = screenHeight * 0.30;
      double verticalMidPoint = screenWidth * 0.5;
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
        startX = screenWidth;
      }
      startY = startY.clamp(0, screenHeight);
      connectorStarts.add(Offset(startX, startY));
      positionedItems.add(AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double animValue = _animation.value;
            return Positioned(
                top: top - (30 * (1 - animValue)),
                left: left,
                child: Transform.scale(
                    scale: 0.3 + (0.7 * animValue),
                    child: buildItem(
                      context,
                      items[i]['title'].toString(),
                      items[i]['subtitle'].toString(),
                      const Icon(EneftyIcons.setting_2_outline),
                    )));
          }));
    }
    return SizedBox(
      height: screenWidth/screenHeight > 1.4 ? screenHeight *0.85 : screenHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -screenHeight / 2,
            left: 0,
            right: 0,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
              child: Container(
                width: screenHeight,
                height: screenHeight,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 255, 255, 0.05),
                ),
              ),
            ),
          ),
          // ImageFiltered(
          //   imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          //   child: const ParticleSystemWidget(),
          // ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: AnimatedLinePainter(
                  starts: connectorStarts,
                  ends: itemCenters,
                  animationValue: _animation.value,
                ),
              );
            },
          ),
          ...positionedItems,
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight - screenHeight / 2 + screenHeight / 10,
            child: buildTitle(context),
          ),
        ],
      ),
    );
  }

  Widget buildItem(
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

  Widget buildTitle(BuildContext context) {
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


