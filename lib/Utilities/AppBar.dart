import 'package:flutter/material.dart';
import 'Constant.dart';
import 'Functions.dart';

/// Customize app bar with four components:
/// 1. back arrow button (for back to previous page)
/// 2. test showing the title of the page (from constructor)
/// 3. home button (for going to home page)
/// 4. logout button (for log out)
///
/// Above widgets are listed in a row - like form

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  final Size preferredSize;

  // given title from where it build
  final String title;
  // to judge the buttons show in appbar
  final bool showBackButton;
  final bool showHomeButton;
  final bool showLogoutButton;

  // receive back press function
  final Future<bool> Function(BuildContext) backPressed;

  /// constructor
  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.showBackButton,
    @required this.showHomeButton,
    @required this.showLogoutButton,
    @required this.backPressed,
  }) :
        preferredSize = const Size.fromHeight(Constants.appBarPreferredSize),
        super(key : key);


  /// layout of the app bar
  @override
  Widget build(BuildContext context) {

    /// variable of back icon button
    IconButton backButton = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        backPressed(context);
      },
      iconSize: preferredSize.height * 0.8,
    );

    /// variable of home button
    Widget homeButton = IconButton(
      icon: const Icon(Icons.home),
      onPressed: (){
        Functions.backHome(context);
      },
      iconSize: preferredSize.height * 0.8,
    );

    /// variable of logout button
    Widget logoutButton = IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: (){
        Functions.logout(context);
      },
      iconSize: preferredSize.height * 0.8,
    );

    /// consider if logout and home button need to show
    List<Widget> action = [];
    if(showHomeButton) action.add(homeButton);
    if(showLogoutButton) action.add(logoutButton);

    return AppBar(
      automaticallyImplyLeading: false,

      /// back arrow icon
      leading: (showBackButton)
          ? backButton
          : (!showHomeButton && !showLogoutButton) ? null : SizedBox.fromSize(size: preferredSize * 0.8,),

      /// app bar title, set container to make it vertically centered
      title: Container(
        height: MediaQuery.of(context).padding.top,
        child: Center(
          child: Text(title,
            style: TextStyle(fontSize: Constants.appBarTitleFontSize),
          ),
        ),
      ),

      /// home button and logout button
      actions: action,
    );
  }


}