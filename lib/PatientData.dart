import 'package:flutter/material.dart';
import 'Utilities/AppBar.dart';
import 'Utilities/string.dart';
import 'Utilities/Functions.dart';

class PatientData extends StatefulWidget{
  bool isArgsReceived;
  String test;
  String patientName;
  String profileID;

  PatientData({Key key}) :
      isArgsReceived = false,
        super(key:key);

  _PatientState createState() => _PatientState();
}

class _PatientState extends State<PatientData>{

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.backAlertQuestion,
  );

  @override
  Widget build(BuildContext context) {
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