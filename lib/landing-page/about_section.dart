import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/enefty_icons.dart';
import 'package:hirad/utils/validators.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});
  @override
  AboutSectionState createState() => AboutSectionState();
}

class AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
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
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.7],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
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
                      ))),
              Positioned(
                top: 60,
                left: MediaQuery.of(context).size.width / 2 - 4,
                child: const CircleAvatar(
                  backgroundColor: Color.fromRGBO(40, 40, 40, 1),
                  radius: 4,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.11),
                  child: Column(children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromRGBO(40, 40, 40, 1)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.7],
                        ),
                      ),
                      height: 60,
                      width: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      color: const Color.fromRGBO(18, 18, 18, 1),
                      child: Text(about['title'],
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        about['content'],
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AnimatedBorderContainer.primaryButton(
                        size: const Size(320, 42),
                        strokeWidth: 1,
                        padding: const EdgeInsets.all(2),
                        radius: 18,
                        child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                iconColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                overlayColor: Colors.transparent),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("دانلود کاتالوگ / Download Catalogue",
                                textDirection: TextDirection.rtl,),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(EneftyIcons.document_download_outline)
                              ],
                            ))),
                            const SizedBox(height: 30,),
                            buildStats((context))
                  ]))
            ],
          );
        });
  }

Widget buildStats(BuildContext context) {
  return FutureBuilder(
    future: dbHelper.getStatistics(),
    builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No stat data'));
      }
      
      final stats = snapshot.data!;

      return AnimatedBorderContainer(
  size: Size(MediaQuery.of(context).size.width * 0.7, 100),
  child: LayoutBuilder(
    builder: (context, constraints) {
      // Calculate available width per item
      final int itemCount = stats.length;
      final double availableWidth = constraints.maxWidth;
      const double idealItemWidth = 120.0;
      final double totalIdealWidth = idealItemWidth * itemCount;
      
      // Determine if scaling is needed
      final bool needsScaling = totalIdealWidth > availableWidth;
      final double scaleFactor = needsScaling ? availableWidth / totalIdealWidth : 1.0;
      final double actualItemWidth = needsScaling ? idealItemWidth * scaleFactor : idealItemWidth;
      
      return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) {
          return Container(
            width: actualItemWidth,
            padding: EdgeInsets.all(needsScaling ? 4 : 8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  Text(
                    (stat['count'] as String).toPersianNumbers(),
                    style: Theme.of(context).textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stat['title'] as String,
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    },
  ),
);
    },
  );
}

}
