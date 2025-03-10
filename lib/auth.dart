import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //this is for registration
Future<void> signInWithEmailPassword({
    required String email,
    required String password,
}) async{
  await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
  );
}
}
