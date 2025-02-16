import 'package:flutter/material.dart';

class launchscreen extends StatefulWidget{
  @override
  _launchscreenState createState()=> _launchscreenState();
}

class _launchscreenState extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets.papa.jpg',
          width: 400,
          height: 400,
        ),
      ),
    );
  }


}