import 'package:flutter/material.dart';
import 'Constant.dart';
import 'string.dart';

class CustomBottomArea extends StatelessWidget implements PreferredSizeWidget{
  String patientName;
  String dateOfBirth;

  @override
  final Size preferredSize;

  // constructor
  CustomBottomArea({Key key, @required this.patientName, @required this.dateOfBirth})
      : preferredSize = Size.fromHeight(Constants.appBarBottomSize),
        super(key:key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            /// SHOWING PROFILE ID
            Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(Constants.boxBorderRadius)
              ),

              child: Text((dateOfBirth == null)? Strings.dateOfBirth + ': ' + Strings.noDate : Strings.dateOfBirth + ': ' + dateOfBirth,
                style: TextStyle(
                  fontSize: Constants.appBarBottomFontSize,
                ),
              ),
            ),

            /// SHOWING PATIENT NAME
            Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(Constants.boxBorderRadius)
              ),

              child: Text(Strings.patientName + ': ' + patientName,
                style: TextStyle(
                  fontSize: Constants.appBarBottomFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}