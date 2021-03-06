import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/modules/addstatus/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CubitAddNewStatus extends Cubit<AddNewStatus> {
  FirebaseFirestore _fire = FirebaseFirestore.instance;
  User _auth = FirebaseAuth.instance.currentUser;

  CubitAddNewStatus() : super(AddStatusInitials());

  CubitAddNewStatus get(context) => BlocProvider.of(context);
  var data, datanum, uid;

  saveStatesFirebase(context, String dataStates) {
    DocumentReference docRef = _fire.collection('dataUsers').doc(_auth.uid);

    docRef.get().then((value) {
      if (value.exists) {
        data = value["username"];
        datanum = value["phone"];
        uid = value["uId"];
      }
    }).whenComplete(() {
      _fire
          .collection("dataUsers")
          .doc(_auth.uid)
          .collection("Status")
          .doc(uid)
          .set({
        "date": DateTime.now(),
        "phone": datanum,
        "UId": uid,
        "username": data
      }).whenComplete(() {
        emit(AddStatusInitials());

        _fire.collection("dataUsers")
            .doc(_auth.uid)
            .collection("Status")
            .doc(_auth.uid)
            .collection("dStatusUser")
            .doc()
            .set({
          "status": dataStates,
          "date": DateTime.now(),
        }).whenComplete(() {
          Navigator.pop(context);
          emit(AddStatusSuccess());
          _fire.collection("dataUsers")
              .doc(_auth.uid)
              .collection("users")
              .get()
              .then((value) {
            print(value.docs.length);
            print(value.docs[0]["id"]);

            for (int i = 0; i < value.docs.length; i++) {
              _fire
                  .collection("dataUsers")
                  .doc(_auth.uid)
                  .collection("Status")
                  .doc(value.docs[0]["id"])
                  .set({
                "date": DateTime.now(),
                "phone": value.docs[0]["phone_client"],
                "UId": value.docs[0]["id"],
                "username": value.docs[0]["username"]
              }).whenComplete(() {
                _fire
                    .collection("dataUsers")
                    .doc(value.docs[0]["id"])
                    .collection("Status")
                    .doc(_auth.uid)
                    .collection("dStatusUser")
                    .doc()
                    .set({
                  "status": dataStates,
                  "date": DateTime.now(),
                }).whenComplete(() {
                  emit(AddStatusSuccess());
                  Navigator.pop(context);
                }).catchError((e) {
                  print("Error in Firebase Upload : " + e.toString());
                  emit(AddStatusError());
                });
              });
            }
          });
        }).catchError((e) {
          print("Error in Firebase Upload : " + e.toString());
          emit(AddStatusError());
        });
      });
    });
  }
}
