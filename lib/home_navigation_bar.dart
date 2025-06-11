import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBar extends StatefulWidget {
  final Widget child;

  const HomeNavigationBar({super.key, required this.child});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.deepOrange,
        iconSize: 25,
        selectedIconTheme: IconThemeData(size: 35),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_sharp),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.favorite_border_outlined),
          //   label: '',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.),
          //   label: '',
          // ),
        ],
        currentIndex: pageIndex, // Update this based on the current route
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/profile');
          } else if (index == 2) {
            context.go('/ongoing-delivery');
          } else if (index == 3) {
            context.go('/favourites');
          } else if (index == 4) {
            context.go('/settings');
          }
        },
      ),
    );
  }
}
