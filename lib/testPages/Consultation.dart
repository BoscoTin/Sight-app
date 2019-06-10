import 'package:flutter/material.dart';
import 'package:myapp/Utilities/AppBar.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/Constant.dart';

import 'package:myapp/Model/ConsultRecord.dart';

class Consultation extends StatefulWidget{
  // judge whether the widget is in viewing mode or submitting mode
  bool isViewing;

  String profileID;
  // submitting progress, default is confirm button
  String progress;

  Consultation({Key key, @required this.isViewing, @required this.profileID}) : progress = Strings.confirm, super(key : key);

  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<Consultation>{
  // map storing the choice that user made in each multiple choice box
  Map<String, String> radioValue;

  // map storing the text controller of '其他'
  // e.g. formOtherController['眼臉左'] will return the text field controller inside the alert window
  //       the alert window only shows up when '其他' is pressed
  Map<String, TextEditingController> formOtherController;

  // map storing the value of '其他'
  // e.g. in alert window, user typed '盲了' in text field and confirm
  //       then, otherValue['眼臉左'] = '盲了'
  Map<String, String> otherValue;

  // controller of '處理'
  TextEditingController handleController;

  // test list
  List<String> testList;

  // construct
  @override
  void initState(){
    super.initState();
    radioValue = Map();
    formOtherController = Map();
    otherValue = Map();
    handleController = new TextEditingController();

    
  }

  String getData(String key){
    String result;
    if (otherValue[key] != null && otherValue[key] != '') {
      result = otherValue[key];
    }
    else{
      result = radioValue[key];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
      children: (widget.isViewing) ? viewing() : nonViewing(),
    );
  }


  /*
   Card for building single row of checked data
   */
  Card oneRow(String info, String value){
    if(value == null) value = '';

    return Card(
      color: Theme.of(context).disabledColor,
      child: ListTile(
        leading: Text(info,
          style: TextStyle(
            fontSize: Constants.normalFontSize
          ),
        ),

        title: Text(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: Constants.normalFontSize
          ),
        ),
      ),
    );
  }

  /*
    List of widgets storing 3 rows of Card oneRow(String info)
   */
  List<Widget> viewing(){
    List<Widget> list = [];

    list.add(
      FutureBuilder<ConsultRecord>(
        future: getConsultRecord(widget.profileID),
          builder: (context, rep){
            if(rep.hasData){
              return(Column(
                children: <Widget>[
                  oneRow(Strings.consultation, rep.data.problems),
                  oneRow(Strings.con_handle, rep.data.handle),
                  oneRow(Strings.con_furtheroptomery, (rep.data.furtheropt == 'yes') ? Strings.need : ((rep.data.furtheropt == null)? null : Strings.noNeed)),
                  oneRow(Strings.con_furtherreview, (rep.data.furtherreview == 'yes') ? Strings.need : ((rep.data.furtherreview == null) ? null : Strings.noNeed)),
                ],
              ));
            }
            else{
              return oneRow('404', 'not found');
            }
          })
    );

    return list;
  }


