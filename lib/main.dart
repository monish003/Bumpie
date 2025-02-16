import 'package:bumpie/strings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bumpie/dashboard.dart';
import 'package:bumpie/newUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordvisible = false;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );
      print('Login successful: ${userCredential.user?.email}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>dashboard()));
    } on FirebaseAuthException catch (e) {
      _showSnackBar('Login failed: ${e.message}');
      passwordController.clear();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.message ?? 'Login failed'),
      // ));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar('Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('No user found for that email.');
      } else {
        _showSnackBar(e.message ?? 'Failed to send password reset email.');
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  void _validateAndSendResetEmail() {
    String email = userNameController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }
    sendPasswordResetEmail(email);
  }

  void navigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> newUser()));
  }

  void _showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Welcome to Bumpie!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: 26.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "We take care your toddy",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: TextField(
                controller: userNameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                controller: passwordController,
                style: TextStyle(color: Colors.black),
              obscureText: !passwordvisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        passwordvisible?Icons.visibility:Icons.visibility_off
                    ),
                    onPressed: (){
                      setState(() {
                        passwordvisible=!passwordvisible;
                      });
                    },
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _validateAndSendResetEmail();
                },
                child: Text(
                  "Forgot password?",
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
              child: ElevatedButton(
               // onPressed: _login,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>dashboard()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black45,
                  ),
                ),
                child: Text(
                  AppStrings.login,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black45),
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateToSignUp();
                    },
                    child: Text(
                      " Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Text(
                AppStrings.signInWIth,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Image.asset(
                      'assets/google.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle Instagram Sign-In
                    },
                    child: Image.asset(
                      'assets/instagram.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle Facebook Sign-In
                    },
                    child: Image.asset(
                      'assets/facebook.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
