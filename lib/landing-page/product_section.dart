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

class ProductSectionState extends State<ProductSection>
    with AutomaticKeepAliveClientMixin<ProductSection> {
  @override
  bool get wantKeepAlive => true;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  List<String> _categories = [];
  List<ProductCategory?> _categoryData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllCategories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadAllCategories() async {
    setState(() => _isLoading = true);

    try {
      final fetchedCategories = await _dbHelper.getCategoryNames();
      if (fetchedCategories.isNotEmpty) {
        final futures = fetchedCategories
            .map((category) => _dbHelper.getCategoryWithProducts(category))
            .toList();

        final results = await Future.wait(futures);

        setState(() {
          _categories = fetchedCategories;
          _categoryData = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        _buildPortraitTab(),
    ]);
  }

  Widget _buildLargeScreen() {
    return Row(
      children: [
        _buildLanscapeCategoryList(),
        const SizedBox(width: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width - 270,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _categories.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildLandscapeContent(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanscapeCategoryList() {
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
                      onPressed: () {
                        _selectedIndex = index;
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn);
                      },
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

Widget _buildPortraitTab() {
  final colorScheme = Theme.of(context).colorScheme;
  const selectedColor = Color.fromRGBO(204, 26, 68, 1);

  return DefaultTabController(
    length: _categories.length,
    initialIndex: _selectedIndex,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TabBar for category navigation
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TabBar(
            isScrollable: true,
            indicatorColor: selectedColor,
            labelColor: selectedColor,
            unselectedLabelColor: colorScheme.onPrimary,
            dividerColor: Colors.transparent,
            tabs: _categories
                .map((category) => Tab(text: category))
                .toList(),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                );
              });
            },
          ),
        ),
        // TabBarView for content corresponding to each tab
          SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: TabBarView(
            children: List.generate(
              _categories.length,
              (index) => _buildVerticalContent(index),
            ),
          ),
        ),
      ],
    ),
  );
}


  // Build content for landscape mode
  Widget _buildLandscapeContent(BuildContext context, int index) {
    if (index < 0 ||
        index >= _categoryData.length ||
        _categoryData[index] == null) {
      return const Center(child: Text('داده‌ای موجود نیست'));
    }
    final category = _categoryData[index]!;
    final size = MediaQuery.of(context).size.height * 0.6;
    final catTitle = category.introduction.title;
    final catContent = category.introduction.content;
    final catImage = category.introduction.imageUrl;

    return Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 10),
                  AnimatedBorderContainer.primaryButton(
                      size: const Size(200, 42),
                      radius: 18,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              iconColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("مشاهده بیشتر"),
                              SizedBox(width: 4),
                              Icon(EneftyIcons.arrow_left_3_outline, size: 18)
                            ],
                          )))
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildVerticalContent(int index) {
    if (index < 0 ||
        index >= _categoryData.length ||
        _categoryData[index] == null) {
      return const Center(child: Text('داده‌ای موجود نیست'));
    }

    final category = _categoryData[index]!;
    final size = MediaQuery.of(context).size.height * 0.6;
    final catTitle = category.introduction.title;
    final catContent = category.introduction.content;
    final catImage = category.introduction.imageUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      children: [
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
        ),
        const SizedBox(height: 20,),
        AnimatedBorderContainer.primaryButton(
                      size: Size(MediaQuery.of(context).size.width * 0.8, 42),
                      radius: 18,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              iconColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("مشاهده بیشتر"),
                              SizedBox(width: 4),
                              Icon(EneftyIcons.arrow_left_3_outline, size: 18)
                            ],
                          )))
      ],
    )
    );
  }
}
