import 'package:chatapp/components/roundedbutton.dart';
import 'package:chatapp/constants.dart';
import 'package:chatapp/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistertionScreen extends StatefulWidget {
  static const String id = 'registertionScreen';

  @override
  _RegistertionScreenState createState() => _RegistertionScreenState();
}

class _RegistertionScreenState extends State<RegistertionScreen> {
  final _auth =FirebaseAuth.instance;
  String email;
  String password;
  bool  showSpinner = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress ,
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration:
                        kTextDecorition.copyWith(hintText: "Enter Your E-Mail")),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                    },
                    decoration:
                        kTextDecorition.copyWith(hintText: "Enter Your Password ")),
                SizedBox(
                  height: 24.0,
                ),
                roundedButton(
                    color: Colors.blueAccent,
                    onPressed: () async{
//                    print(email);
//                    print(password);
                    setState(() {
                      showSpinner = true ;
                    });
                    try {
                      final newUser =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password) ;

                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    }catch(e)
                      {
                        print(e);
                      }
                    setState(() {
                      showSpinner = false ;
                    });
                    },
                    fieldName: "Register")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
