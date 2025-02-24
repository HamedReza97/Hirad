import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hirad/components/app_bar.dart';
import 'package:hirad/landing-page/about_section.dart';
import 'package:hirad/landing-page/hero_image.dart';
import 'package:hirad/landing-page/service_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool serviceSectionLoaded = false;
  bool aboutSectionLoaded = false;
  bool logedIn = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScroll);
  }

  void _checkScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      setState(() {
        if (!serviceSectionLoaded) {
          serviceSectionLoaded = true;
        } else if (!aboutSectionLoaded) {
          aboutSectionLoaded = true;
        }
      });
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
            const HeroImage(),
            serviceSectionLoaded
                ? const ServiceSection()
                : SizedBox(height: screenHeight * 0.2),
            aboutSectionLoaded
                ? const AboutSection()
                : SizedBox(height: screenHeight * 0.2),
          ],
        ),
      ),
    );
  }
}
