import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: const [
              OnboardingContent(
                title: 'Welcome to Organica!',
                description:
                    'Discover the farm-fresh revolution that brings you the freshest organic produce right to your fingertips.',
                imagePath: '../assets/images/first.png',
              ),
              OnboardingContent(
                title: 'Experience Freshness',
                description:
                    'Organica connects you to the bounty of local farmers. Browse through our selection of fresh, organic products, supporting farmers with every purchase.',
                imagePath: '../assets/images/second.png',
              ),
            ],
          ),
          Positioned(
            bottom: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          Positioned(
            bottom: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 350,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle action for Register button
                    },
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 350,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle action for Register button
                    },
                    child: Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 2; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 10.0,
      width: isActive ? 20.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Image.asset(
          imagePath,
          width: 600,
          height: 500,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 10),
        Text(title,
            style:
                GoogleFonts.raleway(fontSize: 32, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(description,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(fontSize: 16)),
        ),
      ],
    );
  }
}
