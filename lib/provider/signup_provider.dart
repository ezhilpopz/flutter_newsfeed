import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/response.dart';
import 'package:myapp/services/firebase_auth_service.dart';

class SignupProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  String? _statusmessage;
  String? get statusmessage => _statusmessage;

  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setMessage(String statusmessage) {
    _statusmessage = statusmessage;
  }

  Future<Response> userSignUp(String email, String password) async {
    Response response;
    setLoading(true);
    response = await firebaseAuthService.signUp(email, password);
    setLoading(false);
    return response;
  }

  void signUp(String email, password) async {
    setLoading(true);

    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("Signup Sucessfull");

      setMessage("Signup Sucessful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password is weak');
        setMessage("The password is weak");
      } else if (e.code == 'email-already-in-use') {
        print('the account already exits ');
        setMessage("the account already exits");
      }
    } catch (e) {
      print(e);
      setMessage("signup failed");
    }
    setLoading(false);
  }
}
