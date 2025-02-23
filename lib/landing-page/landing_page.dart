import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hirad/components/animated_container.dart';
import 'package:hirad/components/header.dart';
import 'package:hirad/components/hero_image.dart';
import 'package:hirad/components/shiny_widget_effect.dart';
import 'package:hirad/utils/enefty_icons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  bool logedIn = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: buildAppbar(context, screenHeight, screenWidth),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeroImage(),
            Stack(children: [
              screenWidth / screenHeight > 1.4
                  ? buildLargeScreen(context, screenHeight, screenWidth)
                  : buildSmallScreen(context, screenHeight, screenWidth)
            ])
          ],
        )));
  }

  AppBar buildAppbar(
      BuildContext context, double screenHeight, double screenWidth) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      actions: screenWidth / screenHeight > 1.4
          ? [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        loginState(context),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {},
                            style: IconButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(39, 39, 39, 1),
                              padding: const EdgeInsets.all(10)
                            ),
                            icon: Icon(
                              EneftyIcons.search_normal_2_outline,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
                        const Spacer(),
                        const Header(),
                        const Spacer(),
                        SizedBox(
                            height: 68,
                            width: 68,
                            child: IconButton(
                              onPressed: () {},
                              icon: ShinyWidget(
                                child: SvgPicture.asset(
                                'assets/images/Hirad-logo-fav.svg',
                                height: 68,
                                width: 68,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.onPrimary,
                                  BlendMode.srcIn,
                                ),
                                )
                              ),
                            )),
                      ])))
            ]
          : [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        loginState(context),
                        const Spacer(
                          flex: 1,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(EneftyIcons.menu_outline)),
                      ]))),
            ],
      toolbarHeight: screenHeight / 10,
    );
  }

  Widget buildSmallScreen(
      BuildContext context, double screenHeight, double screenWidth) {
    return FittedBox(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.all(10),
                child: _buildService(context, screenWidth, screenHeight),
              ),
            ))));
  }

  Widget buildLargeScreen(
      BuildContext context, double screenHeight, double screenWidth) {
    return FittedBox(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth / 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildService(context, screenWidth, screenHeight)),
              ),
            )));
  }

  Widget _buildService(
      BuildContext context, double screenWidth, double screenHeight) {
    return AnimatedContainer(
      width: screenWidth / screenHeight > 1.4
          ? (screenWidth - (screenWidth / 4) - 80) / 4
          : screenWidth,
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
            Divider(
              height: 20,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
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

  Widget loginState(BuildContext context) {
    if (logedIn) {
      return const Row(
        children: [CircleAvatar()],
      );
    } else {
      return AnimatedBorderContainer(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          gradientColors: [Theme.of(context).primaryColor, Colors.transparent],
          shadowColor: const Color.fromRGBO(131, 35, 57, 0.7),
          size: const Size(140, 42),
          strokeWidth: 1,
          radius: 18,
          child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  iconColor: Theme.of(context).colorScheme.onPrimary,
                  overlayColor: Colors.transparent),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ورود/ثبت‌نام"),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(EneftyIcons.login_bold)
                ],
              )));
    }
  }
}
