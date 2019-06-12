import 'package:flutter/material.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/AppBar.dart';
import 'package:myapp/Utilities/Constant.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:myapp/Model/PatientInfo.dart';

class Register extends StatefulWidget{
  // show text in the confirm button
  String progress;

  Register({Key key}) :
        progress = Strings.confirm,
        super(key:key);

  @override
  _RegisterState createState () => _RegisterState();
}

class _RegisterState extends State<Register>{
  // textfield controllers
  TextEditingController nameController;
  TextEditingController idController;
  TextEditingController phoneNumberController;
  TextEditingController schoolController;

  String sex;
  DateTime dateOfBirth;

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.leavingAlertQuestion,
  );

  // Construct
  @override
  void initState(){
    super.initState();
    nameController = new TextEditingController();
    idController = new TextEditingController();
    phoneNumberController = new TextEditingController();
    sex = '';
    schoolController = new TextEditingController();
    dateOfBirth = new DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => backPressed(context),
      child: GestureDetector(
        /// dismissing keyboard
        onTap: (){ FocusScope.of(context).requestFocus(new FocusNode()); },

        child: Scaffold(
          appBar: CustomAppBar(
            title: Strings.register,
            showBackButton: true,
            showHomeButton: true,
            showLogoutButton: true,
            backPressed: backPressed,
            bottomShowing: null,
          ),

          body: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Theme.of(context).backgroundColor,

            body: ListView(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 40.0),
              children: <Widget>[
                /// name tile
                Card(
                  color: Theme.of(context).disabledColor,
                  child: ListTile(
                    leading: Text( Strings.name,
                      style: TextStyle(
                          fontSize: Constants.normalFontSize
                      ),
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Strings.typeHere,
                        hintStyle: TextStyle(
                          color: Theme.of(context).buttonColor
                        )
                      ),
                      controller: nameController,
                      // Set the keyboard
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(fontSize: Constants.normalFontSize),
                    ),
                  ),
                ),

                /// ID card number tile
                Card(
                  color: Theme.of(context).disabledColor,
                  child: ListTile(
                    leading: Text( Strings.IDCard,
                      style: TextStyle(
                          fontSize: Constants.normalFontSize
                      ),
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Strings.typeHere,
                          hintStyle: TextStyle(
                              color: Theme.of(context).buttonColor
                          )
                      ),
                      controller: idController,
                      // Set the keyboard
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(fontSize: Constants.normalFontSize),

                    ),
                  ),
                ),

                /// phone number tile
                Card(
                  color: Theme.of(context).disabledColor,
                  child: ListTile(
                    leading: Text( Strings.phoneNumber,
                      style: TextStyle(
                          fontSize: Constants.normalFontSize
                      ),
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Strings.typeHere,
                          hintStyle: TextStyle(
                              color: Theme.of(context).buttonColor
                          )
                      ),
                      controller: phoneNumberController,
                      // Set the keyboard
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(fontSize: Constants.normalFontSize),

                    ),
                  ),
                ),

                /// student sex tile
                Card(
                  color: Theme.of(context).disabledColor,
                  child: ListTile(
                    leading: Text( Strings.sex,
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
                                if(sex == Strings.male){
                                  sex = "";
                                }
                                else sex = Strings.male;

                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (sex == Strings.male) ? Theme.of(context).hintColor: Theme.of(context).disabledColor,
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
                                if(sex == Strings.female){
                                  sex = "";
                                }
                                else sex = Strings.female;

                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (sex == Strings.female) ? Theme.of(context).hintColor: Theme.of(context).disabledColor,
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

                /// Textfield for date info
                Card(
                  color: Theme.of(context).disabledColor,
                  child: ListTile(
                    leading: Text( Strings.dateOfBirth,
                      style: TextStyle(
                          fontSize: Constants.normalFontSize
                      ),
                    ),

                    title: GestureDetector(
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(dateOfBirth),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: Constants.normalFontSize),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ),

                /// Textfield for school info
                Card(
                  color: Theme.of(context).disabledColor,
                  child: ListTile(
                    leading: Text( Strings.school,
                      style: TextStyle(
                          fontSize: Constants.normalFontSize
                      ),
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Strings.typeHere,
                          hintStyle: TextStyle(
                              color: Theme.of(context).buttonColor
                          )
                      ),
                      controller: schoolController,
                      // Set the keyboard
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(fontSize: Constants.normalFontSize),
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
                        name: nameController.text,
                        id: idController.text,
                        phoneNumber: phoneNumberController.text,
                        birth: DateFormat('yyyy.MM.dd').format(dateOfBirth),
                        sex: sex,
                        school: schoolController.text
                    );
                    PatientInfo patientinfo = await createPatientInfo(newPatientInfo.toMap()).timeout(const Duration(seconds: 10), onTimeout: (){ return null; });

                    if(patientinfo != null){
                      // Write to check-record database
                      PatientID newPatientID = new PatientID(
                          patientName: patientinfo.name,
                          patientBirth: patientinfo.birth,
                          patientID: patientinfo.id,
                          patientSchool: patientinfo.school
                      );
                      PatientID patientid;

                      while(patientid == null) {
                        patientid = await createPatientID(newPatientID.toMap()).timeout(const Duration(seconds: 10), onTimeout: () {return null;});
                      }

                      // Notice the user that the patient has been added
                        Functions.showAlert(context,
                            Strings.successRecord + '\n', Functions.nothing);
                    } else{
                      /// CANNOT SUBMIT, SHOW ALERT AND CALL USER TO TRY AGAIN
                      Functions.showAlert(
                          context,
                          Strings.cannotSubmit,
                          Functions.nothing
                      );
                    }

                    // clear screen and restore to default
                    setState(() {
                      idController.text = '';
                      nameController.text = '';
                      sex = '';
                      phoneNumberController.text = '';
                      widget.progress = Strings.confirm;
                    });
                  },
                ),

              ],
            ),

          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        firstDate: new DateTime(1900),
        lastDate: DateTime.now()
    );

    if(_picked != null) {
      setState(() {
        dateOfBirth = _picked;
      });
    }
  }
}