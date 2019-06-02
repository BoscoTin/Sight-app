import 'package:flutter/material.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/AppBar.dart';

class VisionOptometry extends StatefulWidget{
  bool isArgsReceived;
  String test;
  String patientName;
  String profileID;

  VisionOptometry({Key key}) :
      isArgsReceived = false,
        super(key:key);

  @override
  _VisionOptometryState createState () => _VisionOptometryState();
}

class _VisionOptometryState extends State<VisionOptometry>{

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.backAlertQuestion,
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
        appBar: CustomAppBar(
            title: widget.test,
            showBackButton: true,
            showHomeButton: true,
            showLogoutButton: true,
            backPressed: backPressed
        ),

        body: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Text(widget.patientName + " " + widget.profileID),
        ),
      ),
    );
  }
}