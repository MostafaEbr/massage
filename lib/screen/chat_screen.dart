import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final _auth = FirebaseAuth.instance;
final _fireCloud = FirebaseFirestore.instance;
FirebaseUser loggedInUser;

String path;
String id,phoneUsers;

class ChatScreen extends StatefulWidget {
  static const String id = 'chatScreen';
  QuerySnapshot doc;
  int index ;

  ChatScreen(this.doc,this.index);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final editTextController = TextEditingController();
  String textMessage;
  String currentUser;

  @override
  void initState() {
    super.initState();
    getcurrentUser();
  }

  void getcurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        //loggedInUser = user ;
        currentUser = user.phoneNumber;
        print("From ChatScreen " + user.email );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    id=widget.doc.docs[widget.index]["id"];
    phoneUsers=widget.doc.docs[widget.index]["currentPhone"];
    print("From Chat_Screen $id");

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(widget.doc.docs[widget.index]["username"]),
        actions: [
          IconButton(icon: Icon(Icons.phone),
            onPressed: () {
              // _callingPhone(widget.data["phone_client"]);
            },)
        ],
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Flexible(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilders(),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: editTextController,
                          onChanged: (value) {
                            //Do something with the user input.
                            textMessage = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          editTextController.clear();
                          path = _auth.currentUser.uid;
                          _fireCloud.collection("dataUsers")
                              .doc(path)
                              .collection("users")
                              .doc(id)
                              .collection("chats")
                              .doc()
                              .set({
                            "id": phoneUsers,
                            'textMassage': textMessage,
                            'sender': currentUser,
                            // 'rec': phoneClient,
                            'timeStamp': Timestamp.now()
                          }).whenComplete(() {
                              _fireCloud.collection("dataUsers")
                                  .doc(id)
                                  .collection("users")
                                  .doc(path)
                                  .collection("chats")
                                  .doc()
                                  .set({
                                "id": _auth.currentUser.uid,
                                'textMassage': textMessage,
                                'sender': currentUser,
                                // 'rec': phoneClient,
                                'timeStamp': Timestamp.now()
                              }).whenComplete(() => print ("Well Done Complete"));
                            });
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _callingPhone(phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw " Can not launch phone $phone ";
    }
  }
}

class StreamBuilders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder
      (
        stream:_fireCloud.collection("dataUsers")
            .doc(_auth.currentUser.uid)
            .collection("users")
            .doc(id)
            .collection("chats")
            .orderBy("timeStamp", descending: true)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            final message = snapshots.data.docs;
            List<MessageBubble> messageBubbles = [];
            print(message.length);
            for (var messages in message) {
              String text = messages['textMassage'];
              String sender = messages['sender'];


              final emil = _auth.currentUser;
              final currentUser = emil.phoneNumber;

              final messageBubble = MessageBubble(
                text: text,
                sender: sender,
                isMe: currentUser == sender,
              );
              messageBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                children: messageBubbles,
              ),
            );
          }
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Center(child: Text("Send Massage")
//              CircularProgressIndicator(
//                backgroundColor: Colors.lightBlue,
//              ),
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: TextStyle(fontSize: 12.0),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))
                : BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            color: isMe ? Colors.lightBlueAccent : Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15.0, color: isMe ? Colors.black : Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

