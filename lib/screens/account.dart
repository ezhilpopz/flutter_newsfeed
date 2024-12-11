import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // String? user = FirebaseAuth.instance.currentUser!.displayName;

    return Scaffold(
      body: Stack(children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.orangeAccent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 180),
          child: SingleChildScrollView(
            child: Container(
              height: 600,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                        title: Text("user.toString()"),
                        subtitle: Text("Lorem ipsum"),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.star_rate_outlined,
                          size: 40,
                        ),
                        title: Text("Rate us"),
                        subtitle: Text("Lorem ipsum"),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          size: 40,
                        ),
                        title: Text("About us"),
                        subtitle: Text("Lorem ipsum"),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 15),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.privacy_tip_outlined,
                          size: 40,
                        ),
                        title: Text("Privacy Policy"),
                        subtitle: Text("Lorem ipsum"),
                      ),
                    ),
                  ),
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      signOutFromGoogle();
                      // Navigator.pop(context);
                      // Navigator.popAndPushNamed(context, '/login');
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
