import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp/components/roundedbutton.dart';
import 'package:chatapp/constants.dart';
import 'homePageScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _controllertext = TextEditingController();

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _phone;
  String username;
  String urlImage;
  bool isCamera;
  File _image;
  bool showSpinner = false;
  String password;

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

   sharedSave(String phone) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setString("phoneUser", phone);
  }

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber,
      String isoCode) async {
    setState(() {
      _phone = internationalizedPhoneNumber;
      sharedSave(_phone);
      print(_phone);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 24.0
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: ((context) => bottomSheet()
                          ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          _image == null ? null : FileImage(_image),
                      radius: 70,
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: kTextDecorition.copyWith(
                        hintText: ' Username : ', alignLabelWithHint: true,labelText: "Username "),
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  InternationalPhoneInput(
                    decoration: kTextDecorition.copyWith(
                        hintText: "Enter phone Number :",labelText: "Phone Number "),
                    onPhoneNumberChange: onPhoneNumberChange,
                    initialPhoneNumber: _phone,
                    initialSelection: 'EG',
                    showCountryCodes: true,
                    showCountryFlags: false,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Builder(
                    builder: (context) => roundedButton(
                        color: Colors.lightBlueAccent,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
//                          final phone = _phone;
                       //   uploadImage(context);
                          await loginPhone(_phone, context);

                          setState(() {
                            showSpinner = false;
                          });
                        },
                        fieldName: "Login"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future loginPhone(String phone, BuildContext context) {
    var _result;

    final option = _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (AuthCredential credential) async {
          final _result = await _auth.signInWithCredential(credential);
          _result.user.uid;

        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
          return "Error";
        },
        codeSent: (String verficationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Verfication Code : '),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controllertext,
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () async {
                          if (_controllertext.text.isEmpty) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Please Enter Verfication Code !!"),
                              ),
                            );
                          } else {
                            var credential = PhoneAuthProvider.credential(
                                verificationId: verficationId,
                                smsCode: _controllertext.text.trim());
                            var result = await _auth
                                .signInWithCredential(credential)
                                .then((user) {
                              //Navigator.pushNamed(context, HomePageScreen.id);
                            }).catchError((e) {
                              print(e);
                            });
                            User users = _auth.currentUser;
                            if (users != null) {
                              var ok = _fireStore
                                  .collection("dataUsers")
                                  .doc(users.uid)
                                  .set({
                                "username": username,
                                "phone": _phone,
                                "Url": urlImage,
                                "uId": _auth.currentUser.uid
                              });
                              ok.whenComplete(() {
                                //uploadImage(context);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    HomePageScreen.id, (route) => false);
                                // uploadImage(context);
                              });
                            } else {
                              print('ERROR');
                            }
                          }
                        },
                        child: Text('Confirm')),
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verficationId) {
          verficationId = verficationId;
          print(verficationId);
        },
        timeout: Duration(seconds: 0));
  }

  void pickImage(isCamera) async {
    var imageSelected;
    if (isCamera) {
      imageSelected = await ImagePicker.platform.pickImage(source: ImageSource.camera);
      Navigator.pop(context);
    } else {
      imageSelected = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      Navigator.pop(context);
    }
    setState(() {
      _image = imageSelected;
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      //width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        children: [
          Center(
            child: Text(
              ' Choose Profile Photo ',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                onPressed: () {
                  isCamera = true;
                  pickImage(isCamera);

                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              SizedBox(
                width: 15.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  isCamera = false;
                  pickImage(isCamera);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future uploadImage(context) async {
    try {
      var storage =
          FirebaseStorage.instance.ref().child(p.basename(_image.path));
      UploadTask uploadTask = storage.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      urlImage = await taskSnapshot.ref.getDownloadURL();
      print("url : " + urlImage);
    } catch (ex) {
      print(ex.massage);
    }
  }
}
