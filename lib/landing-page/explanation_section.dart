import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/enefty_icons.dart';

class ExplanationSection extends StatelessWidget {
  ExplanationSection({super.key});
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onPrimary;
    return FutureBuilder(
        future: dbHelper.getExplanation(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No explanation data'));
          }
          final explanation = snapshot.data!;
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
                      child: Text(explanation['title'] ?? "",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        explanation['content'] ?? "",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.78,
                        height: 120,
                        child: ListView(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildItem(context, "تدارکات",
                                Icon(EneftyIcons.layer_bold, color: iconColor)),
                            _buildItem(context, "انبار",
                                Icon(EneftyIcons.house_2_bold, color: iconColor)),
                            _buildItem(context, "بسته‌بندی",
                                Icon(EneftyIcons.box_bold, color: iconColor)),
                            _buildItem(context, "واحد پروژه‌ها",
                                Icon(EneftyIcons.share_bold, color: iconColor)),
                            _buildItem(context, "بازرسی",
                                Icon(EneftyIcons.a_3d_cube_scan_bold, color: iconColor)),
                            _buildItem(context, "ارائه سند حمل",
                                Icon(EneftyIcons.truck_tick_bold, color: iconColor)),
                          ],
                        )),
                        AnimatedBorderContainer(
                          radius: 18,
                          duration: const Duration(seconds: 5),
                          size: Size( MediaQuery.of(context).size.width/ MediaQuery.of(context).size.height > 1.4 ? 
                          MediaQuery.of(context).size.width * 0.65 : MediaQuery.of(context).size.width * 0.8, 
                          MediaQuery.of(context).size.width/ MediaQuery.of(context).size.height > 1.4 ? 42 
                          : (MediaQuery.of(context).size.width/ MediaQuery.of(context).size.height > 0.8 ? 72 : 100)),
                          child: Center(child: Text(explanation['subtitle'] ?? "",
                          textDirection: TextDirection.rtl,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,))
                        )
                  ]))
            ],
          );
        });
  }

  Widget _buildItem(BuildContext context, String title, Icon icon) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01),
        child: SizedBox(
          height: 80,
          width: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBorderContainer(
                shadowColor: const Color.fromRGBO(255, 255, 255, 0.08),
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.02),
                size: const Size(155, 56),
                radius: 22,
                strokeWidth: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(39, 39, 39, 1),
                  ),
                  child: icon,
                ),
              ),
            ],
          ),
        ));
  }
}
