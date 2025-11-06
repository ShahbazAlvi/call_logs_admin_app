import 'package:flutter/material.dart';
import 'package:infinity/View/splashScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "image": "assets/images/splash1.png",
      "title": "",
      "subtitle": "",
      "showButton": false,
    },
    {
      "image": "assets/images/splash2.png",
      "title": "Find Products You Love",
      "subtitle":
      "Discover top-quality products from trusted suppliers — all in one place.\nExperience seamless distribution with fast delivery, reliable partners, and the best deals on every order.",
      "showButton": false,
    },
    {
      "image": "assets/images/splash3.png",
      "title": "Welcome to QuickBit",
      "subtitle":
      "Elevate your shopping experience — where ordinary purchases become extraordinary finds! Discover premium products, seamless ordering, and lightning-fast delivery for next level convenience.",
      "showButton": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return buildPage(
                  image: pages[index]["image"],
                  title: pages[index]["title"],
                  subtitle: pages[index]["subtitle"],
                  showButton: pages[index]["showButton"],
                );
              },
            ),
          ),

          // ✅ Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: currentIndex == index ? 12 : 8,
                height: currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String subtitle,
    required bool showButton,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          fit: BoxFit.contain,
        ),


        const SizedBox(height: 30),

        // ✅ Title
        if (title.isNotEmpty)
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        const SizedBox(height: 10),

        // ✅ Subtitle
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),

        const SizedBox(height: 30),

        // ✅ "Get Started" Button
        if (showButton)
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Splashscreen()));
            },
            style: ElevatedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Get Started",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
