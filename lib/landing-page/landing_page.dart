import 'package:flutter/material.dart';
import 'package:hirad/components/header.dart';
import 'package:hirad/components/hero_image.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: const [Spacer(),Header(), Spacer()],
        toolbarHeight: screenHeight/10,
        ),
      extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HeroImage(),
          Stack(
            children: [
          screenWidth / screenHeight < 1.2
              ? FittedBox(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                          children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: _buildService(context, screenWidth, screenHeight),
                        ),
                      ))))
              : FittedBox(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth / 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          4,
                          (index) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: _buildService(context, screenWidth, screenHeight)),
                        ),
                      ))),
                     
            ]
          )
          
        ],
      )
    ));
  }

  Widget _buildService(BuildContext context, double screenWidth, double screenHeight) {
      return AnimatedContainer(
              width: screenWidth / screenHeight > 1.2 ? (screenWidth - (screenWidth/4) - 80) / 4 : screenWidth,
              duration: const Duration(milliseconds: 100), 
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SelectableRegion(
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "متن عنوان",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Divider(height: 20, thickness: 1, color: Theme.of(context).dividerColor,),
                  Text(
                    "در بسیاری از مواقع فورس ماژور مهمترین فاکتور برای مدیران تدارکات سرعت در تامین کالای مورد استفاده است، اگر کالای مورد نیاز تولید خارج از کشور باشد طبیعتا زمان زیادی برای انجام امور بازرگانی صرف خواهد شد، در این زمان است که بهترین گزینه خرید از انبارداران کالای صنعتی اروپائی یا همان استوکیست ها است، تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
      );
    }
}
