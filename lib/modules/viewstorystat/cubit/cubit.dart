import 'package:chatapp/modules/viewstorystat/cubit/states.dart';
import 'package:chatapp/modules/viewstorystat/viewstory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CubitViewStoryStatus extends Cubit<ViewStoryStates> {

  FirebaseFirestore _fire = FirebaseFirestore.instance;
  User _auth = FirebaseAuth.instance.currentUser;

  ViewStory _viewStory = new ViewStory();
  List<QueryDocumentSnapshot> data;

  CubitViewStoryStatus() : super(ViewStoryStatusInitials());

  CubitViewStoryStatus get(context) => BlocProvider.of(context);


  returnStatesDataView (){
    _fire
        .collection("dataUsers")
        .doc(_auth.uid)
        .collection("Status")
        .doc("+201007196476")
        .collection("dStatusUser")
        .snapshots().listen((event) {
          data = event.docs;
          print(data.length);
    });
    print(data[0]["status"]);
    return data;
  }
}
