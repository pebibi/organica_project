import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/dashboardCustomer.dart';

class Profile extends StatefulWidget {
  final String userName;
  final String email;
  final String mobileNumber;
  final String password;

  const Profile({
    Key? key,
    required this.userName,
    required this.email,
    required this.mobileNumber,
    required this.password,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 500,
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()),
                      );
                    },
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      //widget.userName,
                      'Jhonna',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 400,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 3.0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Email: ${widget.email}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 400,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 3.0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.phone_android_outlined,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Phone: ${widget.mobileNumber}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 400,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 3.0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Password: ${widget.password}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 300,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                // Add ylog out functionality here
                // dapat mubalik sa onboarding page or sa login
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                'Log Out',
                style: GoogleFonts.raleway(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
