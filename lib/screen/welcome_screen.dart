import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatapp/screen/homePageScreen.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:chatapp/components/roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_Screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin
{

  Animation animation;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController controller;


  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(controller);


    _auth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(HomePageScreen.id, (route) => false);
      } else {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Center(
                  child: TypewriterAnimatedTextKit(
                    text: [" Welcome "],
                    textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            roundedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              fieldName: "Let's go",
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

