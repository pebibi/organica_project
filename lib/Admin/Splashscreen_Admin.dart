import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organica_project/authenticator.dart';

class Splashscreen_admin extends StatefulWidget {
  const Splashscreen_admin({super.key});

  @override
  State<Splashscreen_admin> createState() => _Splashscreen_adminState();
}

class _Splashscreen_adminState extends State<Splashscreen_admin>
    with SingleTickerProviderStateMixin {
  // add duration and animations

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) =>
            const Authenticator(), //DIRI LOGIN IBUTANG OR SIGN UP BASTA SUNOD NA PAGE SA SPLASH
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
