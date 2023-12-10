import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/SignIn.dart';
import 'package:organica_project/CustomerAccount.dart';
import 'package:organica_project/authenticatorCustomer.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  late String errormessage;
  late bool isError;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/images/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 100, left: 5, right: 220),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.raleway(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 100),
                  child: Text(
                    'Go Green, Live Green',
                    style: GoogleFonts.raleway(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 300),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: fnameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Icons.person),
                                labelStyle: GoogleFonts.raleway(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: lnameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(Icons.person),
                                labelStyle: GoogleFonts.raleway(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          labelStyle: GoogleFonts.raleway(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          labelStyle: GoogleFonts.raleway(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          labelStyle: GoogleFonts.raleway(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Form is valid, proceed with user registration
                                registerUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text('Register'),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.raleway(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()),
                              );
                            },
                            child: Text("Sign In"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // call the current user submethod to get the currently registered user
  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    final docUser =
        FirebaseFirestore.instance.collection('CustomerAccount').doc(userid);

    final customerAccount = CustomerAccount(
      id: userid,
      fname: fnameController.text,
      lname: lnameController.text,
      email: emailController.text,
    );
    final json = customerAccount.toJson();
    await docUser.set(json);

    goToAuthenticator() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AuthenticatorCustomer(),
        ),
      );
    }
  }

  // register the user
  Future registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      createUser();
      setState(() {
        errormessage = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        errormessage = e.message.toString();
      });
    }
  }

  goToAuthenticator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AuthenticatorCustomer(),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Password Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SignUp(),
        ),
      ),
    ));
  }
}
