import 'package:flutter/material.dart';
import 'package:myapp/Utilities/string.dart';
import 'Utilities/Constant.dart';
import 'Utilities/Functions.dart';
import 'Utilities/AppBar.dart';

class LoginPage extends StatefulWidget{
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  /// set up controllers
  TextEditingController loginNameController;
  TextEditingController passwordController;

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.leaveApp,
    Strings.leaveAppQuestion,
  );

  @override
  void initState() {
    loginNameController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  /// layout the login page
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      ///  when back pressed, alert question ask you to leave or not, confirm to leave or cancel
      onWillPop: () => backPressed(context),

      child: GestureDetector(
        onTap: (){
          // for dismissing keyboard by tapping any area outside
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Theme.of(context).backgroundColor,

          /// appBar for showing 登录 in center
          appBar: CustomAppBar(
            title: Strings.loginbutton,
            showBackButton: false,
            showHomeButton: false,
            showLogoutButton: false,
            backPressed: backPressed,
          ),

          body: Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  /// login user name
                  TextFormField(
                    controller: loginNameController,
                    decoration: InputDecoration(
                      labelText: Strings.loginname,
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: Constants.labelTextSize,
                    ),
                  ),

                  /// password
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: Strings.loginpassword,
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: Constants.labelTextSize,
                    ),
                  ),

                  /// sized box as padding and login button
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  GestureDetector(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.2,

                      decoration: BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: BorderRadius.circular(Constants.boxBorderRadius),
                      ),

                      child: Center(
                        child: Text(Strings.loginbutton,
                          style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontSize: Constants.normalFontSize,
                          ),
                        ),
                      ),
                    ),

                    /// pop to Home page and pass the identification detail to home page
                    onTap: (){
                      // get identification detail
                      String identify = loginNameController.text;

                      Navigator.pushNamed(context, '/home',
                          arguments: identify
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}