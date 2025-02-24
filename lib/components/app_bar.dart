import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hirad/components/header.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/enefty_icons.dart';
import 'package:hirad/utils/shiny_widget_effect.dart';

AppBar buildAppbar(
      BuildContext context, double screenHeight, double screenWidth, logedIn) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).colorScheme.surface, Colors.transparent],
            stops: const [0.0, 0.6]
          )
        ),
      ),
      actions: screenWidth / screenHeight > 1.4
          ? [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        loginState(context, logedIn),
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
                        loginState(context, logedIn),
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

  Widget loginState(BuildContext context, bool logedIn) {
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
          padding: const EdgeInsets.all(2),
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