import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  final PageController _controller = PageController(keepPage: true);
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/geting_started_3.jpg",
      "title": "Best Quality Food at your doorstep!",
      "subtitle":
          "We source only the freshest ingredients to create delicious meals for you.",
    },
    {
      "image": "assets/images/geting_started_2.jpg",
      "title": "Fast Delivery\nAnywhere!",
      "subtitle": "Get your order delivered quickly with our express service.",
    },
    {
      "image": "assets/images/geting_started_4.jpg",
      "title": "Tasty Meals\nEveryday!",
      "subtitle": "Enjoy freshly made meals delivered to your door.",
    },
    {
      "image": "assets/images/geting_started.jpg",
      "title": "Order Tracking\nIn Real Time!",
      "subtitle":
          "Track your food from the kitchen to your doorstep with live updates.",
    },
  ];

  @override
  void initState() {
    super.initState();

    // Precache all onboarding images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var data in onboardingData) {
        precacheImage(AssetImage(data['image']!), context);
      }
    });

    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < onboardingData.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _controller.jumpToPage(0);
      }
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset(
                            onboardingData[index]['image']!,
                            key: ValueKey(onboardingData[index]['image']),
                            fit: BoxFit.cover,
                            cacheHeight: 450,
                            cacheWidth: 450,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          onboardingData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _controller,
              count: onboardingData.length,
              effect: const ScrollingDotsEffect(
                activeDotColor: Colors.deepOrangeAccent,
                dotColor: Colors.grey,
                dotHeight: 5,
                dotWidth: 5,
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: DefaultButton(onPressed: () {
                  context.go('/register');
                }, text: 'GET STARTED'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
