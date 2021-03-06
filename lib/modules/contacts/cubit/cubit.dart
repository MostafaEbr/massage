import 'package:chatapp/modules/contacts/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ContactCubit extends Cubit<ContactStates> {
  ContactCubit() : super(ContactInitialState());

  static ContactCubit get(context) => BlocProvider.of(context);

  List<Contact> people = [];

  getAllContactList() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    people = _contacts;
    emit(ContactSuccessState());
  }

  int index = 0;

  checkIfHaveAccountOrNo(List<Contact> peopleList) {
    var storage = FirebaseFirestore.instance;
    String phone = "+20100964761";
     StreamBuilder(
       stream: storage.collection("dataUser").where("phone",isEqualTo: phone).snapshots(),
       builder: (BuildContext context,
         AsyncSnapshot<dynamic> snapshot) {
         if(!snapshot.hasData)
           {
             print("The mobile phone does not have account");

             return Text("");
           }

         print("The mobile phone have account"+snapshot.data.documents[0]["phone"]);
         return Text("");
       },


    );







  }
}
