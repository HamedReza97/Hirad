import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';

class StandardSection extends StatefulWidget {
  const StandardSection({super.key});
  @override
  StandardSectionState createState() => StandardSectionState();
}

class StandardSectionState extends State<StandardSection>
    with SingleTickerProviderStateMixin {
  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbHelper.getStandard(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No standard data'));
          }
          final standard = snapshot.data!;
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
                      child: Text(standard['title'],
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        standard['content'],
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
                      height: 100,
                      child: buildLogoList(context, standard['logo_files']),
                    )
                  ]))
            ],
          );
        });
  }

  Widget buildLogoList(BuildContext context, List<String> logos) {
    return ListView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      children: List.generate(logos.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          child: Image.asset(
            logos[index],
            fit: BoxFit.cover,
          ),
        );
      }),
    );
  }
}
