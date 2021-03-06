import 'file:///C:/MY_Github/chat_app/lib/modules/contacts/contact.dart';
import 'package:chatapp/modules/status/status.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screen/contactchat.dart';
import 'addusers.dart';
import '../modules/profile/profile.dart';



class HomePageScreen extends StatefulWidget {
  static final id = 'HomePageScreen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(

            actions: [
              IconButton( icon:Icon(Icons.add),onPressed: (){
                Navigator.pushNamed(context,AddUsers.id );
              }),
              SizedBox(width: 13.0,),
              IconButton(icon:Icon(Icons.more_vert),onPressed: (){

                Navigator.pushNamed(context,Profile.id );
              }, ),
            ],
            excludeHeaderSemantics: false,
            title: Text("Home"),

            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.message),
                  text: 'Chats',
                ),
                Tab(
                  icon: Icon(Icons.contact_page),
                  text: 'Contact',
                ),
                Tab(
                  icon: Icon(Icons.circle),
                  text: 'Status',
                ),
              ],

            ),
          ),

          body: TabBarView(
            children: [
              ContactChat(),
              Contacts(),
              Status(),
            ],
          ),
        ),
      ),
    );
  }
}
