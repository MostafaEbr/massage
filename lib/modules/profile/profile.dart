import 'package:chatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../screen/login_screen.dart';
class Profile extends StatefulWidget {
  static String id = "Profile";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String url;

  String username, usernameUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:
        EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("dataUsers")
                  .snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Center(child: Text("Loading data.... , Please Wait!"));
                }
                url = snapshots.data.documents[0]['Url'];
                username = snapshots.data.documents[0]['username'];
                print(url);
                return Column(
                  children: [

                    CircleAvatar(
                      radius: 90.0,
                      child: url == null ? null : Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(90.0),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.scaleDown
                          ),
                        ),
                      )
                      ,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      "USERNAME:",
                      style: TextStyle(fontSize: 20.0, letterSpacing: 3.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      decoration: kTextDecorition.copyWith(
                          hintText: username),
                      onChanged: (value) {
                        usernameUpdate = value;
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      "PHONE:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20.0, letterSpacing: 3.0),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Center(
                        child: Text(
                          snapshots.data.documents[0]['phone'],
                          style: TextStyle(fontSize: 20.0),
                        )),
                    SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: null,
                          child: Text(
                            "update",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        RaisedButton(
                          onPressed: (){
                            FirebaseAuth _auth = FirebaseAuth.instance;
                          var signout =   _auth.signOut();
                          signout.whenComplete(() => Navigator.pushNamed(context,LoginScreen.id));
                          },
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
