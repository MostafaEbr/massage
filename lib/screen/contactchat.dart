import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;

class ContactChat extends StatefulWidget {
  static String id = 'ContactScreen';

  @override
  _ContactChatState createState() => _ContactChatState();
}

class _ContactChatState extends State<ContactChat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            StreamBuilderContact(),
          ],
        ),
      ),
    );
  }
}

class UserFireStore extends StatelessWidget {
  final String username;
  final String time;
  final String lastMassage;

  UserFireStore({this.username, this.time, this.lastMassage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Flexible(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                        width: 2, color: Theme.of(context).primaryColor),
                    //shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: AssetImage('images/avater.jpg'),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              username,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(time),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            lastMassage,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Divider(
                            height: 7,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}

class StreamBuilderContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser.uid;

    return StreamBuilder(
      stream: _fireStore
          .collection('dataUsers')
          .doc("$uid")
          .collection("users")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                String username = snapshot.data.docs[index]["username"];
                String time = snapshot.data.docs[index]["time"];
                String about = snapshot.data.docs[index]["lastMassage"];
                String id = snapshot.data.docs[index]["id"];

                return Padding(
                  padding: EdgeInsets.all(6.0),
                  child: ListTile(
                    title: Text(username),
                    subtitle: Text(about),
                    leading: CircleAvatar(
                      radius: 35.0,
                      backgroundImage: AssetImage('images/avater.jpg'),
                    ),
                    trailing: Text(time),
                    tileColor: Colors.white,
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(snapshot.data,index)));
                    },
                  ),
                );
              }),
        );
      },
    );
  }

}
