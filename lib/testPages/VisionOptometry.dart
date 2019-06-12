import 'package:flutter/material.dart';
import 'package:myapp/Utilities/Functions.dart';
import 'package:myapp/Utilities/string.dart';
import 'package:myapp/Utilities/AppBar.dart';
import 'package:myapp/Utilities/bottomForTestPages.dart';
import 'package:myapp/Utilities/Constant.dart';
import 'package:myapp/Model/VisionTest.dart';
import 'package:myapp/Model/OptTest.dart';

class VisionOptometry extends StatefulWidget{
  // see if the arguments from last page is received
  bool isArgsReceived;
  // title of the page
  String test;
  // submitting progress, default is confirm button
  String progress;

  String patientName;
  String profileID;
  String dateOfBirth;

  VisionOptometry({Key key}) :
      isArgsReceived = false,
      progress = Strings.confirm,
        super(key:key);

  @override
  _VisionOptometryState createState () => _VisionOptometryState();
}

class _VisionOptometryState extends State<VisionOptometry>{

  // testList: all checking items in this test
  List<String> testList = [];
  // Map of formField: Left/Right as Key, TextField as values
  Map<String, TextEditingController> rightFieldControllers;
  Map<String, TextEditingController> leftFieldControllers;

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.leavingAlertQuestion,
  );

  @override
  void initState() {
    /// Construct the data types
    rightFieldControllers = Map();
    leftFieldControllers = Map();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// receive parameters from last page
    if(!widget.isArgsReceived){
      List<String> args = ModalRoute.of(context).settings.arguments;
      widget.test = args[0];
      widget.profileID = args[1];
      widget.patientName = args[2];
      widget.dateOfBirth = args[3];
      widget.isArgsReceived = true;
    }

    /// State the corresponding checking of each values represent inside the text Data list
    testList = (widget.test == Strings.visionTest) ? Constants.visionTest : Constants.optometry;

    return WillPopScope(
      onWillPop: () => backPressed(context),
      child: GestureDetector(
        onTap: (){ FocusScope.of(context).requestFocus(new FocusNode()); },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Theme.of(context).backgroundColor,

          /// define appbar, with bottom area showing id and name
          appBar: CustomAppBar(
            title: widget.test,
            showBackButton: true,
            showHomeButton: true,
            showLogoutButton: true,
            backPressed: backPressed,

            /// TO SHOW PATIENT NAME AND ITS ID
            bottomShowing: CustomBottomArea(patientName: widget.patientName, dateOfBirth: widget.dateOfBirth,),
          ),

          body: ListView(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
            // SEE FUNCTION BELOW
            children: generateLayout(),
          ),
        ),
      ),
    );
  }

  /// DEFINE ONE CONTAINER OF THE TEST ITEM AND ITS INPUT FIELD
  Widget customInputRow(String testItem, bool isRight){
    if(isRight && rightFieldControllers[testItem] == null){
      rightFieldControllers[testItem] = new TextEditingController();
    }
    if(!isRight && leftFieldControllers[testItem] == null){
      leftFieldControllers[testItem] = new TextEditingController();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,

      child: Card(
        color: Theme.of(context).disabledColor,
        child: ListTile(
          leading: Text( testItem,
            style: TextStyle(
                fontSize: Constants.normalFontSize
            ),
          ),
          title: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.typeHere,
              hintStyle: TextStyle(
                  color: Theme.of(context).buttonColor
              ),
            ),
            controller: (isRight)? rightFieldControllers[testItem] : leftFieldControllers[testItem],
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                fontSize: Constants.normalFontSize
            ),
          ),
        ),
      ),
    );
  }

  /// DEFINE THE LAYOUT OF THE BODY
  List<Widget> generateLayout(){
    List<Widget> widgets = [];

    /// RIGHT EYE
    widgets.add(
        Text(Strings.right,
          style: TextStyle(
              fontSize: Constants.headingFontSize
          ),
        )
    );
    for(String s in testList){
      widgets.add(customInputRow(s, true));
    }

    widgets.add(SizedBox(height: MediaQuery.of(context).size.height * 0.02,));

    /// LEFT EYE
    widgets.add(
        Text(Strings.left,
          style: TextStyle(
              fontSize: Constants.headingFontSize
          ),
        )
    );
    for(String s in testList){
      widgets.add(customInputRow(s, false));
    }

    widgets.add(SizedBox(height: MediaQuery.of(context).size.height * 0.02,));

    /// CONFIRM BUTTON
    widgets.add(
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

          /// submit data
          onTap: () async{
            // TODO: VISION OPTOMETRY SUBMIT BUTTON

            setState(() {
              widget.progress = Strings.submitting;
            });

            if (widget.test == Strings.visionTest){
              // Construct the visionTest object
              VisionTest newVisionTest = new VisionTest(
                //patient_id: widget.patientID,
                  left_vision_livingEyeSight: (leftFieldControllers[Strings.vision_livingEyeSight] == null)? '': leftFieldControllers[Strings.vision_livingEyeSight].text,
                  left_vision_bareEyeSight: (leftFieldControllers[Strings.vision_bareEyeSight] == null)? '': leftFieldControllers[Strings.vision_bareEyeSight].text,
                  left_vision_eyeGlasses: (leftFieldControllers[Strings.vision_eyeGlasses] == null)? '' : leftFieldControllers[Strings.vision_eyeGlasses].text,
                  left_vision_bestEyeSight: (leftFieldControllers[Strings.vision_bestEyeSight] == null)? '' : leftFieldControllers[Strings.vision_bestEyeSight].text,
                  right_vision_livingEyeSight: (rightFieldControllers[Strings.vision_livingEyeSight] == null)? '' :rightFieldControllers[Strings.vision_livingEyeSight].text,
                  right_vision_bareEyeSight: (rightFieldControllers[Strings.vision_bareEyeSight] == null)? '' : rightFieldControllers[Strings.vision_bareEyeSight].text,
                  right_vision_eyeGlasses: (rightFieldControllers[Strings.vision_eyeGlasses] == null)? '' : rightFieldControllers[Strings.vision_eyeGlasses].text,
                  right_vision_bestEyeSight: (rightFieldControllers[Strings.vision_bestEyeSight] == null)? '' : rightFieldControllers[Strings.vision_bestEyeSight].text
              );
              // Call the API
              VisionTest newData = await createVisionTest(widget.profileID, body: newVisionTest.toMap()).timeout(const Duration(seconds: 10), onTimeout: (){ return null; });

              if(newData != null) {
                // show the following alert when the data is successfully submitted to the server
                Functions.showAlert(
                    context, Strings.successRecord, Functions.backPage);
              } else {
                // show the following alert and set state when data cannot be submitted
                Functions.showAlert(context, Strings.cannotSubmit, Functions.nothing);
                setState(() {
                  widget.progress = Strings.confirm;
                });
              }
            }
            else{
              OptTest newOptTest = new OptTest
                (
                //patient_id: widget.patientID,
                left_opto_diopter: leftFieldControllers[Strings.opto_diopter].text,
                left_opto_astigmatism: leftFieldControllers[Strings.opto_astigmatism].text,
                left_opto_astigmatismaxis: leftFieldControllers[Strings.opto_astigmatismaxis].text,
                right_opto_diopter: rightFieldControllers[Strings.opto_diopter].text,
                right_opto_astigmatism: rightFieldControllers[Strings.opto_astigmatism].text,
                right_opto_astigmatismaxis: rightFieldControllers[Strings.opto_astigmatismaxis].text,
              );
              OptTest newData = await createOptTest(widget.profileID, newOptTest.toMap()).timeout(const Duration(seconds: 10), onTimeout: (){ return null; });

              if(newData != null) {
                // show the following alert when the data is successfully submitted to the server
                Functions.showAlert(
                    context, Strings.successRecord, Functions.backPage);
              } else {
                // show the following alert and set state when data cannot be submitted
                Functions.showAlert(context, Strings.cannotSubmit, Functions.nothing);
                setState(() {
                  widget.progress = Strings.confirm;
                });
              }
            }
          },
        )
    );

    /// length of the keyboard
    widgets.add(
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)
    );

    return widgets;
  }
}