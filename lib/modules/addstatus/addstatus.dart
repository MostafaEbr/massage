import 'package:flutter/material.dart';
import 'package:chatapp/modules/addstatus/cubit/cubit.dart';
import 'package:chatapp/modules/addstatus/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AddStatus extends StatelessWidget
{
  static const String id = 'AddStatus';

  final _controlTextField =TextEditingController();
  @override
  Widget build(BuildContext context)
  {

    return BlocProvider(
      create: (context) => CubitAddNewStatus(),
      child: BlocConsumer<CubitAddNewStatus,AddNewStatus>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubitAddStatus = CubitAddNewStatus().get(context);
          return SafeArea(
            child: Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                
                onPressed: (){
                  cubitAddStatus.saveStatesFirebase(context,_controlTextField.text);
                 _controlTextField.clear();
                },
                label: Text('Done'),
                backgroundColor: Colors.orange,
              ),
              body:
              GestureDetector (
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0,50.0,15.0,15.0),
                  child: TextField(
                    maxLines: 23,
                    controller: _controlTextField,
                    textAlign: TextAlign.center,

                    decoration: InputDecoration(

                        border: InputBorder.none,
                        hintText: 'Enter a Status term',

                        hintStyle: TextStyle(color: Color(0xff3F3E71))),
                    style: TextStyle(
                        color: Color(0xff115a48),
                        fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose()
  {
    _controlTextField.dispose();
  }
}
