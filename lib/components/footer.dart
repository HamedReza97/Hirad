import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/utils/enefty_icons.dart';
import 'package:hirad/utils/shiny_widget_effect.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});
  @override
  FooterState createState() => FooterState();
}

class FooterState extends State<Footer> {
  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width / size.height > 1.4) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(padding: const EdgeInsets.only(top: 30),
        child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),
        gradient: LinearGradient(colors:[Color.fromRGBO(255, 255, 255, 0.12), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.3, 1]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(25, 25, 25, 1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),
          ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildFooterItems(context, false))
        )
        )
        ))
        );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(padding: const EdgeInsets.only(top: 30),
        child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),
        gradient: LinearGradient(colors:[Color.fromRGBO(255, 255, 255, 0.12), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.3, 1]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(25, 25, 25, 1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildFooterItems(context, true),
        )
        )))
        ),
      );
    }
  }

buildFooterItems(BuildContext context, bool isPortrait) {
  return [
    SizedBox(
      width: isPortrait ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.22,
      child: ShinyWidget(
        child: Image.asset(
          'assets/images/Hirad-logo-full.png',
          height: 120,
          width: 200,
        ),
      ),
    ),
    isPortrait ? const SizedBox(height: 20) : const SizedBox.shrink(),
    SizedBox(
      width: isPortrait ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.35,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isPortrait ? 2 : 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          childAspectRatio: 4,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final items = [
            'خانه',
            'خدمات شرکت',
            'استانداردها',
            'درباره ما',
            'بلاگ',
            'تماس با ما',
          ];
          return TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  EneftyIcons.arrow_left_2_outline,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    items[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    isPortrait ? const SizedBox(height: 20) : const SizedBox.shrink(),
    SizedBox(
      width: isPortrait ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.36,
      child: buildContact(context)
    )
  ];
}

Widget buildContact(BuildContext context) {
  return FutureBuilder(
    future: dbHelper.getFooter(),
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
      final contactInfo = snapshot.data!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactItem(
            context, 
            EneftyIcons.location_outline, 
            [contactInfo['address']]
          ),
          _buildContactItem(
            context, 
            EneftyIcons.call_calling_outline, 
            contactInfo['phone']
          ),
          _buildContactItem(
            context, 
            EneftyIcons.message_outline, 
            contactInfo['whatsapp']
          ),
          _buildContactItem(
            context, 
            EneftyIcons.sms_outline, 
            contactInfo['email']
          ),
        ],
      );
    }
  );
}

// Helper method to build contact items
Widget _buildContactItem(BuildContext context, IconData icon, List<dynamic> items) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 32,
          width: 32,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    item.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              )
            ).toList(),
          ),
        ),
      ],
    ),
  );
}
}
