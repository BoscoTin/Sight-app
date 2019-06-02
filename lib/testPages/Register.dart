import 'package:flutter/material.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/AppBar.dart';

class Register extends StatefulWidget{
  List<String> registeredUser;

  Register({Key key}) :
        registeredUser = [],
        super(key:key);

  @override
  _RegisterState createState () => _RegisterState();
}

class _RegisterState extends State<Register>{

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.backAlertQuestion,
  );

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

          body: Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 40.0),

            child: ListView(

            ),
          ),
        ),
      ),
    );
  }
}