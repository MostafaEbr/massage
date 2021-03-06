import 'package:chatapp/screen/chat_screen.dart';
import 'package:chatapp/screen/contactchat.dart';
import 'package:chatapp/screen/homePageScreen.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'screen/addusers.dart';
import 'package:chatapp/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'screen/welcome_screen.dart';
import 'modules/contacts/contact.dart';
import 'modules/addstatus/addstatus.dart';
import 'modules/viewstorystat/viewstory.dart';
import 'modules/profile/profile.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // This widget is the root of your application.
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ViewStory.id :(context)=>ViewStory(),
        Contacts.id: (context) => Contacts(),
        HomePageScreen.id: (context) => HomePageScreen(),
        ContactChat.id: (context) => ContactChat(),
        Profile.id: (context) => Profile(),
        AddUsers.id: (context) => AddUsers(),
        AddStatus.id :(context) => AddStatus()
      },
    );
  }
}
