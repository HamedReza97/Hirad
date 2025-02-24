import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Box? _box;

  DatabaseHelper._init();

  // Access the box (assumes it’s already opened in main.dart)
  Future<Box> get box async {
    if (_box != null && _box!.isOpen) {
      print('Box already open');
      return _box!;
    }
    print('Opening Hive box...');
    _box = await Hive.openBox('websiteData');
    print('Box opened');
    return _box!;
  }

  // Insert initial data (called from main.dart)
  Future<void> initializeData() async {
    final box = await this.box;
    if (box.isEmpty) {
      print('Box is empty, inserting initial data...');
      
      // Hero Metadata
      await box.put('hero_metadata', {
        'leading_title': 'شرکت تجهیز فرآیند هیراد',
        'title': 'کیفیتی سزاوار شما و اعتمادی خدشه ناپذیر',
        'trailing_title': 'مهندسی دقیق، تأمین هوشمند، و تعهد به کیفیت—همراه شما در هر گام.'
      });

      // Hero Images
      await box.put('hero_images', [
        {'title': 'فلنج و گسکت', 'subtitle': 'Flanges & Gaskets'},
        {'title': 'شیرآلات صنعتی', 'subtitle': 'Valves'},
        {'title': 'اتصالات', 'subtitle': 'Connectors'},
        {'title': 'ابزار دقیق', 'subtitle': 'Instrumentations'},
        {'title': 'لوله و تیوب', 'subtitle': 'Pipes'},
      ]);

      // Services
      await box.put('services', [
        {
          'title': 'نمایندگی رسمی برندهای معتبر',
          'icon': 'assets/images/service-icon-1.svg',
          'content':
              'تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم.'
        },
        {
          'title': 'متن عنوان',
          'icon': 'assets/images/service-icon-2.svg',
          'content':
              'تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم.'
        },
        {
          'title': 'متن عنوان',
          'icon': 'assets/images/service-icon-2.svg',
          'content':
              'تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم.'
        },
        {
          'title': 'متن عنوان',
          'icon': 'assets/images/service-icon-2.svg',
          'content':
              'تجـهیـز فرآیـنـد هـیـراد با دارا بودن روابط مستقیم با انبارداران بزرگ کالای صنعتی در ایـران امکان تـامین کـالا از ایشان را در سـریع ترین زمـان ممکن دارد ما با اخـذ ارتباط مستقیم از آنها تسهیل کننده منـابع ضروری در کـشور هستیم.'
        },                
      ]);

      // About
      await box.put('about', {
        'title': 'درباره شرکت تجهیز فرآیند هیراد',
        "content": "شرکت تجـهـیـز فـرآیـنـد هـیـراد در سـال ۱۳۹۴ در تـهـران با شماره ثبتی ۵۲۵۴۷۰ بـا بـررسی نیازمندی های صـنـایـع نــفـت, گــاز پتروشیـمی صنایـع وابسته و بـازار داخـل با ارائـه خـدمات فـنی و مهندسی به منظور تامین، تدارکات و تجهیزات فنی و صنعتی مورد نیاز صـنایـع، نفـت و گاز و پـتـروشیمی  پـالایـشگاه، نیروگاه ها، صنایـع تـولیدی، غـذایی و دارویی و سیالات  تاسیس گردیـد. شرکت تجـهـیز فـرآیـنـد هـیـراد   همواره سعی دارد با بهترین برند های جهانی از نظر کیـفـیت و اصالت کالا در ارتـبـاط و همکاری باشد تا بتواند کالایی قابل اطمینان و در عین حال با قـیـمـت مناسب در اختیار مـصـرف کنندگان قـرار بـدهـد و با تکیه به مـوجـودی انـبار داخـل و ارتباطات نزدیک با تولیدکنندگان داخلی و انبارهای خارجی آماده هرگونه پاسخگویی به استعمالات و نیاز های صنایع مرتبط باشد.رعایـت کلـیه استانداردهای بـیـن الـمـللی (ASMI,ASME,ANSI,API,EN,DIN,BS,ISO) و تحویل کالا در حضور نماینده کارفرما و ناظرین شرکـتـهـای بـازرسی و همچنین ارائه گواهینامه های مرتبط به کالا (Certificate)  از اهـداف راهـبـردی و برنامه های کاری این شرکت است.",
        'link': ''
      });

      // Statistics
      await box.put('statistics', [
        {'title': 'پروژه انجام شده', 'count': '55'},
        {'title': 'پروژه در دست اجر', 'count': '+4'},
        {'title': 'تعداد مشتری‌ها', 'count': '72'},
        {'title': 'سال تجربه کاری', 'count': '+7'},
        {'title': 'نیروی انسانی', 'count': '15'},
      ]);

      print('Initial data inserted');
    } else {
      print('Box already contains data');
    }
  }

  // Fetch Functions for Each Page
  Future<List<Map<String, dynamic>>> getHeroItems() async {
    final box = await this.box;
    final items = box.get('hero_images') as List<dynamic>? ?? [];
    print('Hero items fetched: ${items.length}');
    return items.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getHeroMetadata() async {
    final box = await this.box;
    final metadata = box.get('hero_metadata') as Map<dynamic, dynamic>? ?? {};
    print('Hero metadata fetched');
    return metadata.cast<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> getServices() async {
    final box = await this.box;
    final services = box.get('services') as List<dynamic>? ?? [];
    print('Services fetched: ${services.length}');
    return services.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getAbout() async {
    final box = await this.box;
    final about = box.get('about') as Map<dynamic, dynamic>? ?? {};
    print('About fetched');
    return about.cast<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> getStatistics() async {
    final box = await this.box;
    final stats = box.get('statistics') as List<dynamic>? ?? [];
    print('Statistics fetched: ${stats.length}');
    return stats.cast<Map<String, dynamic>>();
  }
}