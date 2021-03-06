import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cubit/states.dart';
import 'file:///C:/MY_Github/chat_app/lib/modules/viewstorystat/viewstory.dart';
import 'package:chatapp/modules/addstatus/addstatus.dart';

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatesCubit(),
      child: BlocConsumer<StatesCubit, StatesCubitStatus>(
        listener: (context, state) {},
        builder: (context, state) {
          final states = StatesCubit().get(context);
          final phoneData  = states.streamAddStates();
          var userStatus = states.users;


          // Firebase init
          FirebaseFirestore _fire = FirebaseFirestore.instance;
          User _auth = FirebaseAuth.instance.currentUser;

          return Scaffold(
            body: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AddStatus.id);
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                        width: 1.0, color: Colors.white)),
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.account_circle_sharp,
                                    size: 60.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 10.0,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " My Status ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                " Add to my status",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text("VIEWED UPDATE"),
                  StreamBuilder(
                    stream: _fire
                        .collection("dataUsers")
                        .doc(_auth.uid)
                        .collection("Status")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData){}
                      return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                buildItemListView(snapshot.data.docs,index,context),
                            separatorBuilder: (context, index) => Container(
                              height: 1.0,

                            ),
                            itemCount:  snapshot.data.docs.length
                        ),
                      );
                    },
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildItemListView(snapshots, index, context)
  {
    String username = snapshots[index]["username"];
     Timestamp date = snapshots[index]["date"];
     String phone = snapshots[index]["phone"];
     String dataId = snapshots[index]["UId"];


     var datetime =  DateFormat.jm().format(date.toDate());

    return GestureDetector
      (
      onTap: ()=>Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewStory(storyData: snapshots,index:index,phoneNum:phone , dataUid: dataId)),
      ),

        child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container
                (
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(color: Colors.grey),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 1.0, color: Colors.white)),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                           Text(
                             datetime,
                             style: TextStyle(color: Colors.white),
                           )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
