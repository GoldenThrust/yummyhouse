import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/authentication/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static List<Map<String, String>> advertImages = [
    {
      'image': 'assets/images/ad_1.jpg',
      'header': '20% off',
      'sub_heading': 'Order now and save',
    },
    {
      'image': 'assets/images/ad_2.jpg',
      'header': 'Free Delivery',
      'sub_heading': 'On orders above \$25',
    },
    {
      'image': 'assets/images/ad_3.jpg',
      'header': 'New Menu',
      'sub_heading': 'Try our seasonal specials',
    },
    {
      'image': 'assets/images/ad_4.jpg',
      'header': 'Happy Hour',
      'sub_heading': '2 for 1 on all drinks',
    },
    {
      'image': 'assets/images/ad_5.jpg',
      'header': 'Weekend Deal',
      'sub_heading': '30% off family meals',
    },
    {
      'image': 'assets/images/ad_6.jpg',
      'header': 'Loyalty Rewards',
      'sub_heading': 'Earn points with every order',
    },
    {
      'image': 'assets/images/ad_7.jpg',
      'header': 'Chef\'s Special',
      'sub_heading': 'Limited time offering',
    },
    {
      'image': 'assets/images/ad_8.jpg',
      'header': 'Dessert Combo',
      'sub_heading': 'Add a dessert for \$2',
    },
  ];

  static final categories = [
    {
      'label': 'Vegetables',
      'icon': Icons.local_florist,
      'selectedIcon': Icons.local_florist_outlined,
      'quantity': 15,
    },
    {
      'label': 'Drinks',
      'icon': Icons.local_drink,
      'selectedIcon': Icons.local_drink_outlined,
      'quantity': 25,
    },
    {
      'label': 'Snacks',
      'icon': Icons.fastfood,
      'selectedIcon': Icons.fastfood_outlined,
      'quantity': 40,
    },
    {
      'label': 'Desserts',
      'icon': Icons.cake,
      'selectedIcon': Icons.cake_outlined,
      'quantity': 10,
    },
    {
      'label': 'Ice Cream',
      'icon': Icons.icecream,
      'selectedIcon': Icons.icecream_outlined,
      'quantity': 5,
    },
    {
      'label': 'Beverages',
      'icon': Icons.local_bar,
      'selectedIcon': Icons.local_bar_outlined,
      'quantity': 18,
    },
    {
      'label': 'Pizza',
      'icon': Icons.local_pizza,
      'selectedIcon': Icons.local_pizza_outlined,
      'quantity': 20,
    },
    {
      'label': 'Fast Food',
      'icon': Icons.fastfood,
      'selectedIcon': Icons.fastfood_outlined,
      'quantity': 49,
    },
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _controller;
  Timer? _timer;
  int _currentPage = 0;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _controller = PageController(keepPage: true);
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < HomePage.advertImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Yummy House'),
        //   centerTitle: true,
        //   backgroundColor: Colors.deepOrange,
        //   //logout button
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.logout),
        //       onPressed: () {
        //         context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
        //         context.go('/login');
        //       },
        //     ),
        //   ],
        // ),
        body: Column(
          children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _featureImage(),
                    SizedBox(height: 20),
                    _categoryList(),
                    SizedBox(height: 15),
                    _productList(
                      'features'
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning'),
                  Text(
                    'Olajide A. 👋',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '6',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Search Box
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Search beverages or foods',
              prefixIcon: Icon(Icons.search, size: 30, color: Colors.blueGrey),
              hintStyle: TextStyle(color: Colors.blueGrey),
              prefixIconColor: Colors.blueGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _featureImage() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: HomePage.advertImages.length,
            itemBuilder: (context, index) {
              final ad = HomePage.advertImages[index];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: double.infinity,
                  key: ValueKey(ad['image']),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          ad['image']!,
                          fit: BoxFit.cover,
                          cacheWidth: 800,
                          gaplessPlayback: true,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ad['header']!,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ad['sub_heading']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _categoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 15),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: HomePage.categories.length,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final category = HomePage.categories[index];
              final categoryLabel = category['label'] as String;
              final isSelected = _selectedCategory == categoryLabel;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = categoryLabel;
                    });
                    _onCategorySelected(category);
                  },
                  child: Container(
                    key: ValueKey(categoryLabel),
                    width: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.deepOrange : Colors.black,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected ? Colors.deepOrange.withAlpha(1) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected
                              ? (category['selectedIcon'] ?? category['icon'])
                                  as IconData
                              : category['icon'] as IconData,
                          size: 25,
                          color: isSelected ? Colors.deepOrange : null,
                        ),
                        SizedBox(height: 5),
                        Text(
                          categoryLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.deepOrange : null,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${category['quantity']} items',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? Colors.deepOrange.shade700
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _productList(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            type.toUpperCase()
            ,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 15),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: HomePage.categories.length,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final category = HomePage.categories[index];
              final categoryLabel = category['label'] as String;
              final isSelected = _selectedCategory == categoryLabel;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = categoryLabel;
                    });
                    _onCategorySelected(category);
                  },
                  child: Container(
                    key: ValueKey(categoryLabel),
                    width: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.deepOrange : Colors.black,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected ? Colors.deepOrange.withAlpha(1) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected
                              ? (category['selectedIcon'] ?? category['icon'])
                                  as IconData
                              : category['icon'] as IconData,
                          size: 25,
                          color: isSelected ? Colors.deepOrange : null,
                        ),
                        SizedBox(height: 5),
                        Text(
                          categoryLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.deepOrange : null,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${category['quantity']} items',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? Colors.deepOrange.shade700
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onCategorySelected(Map<String, dynamic> category) {
    print(
      'Category selected: ${category['label']} with ${category['quantity']} items',
    );
  }
}
