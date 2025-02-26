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
  
  // Controllers to determine when sections should be loaded
  final ScrollController _scrollController = ScrollController();
  bool _isServiceSectionVisible = false;
  bool _isAboutSectionVisible = false;
  bool _isProductSectionVisible = false;
  
  // Estimated heights to help calculate when to load sections
  final double _heroSectionHeight = 600; // Adjust based on your actual height
  final double _serviceSectionHeight = 500; // Adjust based on your actual height
  final double _aboutSectionHeight = 500; // Adjust based on your actual height
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    final double offset = _scrollController.offset;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Buffer to load sections before they're fully visible (preload threshold)
    final double preloadThreshold = screenHeight * 0.5;
    
    // Check if service section should be visible
    if (!_isServiceSectionVisible && 
        offset + screenHeight + preloadThreshold > _heroSectionHeight) {
      setState(() {
        _isServiceSectionVisible = true;
      });
    }
    
    // Check if about section should be visible
    if (!_isAboutSectionVisible && 
        offset + screenHeight + preloadThreshold > _heroSectionHeight + _serviceSectionHeight) {
      setState(() {
        _isAboutSectionVisible = true;
      });
    }
    
    // Check if product section should be visible
    if (!_isProductSectionVisible && 
        offset + screenHeight + preloadThreshold > _heroSectionHeight + _serviceSectionHeight + _aboutSectionHeight) {
      setState(() {
        _isProductSectionVisible = true;
      });
    }
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
            // Hero section always loads immediately
            const HeroImage(),
            
            // Service section loads when scrolled near it
            _isServiceSectionVisible 
                ? const ServiceSection() 
                : SizedBox(height: _serviceSectionHeight),
            
            // About section loads when scrolled near it
            _isAboutSectionVisible 
                ? const AboutSection() 
                : SizedBox(height: _aboutSectionHeight),
                
            // Product section loads when scrolled near it
            _isProductSectionVisible
                ? const ProductSection()
                : const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }
}