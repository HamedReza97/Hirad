import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/enefty_icons.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: dbHelper.getAbout(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No about data'));
        }

        final about = snapshot.data!;
        return Stack(
          children: [
            Positioned(
              top: 87,
              left: screenWidth * 0.1,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.0, 0.7],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  width: screenWidth * 0.8,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                          color: Color.fromRGBO(40, 40, 40, 1), width: 1),
                      left: BorderSide(
                          color: Color.fromRGBO(40, 40, 40, 1), width: 1),
                      right: BorderSide(
                          color: Color.fromRGBO(40, 40, 40, 1), width: 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.11),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const CircleAvatar(
                    backgroundColor: Color.fromRGBO(40, 40, 40, 1),
                    radius: 4,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Text(
                      about['title'],
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      about['content'],
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedBorderContainer.primaryButton(
                    size: const Size(320, 42),
                    strokeWidth: 1,
                    padding: const EdgeInsets.all(2),
                    radius: 18,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        overlayColor: Colors.transparent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "دانلود کاتالوگ / Download Catalogue",
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(width: 4),
                          Icon(EneftyIcons.document_download_outline)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    child: Container(
                      height: 200,
                      width: screenWidth * 0.7,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
