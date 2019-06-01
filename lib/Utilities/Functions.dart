import 'package:flutter/material.dart';
import 'string.dart';
import 'package:flutter/services.dart';

class Functions{

  /// generic functions for backPress option used in each page
  /// parameter:
  /// - context: current context
  /// - confirmAction: action to be triggered after confirm button is clicked
  /// - alertQuestion: String of text that show in the dialog
  static Future<bool> onBackPressedAlert(BuildContext context, void Function(BuildContext) confirmAction, String alertQuestion){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(alertQuestion),
          actions: <Widget>[
            // Confirm button
            FlatButton(
              child: Text(Strings.confirm),
              onPressed: (){
                Navigator.of(context).pop();
                confirmAction(context);
              },
            ),

            FlatButton(
              child: Text(Strings.cancel),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
          ],
        )
    )??false;
  }

  /// function variable to trigger leave app action
  static void Function(BuildContext) leaveApp = (BuildContext context){
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  };

  /// function variable to trigger logout action
  static void Function(BuildContext) logout = (BuildContext context){
    Navigator.popUntil(context, ModalRoute.withName('/'));
  };

  /// function variable to trigger go home action
  static void Function(BuildContext) backHome = (BuildContext context){
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  };
}