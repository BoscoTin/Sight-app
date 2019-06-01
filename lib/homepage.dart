import 'package:flutter/material.dart';
import 'Utilities/string.dart';
import 'Utilities/AppBar.dart';
import 'Utilities/Functions.dart';

class HomePage extends StatefulWidget{
  String id;

  HomePage({Key key}) :
        id = null,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.logout,
    Strings.logoutAlertQuestion,
  );

  /// Function to unify the layout of the buttons


  @override
  Widget build(BuildContext context) {
    /// receive parameters from last page
    if(widget.id == null)
      widget.id = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      /// set the back action
      onWillPop: () => backPressed(context),

      /// layout of the page
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(
          title: Strings.homePage,
          showBackButton: false,
          showHomeButton: false,
          showLogoutButton: true,
          backPressed: backPressed,
        ),

        body: Center(
          child: Text(widget.id),
        ),
      ),
    );
  }
}