import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State createState() => _State();
}

class _State extends State{

  @override
  Widget build(context) {

    Future.delayed(
        const Duration(seconds: 3),
        (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false
            );
        }
    );

    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.jpg",
          height: 250,
          width: 250,
        ),
      )
    );
  }

}