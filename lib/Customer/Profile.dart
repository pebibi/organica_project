import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/EditProfile.dart';
import 'package:organica_project/Customer/dashboardCustomer.dart';
import 'package:organica_project/CustomerAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final CustomerAccount customerAccount;
  final Map<String, dynamic> userData;

  const Profile({
    Key? key,
    required this.customerAccount,
    required this.userData,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Stream<DocumentSnapshot> _profileStream;

  @override
  void initState() {
    super.initState();

    _profileStream = FirebaseFirestore.instance
        .collection('CustomerAccount')
        .doc(widget.customerAccount.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _profileStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User data not found'));
          }

          final customerAccount = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
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
                              builder: (context) => const DashboardCustomer(),
                            ),
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
                          '${widget.customerAccount.fname}',
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
              buildProfileDetail('Email', customerAccount['email'] ?? 'N/A',
                  Icons.email_outlined),
              const SizedBox(height: 20),
              buildProfileDetail('Phone',
                  customerAccount['phoneNumber'] ?? 'N/A', Icons.phone),
              const SizedBox(height: 20),
              buildProfileDetail('Address', customerAccount['address'] ?? 'N/A',
                  Icons.location_city),
              const SizedBox(height: 50),
              SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          customerAccount: widget.customerAccount,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.raleway(fontSize: 20),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildProfileDetail(String label, String value, IconData icon) {
    return Container(
      width: 350,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3.0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label: $value',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
