import 'package:chatapp/modules/status/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatesCubit extends Cubit<StatesCubitStatus> {
  StatesCubit() : super(StatesInitial());

  StatesCubit get(context) => BlocProvider.of(context);
  Map users;

  streamAddStates() {
    final _fireCloud = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    var data, dataNum,uId;

    DocumentReference docRef = _fireCloud.collection('dataUsers').doc(
        _auth.currentUser.uid);

    docRef.get().then((value) {
      emit(StatesLoadingCubit());
      if (value.exists) {
        data = value["username"];
        dataNum = value["phone"];
        uId=value["uId"];
      }
    }).whenComplete(() {
      // print(data);
      // print(dataNum);

      emit(StatesSuccessCubit());
      _fireCloud.collection("dataUsers")
          .doc(_auth.currentUser.uid)
          .collection("Status")
          .get().then((value) {

          users= value.docs.asMap();
      });
    });

    return users;
  }
}
