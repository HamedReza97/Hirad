// ignore_for_file: avoid_print

import 'package:hirad/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Box? _websiteBox;
  static Box? _productsBox;

  DatabaseHelper._init();

  // Initialize boxes
  Future<void> openBoxes() async {
    _websiteBox = await Hive.openBox('websiteData');
    _productsBox = await Hive.openBox('products');
    print('Boxes opened');
  }

  // Access websiteData box
  Future<Box> get websiteBox async {
    if (_websiteBox != null && _websiteBox!.isOpen) {
      print('Website box already open');
      return _websiteBox!;
    }
    print('Opening website box...');
    _websiteBox = await Hive.openBox('websiteData');
    return _websiteBox!;
  }

  // Access products box
  Future<Box> get productsBox async {
    if (_productsBox != null && _productsBox!.isOpen) {
      print('Products box already open');
      return _productsBox!;
    }
    print('Opening products box...');
    _productsBox = await Hive.openBox('products');
    return _productsBox!;
  }


  // Insert initial data (called from main.dart)
  Future<void> initializeData() async {
    final box = await websiteBox;
    final productBox = await productsBox;

    if (box.isEmpty) {
      print('Box is empty, inserting initial data...');
      // Hero Metadata
      await box.put('hero_metadata', {
        'leading_title': 'شرکت تجهیز فرآیند هیراد',
        'title': 'کیفیتی سزاوار شما و اعتمادی خدشه ناپذیر',
        'trailing_title': 'مهندسی دقیق، تأمین هوشمند، و تعهد به کیفیت—همراه شما در هر گام.'
      });

      // Hero Image Items
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

      // Standards
      await box.put('standards', {
        'title': 'استانداردها',
        'content': 'وجود و تعریف استانداردهای متعدد جهانی باعث گردیده هم مشتریان و هم تامین کنندگان از زبانی مشترک بهره مند گردند و مشخصات فنی کالای درخواستی بر مبنای همین استانداردها تعیین شده؛ لذا تسلط و درک کامل شرکت اطلس پادیر از تمامی استانداردها به ویژه استانداردهای حوزه پایپینگ متریال، باعث می گردد کالای درخواستی طبق نیاز مشتری عرضه گردد تا از بعد فنی آرامش ایشان فراهم گردد.',
        'logo_files': [
          "assets/upload/standards/ansi.png",
          "assets/upload/standards/api.png",
          "assets/upload/standards/astm.png",
          "assets/upload/standards/mss.png",
          "assets/upload/standards/nace.png"
        ]
      });

      print('Initial data inserted');
    } else {
      print('Box already contains data');
    }

   if (productBox.isEmpty) {
  print('Box is empty, inserting initial data...');

  final initialProducts = {
    'فلنج و گسکت': ProductCategory(
      categoryName: 'فلنج و گسکت',
      introduction: ProductIntroduction(
        title: 'فلنج و گسکت',
        imageUrl: 'assets/images/image.jpg',
        content: 'توضیحات کامل در مورد فلنج و گسکت',
      ),
      products: [
        Product(name: 'فلنج جوشی', price: 1000, features: ['فولاد', 'فشار بالا']),
        Product(name: 'گسکت اسپیرال وند', price: 500, features: ['گرافیت', 'دمای بالا']),
      ],
    ),
    'شیرآلات صنعتی': ProductCategory(
      categoryName: 'شیرآلات صنعتی',
      introduction: ProductIntroduction(
        title: 'شیرآلات صنعتی',
        imageUrl: 'assets/images/image.jpg',
        content: 'واردات و تامین انواع مختلف شیرالات صنعتی در متریال های کربـن استیل ، استنلس استیل ، فولاد های آلیاژی ( Alloy Steel ) ، چـدنی، بر اساس استاندارد متریال : ASME/API/NACE/DIN، شیر فلکه تـوپی ،شیر کشویـی ، شیر سـوزنی ، شیر یکطرفه (خـودکار) ، شیر نیدل شیر پـروانه ای ، شیر پـلاگ، ، شیر اسـتوانه ای، شیر فـشار شکن ، شیر اطمـینان ، شیر دیـافـراگمی بر اسـاس انـواع اتـصـال دو سـر : فـلـنـجـی RF/RTJ ، جـوشی ، سـاکت، دنده',
      ),
      products: [
        Product(name: 'شیر گیت ولو', price: 1500, features: ['فولاد', 'فشار بالا']),
        Product(name: 'شیر توپی', price: 1200, features: ['برنج', 'اندازه کوچک']),
      ],
    ),
    'اتصالات': ProductCategory(
      categoryName: 'اتصالات',
      introduction: ProductIntroduction(
        title: 'اتصالات',
        imageUrl: 'assets/images/image.jpg',
        content: 'توضیحات کامل در مورد اتصالات',
      ),
      products: [
        Product(name: 'اتصال جوشی', price: 800, features: ['فولاد', 'فشار بالا']),
        Product(name: 'اتصال دنده‌ای', price: 600, features: ['برنج', 'اندازه کوچک']),
      ],
    ),
    'ابزار دقیق': ProductCategory(
      categoryName: 'ابزار دقیق',
      introduction: ProductIntroduction(
        title: 'ابزار دقیق',
        imageUrl: 'assets/images/image.jpg',
        content: 'توضیحات کامل در مورد ابزار دقیق',
      ),
      products: [
        Product(name: 'ترانسمیتر فشار', price: 2000, features: ['دقت بالا', 'اندازه‌گیری فشار']),
        Product(name: 'ترموکوپل', price: 1000, features: ['دقت بالا', 'اندازه‌گیری دما']),
      ],
    ),
    'لوله و تیوب': ProductCategory(
      categoryName: 'لوله و تیوب',
      introduction: ProductIntroduction(
        title: 'لوله و تیوب',
        imageUrl: 'assets/images/image.jpg',
        content: 'توضیحات کامل در مورد لوله و تیوب',
      ),
      products: [
        Product(name: 'لوله فولادی', price: 3000, features: ['فولاد', 'فشار بالا']),
        Product(name: 'تیوب مسی', price: 2000, features: ['مس', 'اندازه کوچک']),
      ],
    ),
  };

  // Insert each category separately
  for (var entry in initialProducts.entries) {
    await productBox.put(entry.key, entry.value);
  }

  print('Initial data inserted');
} else {
  print('Box already contains data');
}

  }
  
  // Fetch functions for website data
  Future<List<Map<String, dynamic>>> getHeroItems() async {
    final box = await websiteBox;
    final items = box.get('hero_images') as List<dynamic>? ?? [];
    print('Hero items fetched: ${items.length}');
    return items.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getHeroMetadata() async {
    final box = await websiteBox;
    final metadata = box.get('hero_metadata') as Map<dynamic, dynamic>? ?? {};
    print('Hero metadata fetched');
    return metadata.cast<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> getServices() async {
    final box = await websiteBox;
    final services = box.get('services') as List<dynamic>? ?? [];
    print('Services fetched: ${services.length}');
    return services.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getAbout() async {
    final box = await websiteBox;
    final about = box.get('about') as Map<dynamic, dynamic>? ?? {};
    print('About fetched');
    return about.cast<String, dynamic>();
  }

    Future<Map<String, dynamic>> getStandard() async {
    final box = await websiteBox;
    final about = box.get('standards') as Map<dynamic, dynamic>? ?? {};
    print('Standard fetched');
    return about.cast<String, dynamic>();
  }

Future<List<Map<String, dynamic>>> getStatistics() async {
  final box = await websiteBox;
  try {
    var stats = box.get('statistics') as List<dynamic>?;

    if (stats == null || stats.isEmpty) {
      print('No statistics found, initializing default data');
      await initializeData();
      stats = box.get('statistics') as List<dynamic>?;
    }

    if (stats == null || stats.isEmpty) {
      print('No statistics available even after initialization.');
      return [];
    }

    print('Statistics fetched: ${stats.length}');

    return stats.map((item) {
      if (item is Map) {
        return Map<String, dynamic>.from(item);
      } else {
        throw TypeError();
      }
    }).toList();
  } catch (e) {
    print('Error fetching statistics: $e');
    return [];
  }
}

  // Fetch functions for products
  Future<List<String>> getCategoryNames() async {
    final box = await productsBox;
    if (box.isEmpty) {
      print('Products box is empty');
      return [];
    }
    final keys = box.keys.cast<String>().toList();
    return keys;
  }

  Future<ProductCategory?> getCategoryWithProducts(String categoryKey) async {
    final box = await productsBox;
    final category = box.get(categoryKey) as ProductCategory?;
    return category;
  }
}