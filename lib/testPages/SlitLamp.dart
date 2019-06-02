import 'package:flutter/material.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/AppBar.dart';

class SlitLamp extends StatefulWidget{
  // see if the arguments from last page is received
  bool isArgsReceived;
  // title of the page
  String test;
  // submitting progress, default is confirm button
  String progress;

  String patientName;
  String profileID;

  SlitLamp({Key key}) :
      isArgsReceived = false,
      progress = Strings.confirm,
        super(key:key);

  @override
  _SlitLampState createState () => _SlitLampState();
}

class _SlitLampState extends State<SlitLamp>{

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.leavingAlertQuestion,
  );

  @override
  Widget build(BuildContext context) {
    /// receive parameters from last page
    if(!widget.isArgsReceived){
      List<String> args = ModalRoute.of(context).settings.arguments;
      widget.test = args[0];
      widget.profileID = args[1];
      widget.patientName = args[2];
    }
    return GestureDetector(

      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(
          title: widget.test,
          showBackButton: true,
          showHomeButton: true,
          showLogoutButton: true,
          backPressed: backPressed,
          bottomShowing: null,
        ),

        body: Text(widget.patientName + " " + widget.profileID),
      ),
    );
  }
}