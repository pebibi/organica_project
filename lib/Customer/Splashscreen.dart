import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organica_project/Customer/Onboardingpage.dart';

class Splashscreen_customer extends StatefulWidget {
  const Splashscreen_customer({super.key});

  @override
  State<Splashscreen_customer> createState() => _Splashscreen_customerState();
}

class _Splashscreen_customerState extends State<Splashscreen_customer>
    with SingleTickerProviderStateMixin {
  // add duration and animations

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) =>
            const OnboardingPage(), //DIRI LOGIN IBUTANG OR SIGN UP BASTA SUNOD NA PAGE SA SPLASH
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../lib/images/LogoO.png',
              height: 500.0,
              width: 500.0,
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }
}
