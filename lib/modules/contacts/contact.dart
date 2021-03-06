import 'package:chatapp/modules/contacts/cubit/cubit.dart';
import 'package:chatapp/modules/contacts/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Contacts extends StatelessWidget {
  static final id = 'Contacts';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Contacts"
      ),
    );
    //   BlocProvider(
    //   create: (context) => ContactCubit()..getAllContactList(),
    //   child: BlocConsumer<ContactCubit, ContactStates>(
    //     listener: (context, state) {},
    //     builder: (context, state) {
    //       var listContact = ContactCubit.get(context).people;
    //       ContactCubit.get(context).checkIfHaveAccountOrNo(listContact);
    //       // print(" Contact Length : ${ContactCubit.get(context).people.length}");
    //
    //       return ListView.separated(
    //         itemCount: listContact.length,
    //         itemBuilder: (context, index) =>itemList(
    //           listContact[index].displayName.isNotEmpty? listContact[index].displayName:"empty",
    //           listContact[index].phones.isNotEmpty?listContact[index].phones.elementAt(0).value:"empty",
    //
    //         ),
    //         separatorBuilder: (context, index) => Container(
    //           height: 1.0,
    //           color: Colors.grey[600],
    //           width: double.infinity,
    //         ),
    //       );
    //     },
    //   ),
    // );
  }





  Widget itemList (displayName,displayNum){
    return ListTile(
      title: Text(displayName.toString()),
      subtitle: Text(displayNum.toString()),
    );
  }
}