  /*
    List of widgets showing non-viewing data
   */
  List<Widget> nonViewing(){
    List<Widget> list = [];

    /// RADIO BUTTON
    list.add(twoChoiceRowList(Strings.consultation, Constants.consultation));

    list.add(Center(child: Text( Strings.con_handle, style: TextStyle(fontSize: Constants.normalFontSize + 5),),),);
    /// TEXT FIELD FOR HANDLE
    list.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Constants.boxBorderRadius)),
          color: Theme.of(context).disabledColor,
        ),
        padding: EdgeInsets.all(5.0),
        child: new ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * Constants.columnRatio * 5,
          ),
          child: new Scrollbar(
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: new TextField(
                controller: handleController,
                textInputAction: TextInputAction.done,
                maxLines: null,
              ),
            ),
          ),
        ),
      ),
    );

    /// TITLE: CHECKING CONDITION
    list.add(Center(child: Text( Strings.con_furthercheckingup, style: TextStyle(fontSize: Constants.normalFontSize + 5),),),);
    ///  TEST ITEMS: CHECKING CONDITION
    list.add(
      Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Constants.boxBorderRadius)),
          color: Theme.of(context).disabledColor,
        ),
        child: Column(
            children: <Widget>[
              furtherButtons(Strings.con_furtherreview),
              furtherButtons(Strings.con_furtheroptomery),
            ]
        ),
      ),
    );

    /// SUBMIT BUTTON
    list.add(
      // confirm button
      SizedBox(
        height: MediaQuery.of(context).size.height * Constants.columnRatio,
        child: RaisedButton(
          onPressed: () async{
            // TODO: CONSULTATION SUBMIT BUTTON

            setState(() {
              widget.progress = Strings.submitting;
            });

            ConsultRecord newConsultRecord = new ConsultRecord(
                problems: getData(Strings.consultation),
                handle: handleController.text,
                furtheropt: radioValue[Strings.con_furtheroptomery],
                furtherreview: radioValue[Strings.con_furtherreview]
            );
            ConsultRecord newConsult = await createConsultRecord(widget.profileID, newConsultRecord.toMap()).timeout(const Duration(seconds: 10), onTimeout: () {return null;});

            if(newConsult == null){
              // CALL USER TO SUBMIT AGAIN
              Functions.showAlert(
                  context,
                  Strings.cannotSubmit,
                  Functions.nothing
              );

              setState(() {
                widget.progress = Strings.confirm;
              });
            } else {
              // FINISH ALERT AND POP TO HOME PAGE
              Functions.showAlert(
                  context,
                  Strings.successRecord,
                  Functions.backPage
              );
            }
          },
          child: Text(widget.progress,
            style: TextStyle(fontSize: Constants.normalFontSize),
          ),
        ),
      ),
    );

    return list;
  }


  /// BELOW IS THE OLD CONSULTATION PART
  Widget furtherButtons(String key){
    // Reset the Value of the radioVlaue[key]
    if(radioValue[key] == null) radioValue[key] = '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: (){
              if (radioValue[key] != 'yes'){
                radioValue[key] = 'yes';
              }
              else {
                radioValue[key] = '';
              }

              setState(() {});
            },
            child: Container(
              height: MediaQuery.of(context).size.height * Constants.columnRatio,
              child: Center(child: Text(key, style: TextStyle(fontSize: Constants.normalFontSize), textAlign: TextAlign.center,),),
              decoration: BoxDecoration(
                color: (radioValue[key] == 'yes')? Theme.of(context).hintColor: Theme.of(context).disabledColor,
              ),
            ),
          ),
        )
      ],
    );

  }

  /// Return a row of radio button
  /// @param:
  /// - choices (List of String): the text showing on the buttons
  /// - key (String): to search in radioValues
  Widget radioButtons(List<String> choices, String key){
    List<Widget> buttons = []; // temp. store the widgets need to create inside the row
    if(formOtherController[key] == null) formOtherController[key] = new TextEditingController();
    if(radioValue[key] == null) radioValue[key] = '';

    for(String choice in choices){
      // add gesture detectors with loop
      buttons.add(
          Expanded(
            // here we customize the button by gesture detector
              child: GestureDetector(

                /// 1. onTap:  define the action that user tapping the rectangular box
                  onTap: () {
                    // if the choice is other and other is not turned blue yet
                    if (choice == Strings.choice_others && radioValue[key] != choice) {
                      // show an alert window here to collect information
                      showDialog(context: context, builder: (context) =>
                          AlertDialog(
                            title: Text(key + Strings.slit_AlertQuestion),
                            content: TextField(
                              controller: formOtherController[key],
                            ),
                            actions: <Widget>[
                              // confirm button
                              FlatButton(
                                child: Text(Strings.confirm),
                                onPressed: (){
                                  // save the string to otherValue[]
                                  otherValue[key] = formOtherController[key].text;

                                  // set states
                                  if (radioValue[key] != choice)
                                    radioValue[key] = choice;
                                  else
                                    radioValue[key] = "";

                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                              // cancel button
                              FlatButton(
                                child: Text(Strings.cancel),
                                onPressed: () {
                                  // clear the controller if the user say cancel
                                  formOtherController[key].text = '';
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )
                      );
                    }
                    else {
                      // because the choice cannot be choosing other, or just cancel the choice, so clear controller
                      formOtherController[key].text = '';
                      // also clear the value stored
                      otherValue[key] = "";

                      // set radio values
                      if (radioValue[key] != choice)
                        radioValue[key] = choice;
                      else
                        radioValue[key] = "";

                      // rebuild the whole widget by changing radio value, to make a certain cell become blur or not blue
                      setState((){});
                    }
                  },

                  /// 2. Container, define the color and text inside the button box
                  child: Container(
                    height: MediaQuery.of(context).size.height * Constants.columnRatio,
                    child: Center(child: Text(choice,
                      style: TextStyle(fontSize: Constants.normalFontSize),
                      textAlign: TextAlign.center,
                    ),),
                    decoration: BoxDecoration(
                      // defines the color of the box, by following the radio value
                      color: (radioValue[key] == choice)?
                      Theme.of(context).hintColor: Theme.of(context).disabledColor,
                    ),
                  )
              ))
      );
    }

    // after adding all buttons within the string list, return a row
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  /// Return a column with rows of radio buttons
  /// each row contains 2 radio buttons
  /// @param:
  /// - test (String): the name of the testing things
  /// - choice (List of String): the text showing on the buttons
  Container twoChoiceRowList(String test, List<String> choices){
    List<Widget> columnList = [];
    List<String> choiceList = [];

    // dividing the string list with 3 string one row, and send to radioButtons() to build buttons for it
    int counter = 0;
    for(String choice in choices){
      choiceList.add(choice);
      if(counter % 2 == 1 || counter == choices.length - 1){
        columnList.add(radioButtons(choiceList, test));
        choiceList = [];
      }
      ++ counter;
    }

    // return a container storing all rows built above
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Constants.boxBorderRadius)),
        color: Theme.of(context).disabledColor,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: columnList,
        ),
      ),
    );
  }

}