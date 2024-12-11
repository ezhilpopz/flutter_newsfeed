import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _status = false;
  bool get status => _status;

  String? _statusmessage;
  String? get statusmessage => _statusmessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setStatus(bool status) {
    _status = status;
  }

  void setMessage(String statusmessage) {
    _statusmessage = statusmessage;
  }

  void login(String username, password) async {
    setLoading(true);
    print(" usename $username $password");
    try {
      // FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: _emailcontroller.text,
      //     password: _passwordcontroller.text);
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      User client = result.user!;
      print(client);
      setStatus(true);
      setMessage("login sucessful");

      print("Result--$result");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setStatus(false);
        setMessage("No user found for that email");
      } else if (e.code == 'wrong-password') {
        setStatus(false);
        setMessage("Wrong password provided for that user");
        print('Wrong password provided for that user.');
      } else {
        setStatus(false);
        setMessage("login failed");
        print(e.message);
      }
    } catch (e) {
      setStatus(false);
      setMessage("Login failed");
      print(e.toString());
    }
    setLoading(false);
  }
}
