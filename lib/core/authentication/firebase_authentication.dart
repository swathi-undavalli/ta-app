import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> logout() async {
    await auth.signOut();
  }

  static String? userId() {
    return auth.currentUser?.uid;
  }

  static isUserLoggedIn() {
    return auth.currentUser != null;
  }
}
