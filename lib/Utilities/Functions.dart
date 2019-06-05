import 'package:flutter/material.dart';
import 'string.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Model/BasicInfo.dart';
import 'Constant.dart';

class Functions{
  /// generic functions for showing pop-up alerts
  /// parameter:
  /// - message: what to pop-up with the user
  static Future<bool> showAlert(BuildContext context, String message, void Function(BuildContext) action){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(Strings.confirm),
              onPressed: (){
                Navigator.of(context).pop(true);
                action(context);
                },
            ),
          ],
        )
    )?? false;
  }

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

  /// function variable for navigation pop
  static void Function(BuildContext) backPage = (BuildContext context){
    Navigator.pop(context);
  };

  /// function variable for doing nothing
  static void Function(BuildContext) nothing = (BuildContext context){};


  /// function in User Search: make a list for user to choose one
  static Future<List<String>> chooseList(BuildContext context, List<BasicInfo> infos){
    List<Widget> widgets = [];

    for(int i = 0; i < infos.length; ++i){

      widgets.add(
        Container(
          height: 60,

          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop(['true', infos[i].number]);
            },
            child: ListTile(
              leading: Text(infos[i].number,
                style: TextStyle(
                    fontSize: Constants.normalFontSize
                ),
              ),
              title: Text(infos[i].name,
                style: TextStyle(
                    fontSize: Constants.normalFontSize
                ),
              ),
              subtitle: Text(infos[i].sex + ' ' + infos[i].birth,
                style: TextStyle(
                    fontSize: Constants.normalFontSize - 5
                ),
              ),
            ),
          ),
        )

      );
    }

    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(Strings.searchSameNameAlert,
          style: TextStyle(
            fontSize: Constants.normalFontSize + 5
          ),
        ),
        children: widgets,
      )
    )?? false;
  }
}