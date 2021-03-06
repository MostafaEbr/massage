import 'package:chatapp/modules/viewstorystat/cubit/cubit.dart';
import 'package:chatapp/modules/viewstorystat/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:story_view/story_view.dart";
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewStory extends StatelessWidget {
  static const id = "ViewStory";

  final storyData;

  final int index;

  final phoneNum;
  final dataUid;

  List<String> dataStatus;


  ViewStory({this.storyData, this.index, this.dataStatus, this.phoneNum,this.dataUid});

  final controller = StoryController();
  List<StoryItem> storyItem = List();

  @override
  Widget build(context) {
    final _fire = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    // List<StoryItem> storyItem = [
    //   StoryItem.text(title: "XDSXD ", backgroundColor: Colors.cyan),
    //   StoryItem.text(title: "JMSDCBND", backgroundColor: Colors.orange),
    //   StoryItem.text(title: "CMK ", backgroundColor: Colors.white),
    //   StoryItem.text(title: "CLMK ", backgroundColor: Colors.black),
    // ]; // your list of stories

    // return StreamBuilder (
    //   stream:  _fire
    //       .collection("dataUsers")
    //       .doc(_auth.currentUser.uid)
    //       .collection("Status")
    //       .doc(phoneNum)
    //   .collection("dStatusUser")
    //       .snapshots(),
    //   builder: (context, snapshot) {

    return BlocProvider(
        create: (context) => CubitViewStoryStatus(),
        child: BlocConsumer<CubitViewStoryStatus, ViewStoryStates>(
          listener: (context, state) {},
          builder: (context, state) {

            return StreamBuilder(
                    stream: _fire.collection("dataUsers")
                      .doc(_auth.currentUser.uid)
                      .collection("Status")
                      .doc(dataUid)
                      .collection("dStatusUser")
                      .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                        for(int i=0;i<snapshot.data.docs.length;i++){
                          storyItem.add(StoryItem.text(title: snapshot.data.docs[i]["status"], backgroundColor: Colors.grey,
                          textStyle: TextStyle(decoration: TextDecoration.none)
                          ),);
                          print (storyItem);
                        }}
                       return StoryView(
                          storyItems: storyItem,
                          controller: controller,
                          repeat: false,
                          onComplete: () {
                            Navigator.pop(context);
                          },
                          onVerticalSwipeComplete: (direction) {
                            if (direction == Direction.down) {
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                  );
                })
        );
  }



}
