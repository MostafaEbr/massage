import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/constants.dart';
import 'contactchat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUsers extends StatefulWidget {
  static const String id = "AddUsers";

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  String uses;

  String phone;

  var userControl = TextEditingController();
  var phoneControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
              margin: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: userControl,
                    onChanged: (va) {
                      uses = va;
                    },
                    decoration: kTextDecorition.copyWith(hintText: "Username"),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    controller: phoneControl,
                    onChanged: (cal) {
                      phone = cal;
                    },
                    decoration: kTextDecorition.copyWith(hintText: "phone"),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            if (uses.isEmpty || phone.isEmpty) {
                            } else {
                              await addUser(context, uses, phone);
                              userControl.clear();
                              phoneControl.clear();
                            }
                          },
                          child: Text("add"),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

Future addUser(BuildContext context, String uses, String phone) async {
  FirebaseFirestore _fire = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  var userid = _auth.currentUser.uid;

  SharedPreferences _pref = await SharedPreferences.getInstance();
  String currentphone = _pref.getString("phoneUser");
  // print("current photo : " + $currentphone);

  _fire.collection("dataUsers").where("phone",isEqualTo:phone).get().then((value) {

    var uid= value.docs[0]["uId"];

    _fire.collection('dataUsers')
        .doc(userid)
        .collection("users")
        .doc(uid)
        .set({
      "username": uses,
      "phone_client": phone,
      "currentPhone": currentphone,
      "id":uid,
      "time": "4:00",
      "lastMassage": "Done"
    }).whenComplete(() => () {
      Navigator.pop(context);
    });
  });
}

