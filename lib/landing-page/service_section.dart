import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServiceSection extends StatefulWidget{
  const ServiceSection({super.key});
  @override
  ServiceSectionState createState() => ServiceSectionState();
}

class ServiceSectionState extends State<ServiceSection> with SingleTickerProviderStateMixin{
  late AnimationController controller;
late Animation<double> fadeAnimation;
late Animation<Offset> slideAnimation;

@override
void initState() {
  super.initState();
  controller = createController(this);
  fadeAnimation = createFadeAnimation(controller);
  slideAnimation = createSlideAnimation(controller);
  
  controller.forward(); 
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

AnimationController createController(TickerProvider vsync) {
  return AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: vsync,
  );
}

Animation<double> createFadeAnimation(AnimationController controller) {
  return CurvedAnimation(
    parent: controller,
    curve: Curves.easeIn,
  );
}

Animation<Offset> createSlideAnimation(AnimationController controller) {
  return Tween<Offset>(
    begin: const Offset(0, -0.3), 
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  ));
}

  List<Map<String, dynamic>> servicceList = [
    {
      "title" : "نمایندگی رسمی برندهای معتبر",
      "icon" : "assets/images/service-icon-1.svg",
      "content": " تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم."
    },
        {
      "title" : "متن عنوان",
      "icon" : "assets/images/service-icon-2.svg",
      "content": " تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم."
    },
        {
      "title" : "متن عنوان",
      "icon" : "assets/images/service-icon-3.svg",
      "content": " تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم."
    },
        {
      "title" : "متن عنوان",
      "icon" : "assets/images/service-icon-4.svg",
      "content": " تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم."
    }
  ];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if(screenSize.width / screenSize.height > 1.4){
      return buildLargeScreen(context, screenSize.height, screenSize.width);
    }
    else{
      return buildSmallScreen(context, screenSize.height, screenSize.width);
    }
  }

Widget buildSmallScreen(
    BuildContext context, double screenHeight, double screenWidth) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth / 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        servicceList.length,
        (index) {
          final item = servicceList[index];

          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildService(context, screenWidth, screenHeight, item),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}


  Widget buildLargeScreen(
    BuildContext context,
    double screenHeight,
    double screenWidth,
  ) {
  return Stack(
    children: [
      Positioned(
        top: 0,
        left: screenWidth / 2,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color.fromRGBO(40, 40, 40, 1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.3],
                  ),
                ),
                height: 200,
                width: 1,
              ),
            ),
          ),
        ),
      ),

      Positioned(
        top: 196,
        left: screenWidth / 2 - 3,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: const CircleAvatar(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              radius: 4,
            ),
          ),
        ),
      ),

      Positioned(
        top: 200,
        left: screenWidth / 4 - 80,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(servicceList.length - 1, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: (screenWidth - (screenWidth / 4 + 40)) / 4,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          top: BorderSide(color: Color.fromRGBO(40, 40, 40, 1), width: 1),
                          left: BorderSide(color: Color.fromRGBO(40, 40, 40, 1), width: 1),
                          right: BorderSide(color: Color.fromRGBO(40, 40, 40, 1), width: 1),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: screenWidth / 8, right: screenWidth / 8, top: 240),
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(servicceList.length, (index) {
                final item = servicceList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: (screenWidth - (screenWidth / 4) - 80) / 4,
                    child: _buildService(context, screenWidth, screenHeight, item),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    ],
  );
}
  Widget _buildService(
      BuildContext context, double screenWidth, double screenHeight, Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors:[Color.fromRGBO(255, 255, 255, 0.12), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.3, 1]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.circular(23),
          ),
          child: SelectableRegion(
        focusNode: FocusNode(),
        selectionControls: MaterialTextSelectionControls(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              item['icon'],
              height: 60,
              width: 60,
            ),
            const SizedBox(height: 10),
            Text(
              item['title'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5,),
            Container(
              padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(255, 255, 255, 0.04),
            ),
            child: Text(
              item['content'],
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            ),
            ),
          ],
        ),
      ),
        )
      )
    );
  }
}