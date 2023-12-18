import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:organica_project/Admin/SignInAdmin.dart';
import 'package:organica_project/Admin/Splashscreen_Admin.dart';
import 'package:organica_project/Admin/register.dart';
import 'package:organica_project/Customer/Splashscreen.dart';
import 'package:organica_project/ForTrials/ImageUpload.dart';
import 'package:organica_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Organica',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 22, 188, 56)),
        useMaterial3: true,
      ),
      //either splashscreen_admin or splashscreen_customer tawagon here ha kasabot pebe junami
      home: const Splashscreen_customer(),
    );
  }
}
