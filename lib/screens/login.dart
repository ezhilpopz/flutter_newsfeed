import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/provider/login_provider.dart';

import 'package:myapp/screens/news_feed.dart';
// ignore: unused_import
import 'package:myapp/screens/sign_up.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googoogleSigninAuthentication =
        await googleSignInAccount!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googoogleSigninAuthentication.accessToken,
        idToken: googoogleSigninAuthentication.idToken);

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(" User Details:${userCredential.user!.displayName}");

    Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  LoginProvider? loginprovider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginprovider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontrol = TextEditingController();
    TextEditingController passwordcontrol = TextEditingController();
    String userid = "ezhil@gmail.com";
    String password = "arasan123";

    loginprovider = context.watch<LoginProvider>();

    bool? status = context.watch<LoginProvider>().status;
    String? message = context.watch<LoginProvider>().statusmessage;
    print("status: $status");
    print("message status $message");

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 10, 6, 6),
            Color.fromARGB(255, 168, 25, 25)
          ])),
          height: double.infinity,
          width: double.infinity,
          child: const Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 180),
            child: Center(
              child: Container(
                height: 700,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.only(right: 25, left: 25, top: 80),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailcontrol,
                        decoration: InputDecoration(
                            label: const Text(
                              "Email",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordcontrol,
                        decoration: InputDecoration(
                            label: const Text(
                              "Password",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            loginprovider!
                                .login(emailcontrol.text, passwordcontrol.text);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));

                            // if (userid == emailcontrol) {
                            //   if (password == passwordcontrol) {
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //         builder: (context) => const NewsFeed()));
                            //   } else {
                            //     print("Enter Correct Dta");
                            //   }
                            // }
                            // try {
                            //   // FirebaseAuth.instance.signInWithEmailAndPassword(
                            //   //     email: _emailcontroller.text,
                            //   //     password: _passwordcontroller.text);
                            //   UserCredential result = await FirebaseAuth
                            //       .instance
                            //       .signInWithEmailAndPassword(
                            //           email: emailcontrol.text,
                            //           password: passwordcontrol.text);
                            //   User client = result.user!;
                            //   print(client);

                            //   print("Result--$result");
                            // } on FirebaseAuthException catch (e) {
                            //   if (e.code == 'user-not-found') {
                            //     print('No user found for that email.');
                            //   } else if (e.code == 'wrong-password') {
                            //     print('Wrong password provided for that user.');
                            //   } else {
                            //     print(e.message);
                            //   }
                            // } catch (e) {
                            //   print(e.toString());
                            // }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            signInWithGoogle();
                          },
                          child: const Text("Google Login")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
