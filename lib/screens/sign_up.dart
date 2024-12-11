import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/response.dart';
import 'package:myapp/provider/signup_provider.dart';
import 'package:myapp/screens/login.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpassworcontroller =
      TextEditingController();

  saveUser(String password, String email) async {
    UserCredential userdata = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print(userdata);
  }

  SignupProvider? signupProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signupProvider = Provider.of<SignupProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    signupProvider = context.watch<SignupProvider>();
    String? message = context.watch<SignupProvider>().statusmessage;
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
              "Create Your Account",
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
                height: 600,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namecontroller,
                        maxLength: 15,
                        decoration: InputDecoration(
                            label: const Text(
                              "Name",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _emailcontroller,
                        maxLength: 25,
                        decoration: InputDecoration(
                            label: const Text(
                              "Email",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                            label: const Text(
                              "Password",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _confirmpassworcontroller,
                        decoration: InputDecoration(
                            label: const Text(
                              "Confirm Password",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            Response response = await signupProvider!
                                .userSignUp(_emailcontroller.text,
                                    _passwordcontroller.text);

                            if (response.status!) {
                              print(response.message);
                            } else {
                              if (response.message == "The password is Weak") {
                                print(
                                    "Signup failed ${response.message} tryagain");
                              } else if (response.message ==
                                  "The Account already Exits") {
                                print(
                                    "Signup Failes ${response.message} try agian");
                              }
                            }

                            // signupProvider!.signUp(_emailcontroller.text,
                            //     _passwordcontroller.text);

                            // if (signupProvider!.statusmessage ==
                            //     "Signup sucessful") {
                            //   print("signup---created user");
                            // } else {
                            //   print("user not created");
                            // }
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          )),
                      TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text(
                            "LogOut",
                            style: TextStyle(fontSize: 20),
                          ))
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
