import 'package:hive/hive.dart';

part 'product_model.g.dart'; 

@HiveType(typeId: 0)
class ProductCategory {
  @HiveField(0)
  final String categoryName;

  @HiveField(1)
  final ProductIntroduction introduction;

  @HiveField(2)
  final List<Product> products;

  ProductCategory({
    required this.categoryName,
    required this.introduction,
    required this.products,
  });
}

@HiveType(typeId: 1)
class ProductIntroduction {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String content;

  ProductIntroduction({
    required this.title,
    required this.imageUrl,
    required this.content,
  });
}

@HiveType(typeId: 2)
class Product {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  @HiveField(2)
  final List<String> features;

  Product({
    required this.name,
    required this.price,
    required this.features,
  });
}
