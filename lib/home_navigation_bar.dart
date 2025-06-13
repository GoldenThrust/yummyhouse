import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBar extends StatelessWidget {
  static final tabs = [
    {
      'icon': Icons.home_outlined,
      'selectedIcon': Icons.home_filled,
      'label': '',
      'location': '/',
    },
    {
      'icon': Icons.map_outlined,
      'selectedIcon': Icons.map,
      'label': '',
      'location': '/ongoing-delivery',
    },
    {
      'icon': Icons.shopping_cart_outlined,
      'selectedIcon': Icons.shopping_cart_checkout_rounded,
      'label': '',
      'location': '/cart',
    },
    {
      'icon': Icons.favorite_outline,
      'selectedIcon': Icons.favorite,
      'label': '',
      'location': '/favorite',
    },
    {
      'icon': Icons.person_outline,
      'selectedIcon': Icons.person,
      'label': '',
      'location': '/profile',
    },
  ];

  final Widget child;
  final String location;

  const HomeNavigationBar({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        height: 60,
        animationDuration: Duration(milliseconds: 500),
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        onDestinationSelected:
            (index) => context.go(tabs[index]['location']! as String),
        destinations:
            tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isCart = index == 2;
              final isProfile = index == tabs.length - 1;

              return NavigationDestination(
                tooltip: 'Home',
                enabled: !isProfile,
                selectedIcon: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isCart ? Colors.deepOrangeAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child:
                      isProfile
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/images/register_bg.jpg",
                              cacheWidth: 50,
                              gaplessPlayback: true,
                            ),
                          )
                          : Icon(
                            tab['selectedIcon'] as IconData,
                            color: isCart ? Colors.white : Colors.orange,
                          ),
                ),
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isCart ? Colors.deepOrangeAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child:
                      isProfile
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/images/profile.jpg",
                              cacheWidth: 50,
                            ),
                          )
                          : Icon(
                            tab['icon'] as IconData,
                            color: isCart ? Colors.white : Colors.orange,
                          ),
                ),
                label: tab['label'] as String,
              );
            }).toList(),
      ),
    );
  }

  _locationToIndex(String location) {
    final index = tabs.indexWhere((tab) => location == tab['location']);
    return index != -1 ? index : 0;
  }
}
