import 'package:flutter/material.dart';
import 'Utilities/Constant.dart';
import 'Utilities/Functions.dart';
import 'Utilities/AppBar.dart';
import 'Utilities/string.dart';

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
  TextEditingController fileNumberController;

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
    fileNumberController = new TextEditingController();
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
              /// THE PROFILE ID TEXT FIELD
              Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                width: MediaQuery.of(context).size.width *2 / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Constants.boxBorderRadius)
                  ),
                  color: Theme.of(context).disabledColor,
                ),

                child: TextField(
                  controller: fileNumberController,
                  decoration: InputDecoration(
                      hintText: Strings.profileID,
                      hintStyle: TextStyle(
                        color: Theme.of(context).buttonColor,
                      ),
                      border: InputBorder.none
                  ),
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

              /// THE PATIENT NAME INPUT FIELD
              Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                width: MediaQuery.of(context).size.width *2 / 3,
                /// Set the text area to white
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Constants.boxBorderRadius)
                  ),
                  color: Theme.of(context).disabledColor,
                ),

                child: TextField(
                  // State the text data controller
                  controller: patientNameController,
                  /// decorate text field, cancel the bottom border
                  decoration: InputDecoration(
                    // hint text
                      hintText: Strings.patientName,
                      hintStyle: TextStyle(
                        color: Theme.of(context).buttonColor,
                      ),
                      // Cancel the border line under the textfield
                      border: InputBorder.none
                  ),
                  style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
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
                  setState(() {
                    widget.progress = Strings.searching;
                  });

                  String patientID = fileNumberController.text;
                  String patientName = await isIDExist(patientID);

                  if(patientName != ''){
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

                    /// set up arguments and push to desired route
                    List<String> args = [widget.test, patientID, patientName, 'true'];
                    Navigator.pushNamed(context, route, arguments: args);

                    /// set back state of the button
                    setState(() {
                      widget.progress = Strings.searchButton;
                    });
                  } else{
                    // TODO: search patient name and users choose which one
                    Functions.showAlert(context, Strings.fileNotExist, Functions.nothing);
                    /// set back state of the button
                    setState(() {
                      widget.progress = Strings.searchButton;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}