import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static final PageController _controller = PageController(keepPage: true);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                child: _featureImage(),
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
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
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
                        spacing: 15,
                        children: [
                          Text(
                            '6',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.blueGrey,
                    ),
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    prefixIconColor: Colors.blueGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 3,
                      ),
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
                        itemCount: advertImages.length,
                        itemBuilder: (context, index) {
                          final ad = advertImages[index];
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
}
