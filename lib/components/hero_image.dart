import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hirad/components/animated_container.dart';
import 'package:hirad/components/interactive_background/particle_system.dart';
import 'package:hirad/utils/enefty_icons.dart';

class HeroImage extends StatefulWidget {
  const HeroImage({super.key});

  @override
  HeroImageState createState() => HeroImageState();
}

class HeroImageState extends State<HeroImage>{
   @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
   return SizedBox(
            height: screenHeight,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: -screenHeight/2,
                  left: 0,
                  right: 0,
                  child: 
                ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
            child: Container(
              width: screenHeight,
              height: screenHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.05)
              ),
            ),
          ),
                ),
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: const ParticleSystemWidget(),
                ),
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight-screenHeight/2+screenHeight/10,
            child: buildTitle(context))
        ]));
  }
  Widget buildTitle(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Text("شرکت تجهیز فرآیند هیراد",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10,),
          Text("کیفیتی سزاوار شما و اعتمادی خدشه ناپذیر",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 10,),
          Text("مهندسی دقیق، تأمین هوشمند، و تعهد به کیفیت—همراه شما در هر گام.",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: (Theme.of(context).textTheme.titleMedium)!.merge(TextStyle(color: Theme.of(context).hintColor)),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlowingSpinningContainer(
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.10),
                shadowColor: const Color.fromRGBO(255, 255, 255, 0.10),
                size: const Size(160, 38),
                radius: 14,
                child: TextButton(onPressed: (){

                }, 
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  overlayColor: Colors.transparent
                ),
                child: 
                    const Text(
                      "مشاهده محصولات"
                    ),
                    )
              ),
              const SizedBox(width: 20,),
              GlowingSpinningContainer(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                gradientColors: [Theme.of(context).primaryColor, Colors.transparent],
                shadowColor: const Color.fromRGBO(131, 35, 57, 0.7),
                size: const Size(160, 38),
                radius: 14,
                child: TextButton(onPressed: (){

                }, 
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  overlayColor: Colors.transparent
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "درباره شرکت"
                    ),
                    const SizedBox(width: 4,),
                    Icon(EneftyIcons.information_bold,
                    color: Theme.of(context).colorScheme.onPrimary,)
                  ],
                ),
                    )
              ),
            ],
          )
      ],
      )
    );
  }
}