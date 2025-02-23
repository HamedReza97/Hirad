import 'package:flutter/material.dart';
import 'package:hirad/utils/animated_container.dart';

class Header extends StatefulWidget {
  const Header({super.key});
  @override
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> with WidgetsBindingObserver {
  final List<String> menuItems = [
    "خانه",
    "خدمات شرکت",
    "استانداردها",
    "درباره ما",
    "بلاگ",
    "تماس با ما"
  ];
  int selectedIndex = 0;
  final List<GlobalKey> _keys = [];
  final GlobalKey _menuKey = GlobalKey();
  double _indicatorPosition = 0;
  double _indicatorVertical = 12;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _keys.addAll(List.generate(menuItems.length, (index) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

void _updateIndicator() {
    if (_keys[selectedIndex].currentContext != null && 
        _menuKey.currentContext != null) {
        final RenderBox itemBox = _keys[selectedIndex].currentContext!.findRenderObject() as RenderBox;
        final RenderBox menuBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
        final Offset itemGlobalPos = itemBox.localToGlobal(Offset.zero);
        final Offset menuGlobalPos = menuBox.localToGlobal(Offset.zero);
        
        double newIndicatorPosition = (itemGlobalPos.dx - menuGlobalPos.dx) + (itemBox.size.width / 2) - 35;
        double newIndicatorVertical = menuGlobalPos.dy - 7;

        if (_indicatorPosition != newIndicatorPosition || _indicatorVertical != newIndicatorVertical) {
            setState(() {
                _indicatorPosition = newIndicatorPosition;
                _indicatorVertical = newIndicatorVertical;
            });
        }
    }
}  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          bottom: _indicatorVertical,
          left: _indicatorPosition,
          child: Container(
            width: 70,
            height: 14,
            decoration: BoxDecoration(
              color: _indicatorPosition == 0
                  ? Colors.transparent
                  : const Color.fromRGBO(131, 35, 57, 1),
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(12),
                bottomEnd: Radius.circular(12),
              ),
            ),
          ),
        ),
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height > 1 ?  Center(
          child: Container(
            key: _menuKey,
            child: buildMenu(context),
          ),
        ) : const SizedBox.shrink()
      ],
    );
  }

  Widget buildMenu(BuildContext context) {
    return AnimatedBorderContainer(
      size: Size(
          MediaQuery.of(context).size.width < 1200
              ? MediaQuery.of(context).size.width / 3 * 2
              : 800,
          48),
      duration: const Duration(minutes: 1),
      strokeWidth: 1,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.04),
      shadowColor: const Color.fromRGBO(255, 255, 255, 0.04),
      radius: 22,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(MediaQuery.of(context).size.width / MediaQuery.of(context).size.height > 1.2 ? menuItems.length : menuItems.length -1, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextButton(
              key: _keys[index],
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _updateIndicator());
              },
              style: TextButton.styleFrom(
                overlayColor: Colors.transparent,
              ),
              child: Text(
                menuItems[index],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }),
      ),
    );
  }
}
