import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/RegisterCustomer.dart';

class SignIn_admin extends StatefulWidget {
  const SignIn_admin({Key? key}) : super(key: key);

  @override
  State<SignIn_admin> createState() => _SignIn_adminState();
}

class _SignIn_adminState extends State<SignIn_admin> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late String errormessage;
  late bool isError;
  bool wrongPassword = false;
  bool passToggle = true;

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../lib/images/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 10, right: 50),
                child: Text(
                  'Welcome Back!',
                  style: GoogleFonts.raleway(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Text(
                  'Please Sign In to your Admin Account',
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 400),
              Container(
                width: 350,
                child: TextFormField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.person),
                    labelStyle: GoogleFonts.raleway(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                child: TextFormField(
                  controller: passwordcontroller,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                    labelStyle: GoogleFonts.raleway(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (wrongPassword)
                Text(
                  'Wrong password. Please try again.',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    SizedBox(
                      width: 350,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (passwordcontroller.text != 'correct_password') {
                            setState(() {
                              wrongPassword = true;
                              checkLogin(
                                usernamecontroller.text,
                                passwordcontroller.text,
                              );
                            });
                          } else {
                            setState(() {
                              wrongPassword = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 2, 68, 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.raleway(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Future checkLogin(username, password) async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      setState(() {
        errormessage = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      errormessage = e.message.toString();
    }
    Navigator.pop(context);
  }
}
