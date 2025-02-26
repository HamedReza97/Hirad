import 'package:flutter/material.dart';
import 'package:hirad/components/app_bar.dart';
import 'package:hirad/landing-page/about_section.dart';
import 'package:hirad/landing-page/hero_image.dart';
import 'package:hirad/landing-page/product_section.dart';
import 'package:hirad/landing-page/service_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  bool logedIn = false;
  late ScrollController _scrollController;
  
  // Using ValueNotifier for more efficient state updates
  final _visibilityNotifier = ValueNotifier({
    'service': false,
    'about': false,
    'product': false,
  });
  
  // Precalculated section offsets
  static const double _heroSectionHeight = 600;
  static const double _serviceSectionHeight = 500;
  static const double _aboutSectionHeight = 500;
  static const double _productSectionHeight = 500;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // Preload initial content
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInitialVisibility());
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _visibilityNotifier.dispose();
    super.dispose();
  }
  
  void _checkInitialVisibility() {
    if (!mounted) return;
    _onScroll();
  }
  
  void _onScroll() {
    if (!mounted) return;
    
    final offset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;
    final preloadThreshold = screenHeight * 0.7;
    
    Map<String, bool> updates = {};
    
    if (!_visibilityNotifier.value['service']! && 
        offset + screenHeight + preloadThreshold > _heroSectionHeight) {
      updates['service'] = true;
    }
    
    if (!_visibilityNotifier.value['about']! && 
        offset + screenHeight + preloadThreshold > _heroSectionHeight + _serviceSectionHeight) {
      updates['about'] = true;
    }
    
    if (!_visibilityNotifier.value['product']! && 
        offset + screenHeight + preloadThreshold > 
            _heroSectionHeight + _serviceSectionHeight + _aboutSectionHeight) {
      updates['product'] = true;
    }
    
    if (updates.isNotEmpty) {
      _visibilityNotifier.value = {
        ..._visibilityNotifier.value,
        ...updates,
      };
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(
        context, 
        MediaQuery.sizeOf(context).height, 
        MediaQuery.sizeOf(context).width, 
        logedIn,
      ),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(), 
        slivers: [
          const SliverToBoxAdapter(child: HeroImage()),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Map<String, bool>>(
              valueListenable: _visibilityNotifier,
              builder: (context, visibility, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: visibility['service']!
                    ? const ServiceSection()
                    : const SizedBox(height: _serviceSectionHeight),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Map<String, bool>>(
              valueListenable: _visibilityNotifier,
              builder: (context, visibility, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: visibility['about']!
                    ? const AboutSection()
                    : const SizedBox(height: _aboutSectionHeight),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Map<String, bool>>(
              valueListenable: _visibilityNotifier,
              builder: (context, visibility, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: visibility['product']!
                    ? const ProductSection()
                    : const SizedBox(height: _productSectionHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}