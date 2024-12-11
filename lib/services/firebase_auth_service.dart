import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/response.dart';

class FirebaseAuthService {
  Future<Response> signUp(String email, String password) async {
    String? message;
    Response response;
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      response = Response(status: true, message: 'signup Sucess');
      return response;
      print("Signup Sucessfull");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password is Weak';
        print('The password is weak');
      } else if (e.code == 'email-already-in-use') {
        message = 'The Account already Exits';
        print('the account already exits ');
      }
    } catch (e) {
      print(e);
      message = e.toString();
    }
    response = Response(status: false, message: message);
    return response;
  }
}
