import 'package:flutter/material.dart';
import 'package:bumpie/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';


class newUser extends StatefulWidget{
  @override
  _newUserScreen createState() => _newUserScreen();
}

class _newUserScreen extends State<newUser>{
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User successfully signed up
      _showSnackBar("User signed up: ${userCredential.user?.email}");
      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showSnackBar('The account already exists for that email.');
      } else {
        _showSnackBar(e.message.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  void _showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  void Validation(){
    String fullname = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    
    if(fullname.isEmpty){
      _showSnackBar("Full name cannot be empty!");
      return;
    }

    if(password.isEmpty){
      _showSnackBar("Password cannot be empty!");
      return;
    }

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    signUpWithEmailPassword(email, password);
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.new_user,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child:Text(
              AppStrings.signUp_msg,
              style: TextStyle(
                  color:Colors.black45
              ),
              textAlign: TextAlign.center,
            ),
            ),

            Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full name",
                  labelStyle: TextStyle(
                    color: Colors.black
                  ),
                  prefixIcon: Icon(Icons.person),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
              )
            ),

            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                        color: Colors.black
                    ),
                    prefixIcon: Icon(Icons.mail),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                  ),
                )
            ),

            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        color: Colors.black
                    ),
                    prefixIcon: Icon(Icons.lock),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                  ),
                )
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: ElevatedButton(
                onPressed:(){
                  Validation();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black45,
                  ),
                ),
                child: Text(
                  AppStrings.signUp,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30),
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      " Login",
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
                      // Handle Google Sign-In
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
            ),
          ],
        )
      ),
    );
  }
}