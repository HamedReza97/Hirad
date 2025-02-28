import 'package:flutter/material.dart';
import 'package:hirad/database/helper.dart';
import 'package:hirad/models/product_model.dart';
import 'package:hirad/utils/animated_container.dart';
import 'package:hirad/utils/enefty_icons.dart';

class ProductSection extends StatefulWidget {
  const ProductSection({super.key});

  @override
  ProductSectionState createState() => ProductSectionState();
}

class ProductSectionState extends State<ProductSection> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  int _selectedIndex = 0;
  List<String> _categories = [];
  ProductCategory? _currentCategory;
  bool _isLoading = true;
  bool _isCategoryLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await _dbHelper.getCategoryNames();
      if (fetchedCategories.isNotEmpty) {
        setState(() {
          _categories = fetchedCategories;
        });
        await _loadCategoryData(_selectedIndex);
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCategoryData(int index) async {
    if (index >= _categories.length) return;

    setState(() => _isCategoryLoading = true);
    try {
      final category =
          await _dbHelper.getCategoryWithProducts(_categories[index]);
      if (category != null && mounted) {
        setState(() {
          _currentCategory = category;
          _selectedIndex = index;
        });
      }
    } catch (e) {
      debugPrint('Error loading category data: $e');
    } finally {
      if (mounted) {
        setState(() => _isCategoryLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isLandscape =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height >
            1.4;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: isLandscape ? _buildLargeScreen() : _buildSmallScreen());
  }

  Widget _buildSmallScreen() {
    return Column(
      children: [
        // _buildCategoryList(),
        if (_isCategoryLoading)
          const Center(child: CircularProgressIndicator())
        else
          ..._buildProductContent(
              false), 
      ],
    );
  }

  Widget _buildLargeScreen() {
    return Row(
      children: [
        _buildCategoryList(),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _isCategoryLoading
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _buildProductContent(true);
                },

              ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    final colorScheme = Theme.of(context).colorScheme;
    const selectedColor = Color.fromRGBO(204, 26, 68, 1);

    return Container(
      padding: const EdgeInsets.only(right: 50),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_categories.length, (index) {
          final isSelected = _selectedIndex == index;
          final isLastItem = index == _categories.length - 1;

          return Stack(
            children: [
              // Vertical line
              if (!isLastItem)
                Positioned(
                  top: index == 0 ? 12 : 0,
                  right: 6,
                  child: Container(
                    width: 1,
                    height: 72,
                    color: colorScheme.onPrimary,
                  ),
                )
              else
                Positioned(
                  top: 0,
                  right: 6,
                  child: Container(
                    width: 1,
                    height: 12,
                    color: colorScheme.onPrimary,
                  ),
                ),

              // Category item
              SizedBox(
                height: 58,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSelected) const SizedBox(width: 3),
                    Padding(
                      padding: EdgeInsets.only(top: isSelected ? 10 : 12),
                      child: Container(
                        width: isSelected ? 14 : 8,
                        height: isSelected ? 14 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? selectedColor
                              : colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _loadCategoryData(index),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: isSelected
                              ? selectedColor
                              : colorScheme.onPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  _buildProductContent(bool isLandscape) {
    if (_currentCategory == null) {
      return [const Center(child: Text('داده‌ای موجود نیست'))];
    }

    final size = MediaQuery.of(context).size.height * 0.6;
    final catTitle = _currentCategory?.introduction.title ?? "";
    final catContent = _currentCategory?.introduction.content ?? "";
    final catImage = _currentCategory?.introduction.imageUrl ?? "";

    if (isLandscape) {
      // For landscape orientation - return a single Row
      return Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            catImage,
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  catContent,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                AnimatedBorderContainer.primaryButton(
                  size: const Size(200, 42),
                  radius: 18,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary
                    ),
                    onPressed: (){
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                    Text("مشاهده بیشتر"),
                    Icon(EneftyIcons.arrow_left_3_outline, size: 18)
                  ],)
                  )
                )
              ],
            ),
          )
        ],
        )
      );
    } else {
      // For portrait orientation - return a list of widgets for the Column
      return [
        Image.asset(
          catImage,
          height: size / 1.5,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        Text(
          catTitle,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          catContent,
          textAlign: TextAlign.justify,
        )
      ];
    }
  }
}
