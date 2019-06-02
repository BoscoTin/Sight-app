import 'package:flutter/material.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/AppBar.dart';
import 'package:myapp/Utilities/Constant.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:myapp/Model/PatientInfo.dart';

class Register extends StatefulWidget{
  List<String> registeredUser;
  String progress;

  Register({Key key}) :
        registeredUser = [],
        progress = Strings.confirm,
        super(key:key);

  @override
  _RegisterState createState () => _RegisterState();
}

class _RegisterState extends State<Register>{

  // textfield controllers
  TextEditingController studentNameController;
  TextEditingController studentIDController;

  String studentSex;
  DateTime studentDateOfBirth;

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.backAlertQuestion,
  );

  // Construct
  @override
  void initState(){
    super.initState();
    studentNameController = new TextEditingController();
    studentIDController = new TextEditingController();
    studentSex = "";
    studentDateOfBirth = new DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      /// dismissing keyboard
      onTap: (){ FocusScope.of(context).requestFocus(new FocusNode()); },

      child: Scaffold(
        appBar: CustomAppBar(
            title: Strings.register,
            showBackButton: true,
            showHomeButton: true,
            showLogoutButton: true,
            backPressed: backPressed
        ),

        body: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Theme.of(context).backgroundColor,

          body: ListView(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 40.0),
            children: <Widget>[
              /// student name tile
              Card(
                color: Theme.of(context).disabledColor,
                child: ListTile(
                  leading: Text( Strings.studentName,
                    style: TextStyle(
                        fontSize: Constants.normalFontSize
                    ),
                  ),
                  title: Container(
                      // TODO color: Theme.of(context).disabledColor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constants.boxBorderRadius)
                      ),

                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: studentNameController,
                        // Set the keyboard
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontSize: Constants.normalFontSize),
                      ),
                  ),
                ),
              ),

              /// student ID tile
              Card(
                color: Theme.of(context).disabledColor,
                child: ListTile(
                  leading: Text( Strings.studentNumber,
                    style: TextStyle(
                        fontSize: Constants.normalFontSize
                    ),
                  ),
                  title: Container(
                      // TODO color: Theme.of(context).disabledColor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Constants.boxBorderRadius)
                      ),

                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: studentIDController,
                        // Set the keyboard
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontSize: Constants.normalFontSize),
                      ),
                  ),
                ),
              ),

              /// student sex tile
              Card(
                color: Theme.of(context).disabledColor,
                child: ListTile(
                  leading: Text( Strings.studentSex,
                    style: TextStyle(
                        fontSize: Constants.normalFontSize
                    ),
                  ),

                  title: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              if(studentSex == Strings.male){
                                studentSex = "";
                              }
                              else studentSex = Strings.male;

                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: (studentSex == Strings.male) ? Theme.of(context).hintColor: Theme.of(context).disabledColor,
                              ),
                              child: Center(child: Text(Strings.male,
                                style: TextStyle(fontSize: Constants.normalFontSize),
                                textAlign: TextAlign.center,
                              ),),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              if(studentSex == Strings.female){
                                studentSex = "";
                              }
                              else studentSex = Strings.female;

                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: (studentSex == Strings.female) ? Theme.of(context).hintColor: Theme.of(context).disabledColor,
                              ),

                              child:  Center(child: Text(Strings.female,
                                style: TextStyle(fontSize: Constants.normalFontSize),
                                textAlign: TextAlign.center,
                              ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Textfield for that info
              Card(
                color: Theme.of(context).disabledColor,
                child: ListTile(
                  leading: Text( Strings.studentSex,
                    style: TextStyle(
                        fontSize: Constants.normalFontSize
                    ),
                  ),

                  title: GestureDetector(
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(studentDateOfBirth),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Constants.normalFontSize),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
              ),

              /// CONFIRM BUTTON
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.2,

                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(Constants.boxBorderRadius),
                  ),

                  child: Center(
                    child: Text(widget.progress,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: Constants.normalFontSize,
                      ),
                    ),
                  ),
                ),

                /// submit data
                onTap: () async{
                  setState(() {
                    widget.progress = Strings.submitting;
                  });

                  PatientInfo newPatientInfo = new PatientInfo(
                      studentName: studentNameController.text,
                      studentNumber: studentIDController.text,
                      studentBirth: DateFormat('yyyy-MM-dd').format(studentDateOfBirth),
                      studentSex: studentSex
                  );
                  PatientInfo patientinfo = await createPatientInfo(newPatientInfo.toMap());

                  // Write to check-record database
                  PatientID newPatientID = new PatientID(
                      patient_id: studentIDController.text
                  );
                  PatientID patientid = await createPatientID(newPatientID.toMap());

                  Functions.showAlert(context, Strings.successRecord, Functions.backPage);
                },
              ),
            ],
          ),

        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: studentDateOfBirth,
        firstDate: new DateTime(1900),
        lastDate: DateTime.now()
    );

    if(_picked != null) {
      setState(() {
        studentDateOfBirth = _picked;
      });
    }
  }
}