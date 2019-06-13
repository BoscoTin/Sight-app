import 'package:flutter/material.dart';
import 'Utilities/Constant.dart';
import 'Utilities/Functions.dart';
import 'Utilities/AppBar.dart';
import 'Utilities/string.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'package:myapp/Model/BasicInfo.dart';

class UserSearch extends StatefulWidget{
  // submit to the page navigate to, showing the test that the user want to run
  String test;
  // submitting progress, default is confirm button
  String progress;

  /*
  @parameter
  test: the test type passed from HomePage
  */
  UserSearch({Key key}) :
        test = "",
        progress = Strings.searchButton,
        super(key:key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch>{
  TextEditingController patientNameController;
  TextEditingController schoolController;
  DateTime studentDateOfBirth;
  TextEditingController idCardController;

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.backHomeAlertQuestion,
  );

  /// instantiate variables here
  @override
  void initState(){
    patientNameController = new TextEditingController();
    schoolController = new TextEditingController();
    idCardController = new TextEditingController();
    studentDateOfBirth = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// receive arguments from whom called
    if(widget.test == "")
      widget.test = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () => backPressed(context),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Theme.of(context).backgroundColor,

        /// set app bar
        appBar: CustomAppBar(
          title: Strings.searchUsers,
          showBackButton: true,
          showHomeButton: true,
          showLogoutButton: true,
          backPressed: backPressed,
          bottomShowing: null,
        ),

        body: GestureDetector(
          /// for dismissing keyboard
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },

          child: ListView(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 40.0, bottom: 40.0),

            children: <Widget>[
              /// THE PATIENT NAME INPUT FIELD
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
                    controller: patientNameController,
                    // Set the keyboard
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(fontSize: Constants.normalFontSize),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

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
                        (studentDateOfBirth != null)? DateFormat('yyyy.MM.dd').format(studentDateOfBirth): '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Constants.normalFontSize),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

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

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

              /// THE ID CARD INPUT FIELD
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
                    controller: idCardController,
                    // Set the keyboard
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(fontSize: Constants.normalFontSize),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

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

                /// pop to desired page and pass the identification detail to home page
                onTap: () async{
                  // TODO: USER SEARCH SUBMIT BUTTON
                  setState(() {
                    widget.progress = Strings.searching;
                  });

                  String patientName = patientNameController.text;
                  String dateOfBirth = (studentDateOfBirth == null)? '' : DateFormat('yyyy.MM.dd').format(studentDateOfBirth);
                  String school = schoolController.text;
                  String idCard = idCardController.text;
                  List<BasicInfo> samePplList = await getSameInfos(patientName, dateOfBirth, school, idCard).timeout(const Duration(seconds: 10), onTimeout: () => null );

                  /// set up navigating route
                  String route;
                  switch(widget.test){
                    case Strings.visionTest:
                    case Strings.optometry:
                      route = '/visionOptometry';
                      break;
                    case Strings.slitLamp:
                      route = '/slitLamp';
                      break;
                    case Strings.reviewingProfile:
                      route = '/reviewProfile';
                      break;
                    default:
                      route = '';
                      break;
                  }

                  if(samePplList != null) {
                    if (samePplList.length > 1) {
                      /// more than one people have same name and same birth
                      List<String> navigate = await Functions.chooseList(context, samePplList);
                      if(navigate != null && navigate[0] == 'true'){
                        /// set up arguments and push to desired route
                        List<String> args = [widget.test, navigate[1], navigate[2], navigate[3], 'false'];
                        Navigator.pushNamed(context, route, arguments: args);
                      } else {
                        /// find no people, show alert to call user type again
                        Functions.showAlert(context, Strings.fileNotExist, Functions.nothing);
                      }

                    } else if (samePplList.length == 1) {
                      /// set up arguments and push to desired route
                      List<String> args = [widget.test, samePplList[0].id, samePplList[0].name, samePplList[0].birth, 'false'];
                      Navigator.pushNamed(context, route, arguments: args);
                    } else {
                      /// find no people, show alert to call user type again
                      Functions.showAlert(context, Strings.fileNotExist, Functions.nothing);
                    }

                  } else {
                    /// find no people, show alert to call user type again
                    Functions.showAlert(context, Strings.fileNotExist, Functions.nothing);
                  }

                  /// set back state of the button and the text controllers
                  setState(() {
                    widget.progress = Strings.searchButton;
                    patientNameController.text = '';
                    schoolController.text = '';
                    studentDateOfBirth = null;
                  });
                },
              ),

              // keyboard height
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(2000),
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