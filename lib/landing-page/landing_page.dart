import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hirad/components/app_bar.dart';
import 'package:hirad/landing-page/hero_image.dart';
import 'package:hirad/landing-page/service_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroImageKey = GlobalKey();
  final GlobalKey _serviceSectionKey = GlobalKey();

  bool heroImageVisible = true;
  bool serviceSectionVisible = false;
  bool logedIn = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkVisibility);
  }

  void _checkVisibility() {
    _checkWidgetVisibility(_serviceSectionKey, (isVisible) {
      if (isVisible && !serviceSectionVisible) {
        setState(() {
          serviceSectionVisible = true;
        });
      }
    });
  }

  void _checkWidgetVisibility(GlobalKey key, Function(bool) onVisibilityChange) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject != null && renderObject is RenderBox) {
      final viewport = RenderAbstractViewport.of(renderObject);
      final scrollOffset = _scrollController.offset;
      final offsetToViewport = viewport.getOffsetToReveal(renderObject, 0.5).offset;

      final isVisible = offsetToViewport <= scrollOffset + 300;
      onVisibilityChange(isVisible);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: buildAppbar(context, screenHeight, screenWidth, logedIn),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              key: _heroImageKey,
              child: const HeroImage(),
            ),
            Container(
              key: _serviceSectionKey,
              child: serviceSectionVisible ? const ServiceSection() : const SizedBox(height: 600),
            ),
          ],
        ),
      ),
    );
  }
}
