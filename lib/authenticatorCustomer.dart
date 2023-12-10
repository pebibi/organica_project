import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organica_project/Customer/Onboardingpage.dart';
import 'package:organica_project/Customer/Splashscreen.dart';

class AuthenticatorCustomer extends StatefulWidget {
  const AuthenticatorCustomer({super.key});

  @override
  State<AuthenticatorCustomer> createState() => _AuthenticatorCustomerState();
}

class _AuthenticatorCustomerState extends State<AuthenticatorCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong!'),
            );
          } else if (snapshot.hasData) {
            return OnboardingPage();
          } else {
            return const Splashscreen_customer();
          }
        },
      ),
    );
  }
}
