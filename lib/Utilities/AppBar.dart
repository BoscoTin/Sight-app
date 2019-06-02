import 'package:flutter/material.dart';
import 'Constant.dart';
import 'Functions.dart';
import 'string.dart';

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

  // show in bottom area
  final Widget bottomShowing;

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
    @required this.bottomShowing
  }) :
        preferredSize = (bottomShowing == null) ? const Size.fromHeight(Constants.appBarPreferredSize) : const Size.fromHeight(Constants.appBarPreferredSize + Constants.appBarBottomSize),
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
      iconSize: Constants.appBarPreferredSize * 0.8,
    );

    /// variable of home button
    Widget homeButton = IconButton(
      icon: const Icon(Icons.home),
      onPressed: (){
        Functions.onBackPressedAlert(
            context,
            Functions.backHome,
            Strings.backHomeAlertQuestion
        );
      },
      iconSize: Constants.appBarPreferredSize * 0.8,
    );

    /// variable of logout button
    Widget logoutButton = IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: (){
        Functions.onBackPressedAlert(
            context,
            Functions.logout,
            Strings.logoutAlertQuestion
        );
      },
      iconSize: Constants.appBarPreferredSize * 0.8,
    );

    /// consider if logout and home button need to show
    List<Widget> action = [];
    if(showHomeButton) action.add(homeButton);
    if(showLogoutButton) action.add(logoutButton);

    return AppBar(
      automaticallyImplyLeading: false,

      /// 1. back arrow icon, show only if the boolean is true
      leading: (showBackButton)
          ? backButton
          : (!showHomeButton && !showLogoutButton) ? null : SizedBox(height: Constants.appBarPreferredSize * 0.8,),

      /// app bar title, set container to make it vertically centered
      title: Container(
        height: preferredSize.height,
        child: Center(
          child: Text(title,
            style: TextStyle(fontSize: Constants.appBarTitleFontSize),
          ),
        ),
      ),

      /// home button and logout button, to show the buttons or not, see above "consider if" part
      actions: action,

      /// what to show in bottom area, default is null
      bottom: bottomShowing,
    );
  }


}