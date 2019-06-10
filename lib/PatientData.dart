import 'package:flutter/material.dart';
import 'Utilities/AppBar.dart';
import 'Utilities/string.dart';
import 'Utilities/Functions.dart';
import 'package:myapp/Utilities/Constant.dart';
import 'testPages/Consultation.dart';

import 'package:myapp/Model/BasicInfo.dart';
import 'package:myapp/Model/CheckInfo.dart';
import 'package:myapp/Model/SlitExtraInfo.dart';

class PatientData extends StatefulWidget{
  // see if the arguments from last page is received
  bool isArgsReceived;
  // title of the page
  String test;
  // submitting progress, default is confirm button
  String progress;

  // define whether it is viewing mode or editing mode
  String isReviewing;

  String patientName;
  String dateOfBirth;

  PatientData({Key key}) :
      isArgsReceived = false,
      progress = Strings.confirm,
        super(key:key);

  _PatientState createState() => _PatientState();
}

class _PatientState extends State<PatientData> with SingleTickerProviderStateMixin{
  // control which tab the scaffold is showing
  TabController _tabController;

  // InfoList: all the information section will be shown in Form Field
  // BasicInfoList: basic information about students
  List<String> basicInfoList;
  // CheckInfoList: the checking information
  List<String> checkInfoList;
  // slitExtraInfoList: two extra slit lamp test item
  List<String> slitExtraInfoList;


  @override
  void initState() {
    /// SET THE TAB LENGTH HERE
    _tabController = TabController(vsync: this, length: Constants.consultationTabNumber);

    /// Construct the data types
    basicInfoList = [Strings.studentName, Strings.studentIDCard, Strings.parentNumber, Strings.studentSex, Strings.studentBirth];
    checkInfoList = [Strings.vision_livingEyeSight, Strings.vision_bareEyeSight, Strings.vision_eyeGlasses, Strings.vision_bestEyeSight, Strings.opto_diopter, Strings.opto_astigmatism, Strings.opto_astigmatismaxis, Strings.slit_conjunctiva, Strings.slit_cornea,Strings.slit_eyelid, Strings.slit_Hirschbergtest, Strings.slit_lens];
    slitExtraInfoList = [Strings.slit_exchange, Strings.slit_eyeballshivering];

    super.initState();
  }

    @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// for controlling pages
  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  /// define back press action
  Future<bool> Function(BuildContext) backPressed = (BuildContext context) => Functions.onBackPressedAlert(
    context,
    Functions.backPage,
    Strings.backAlertQuestion,
  );

  @override
  Widget build(BuildContext context) {
    /// receive parameters from last page
    if(!widget.isArgsReceived){
      List<String> args = ModalRoute.of(context).settings.arguments;
      widget.test = args[0];
      widget.patientName = args[2];
      widget.dateOfBirth = args[3];
      widget.isReviewing = args[4];
      widget.isArgsReceived = true;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },

      /// define swipe action to next page
      onHorizontalDragEnd: (DragEndDetails details) => (details) {
        if (details.primaryVelocity == 0) {
          return;
        }

        // define left right
        if (details.primaryVelocity.compareTo(0) == -1) {
          _nextPage(-1);
        }
        else
          _nextPage(1);
      },

      /// LAYOUT
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomPadding: false,

        appBar: CustomAppBar(
          title: widget.test,
          showBackButton: true,
          showHomeButton: true,
          showLogoutButton: true,
          backPressed: backPressed,
          bottomShowing: null,
        ),

        /// DOTS IN THE BOTTOM, showing which page
        bottomNavigationBar: PreferredSize(
            child: Container(
              height: 30.0,
              child: Center(
                child: TabPageSelector(controller: _tabController,),
              ),
            ),
            preferredSize: Size.fromHeight(30.0)
        ),

        body: Container(
          child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                constructTab(basicInfoList, 'basic'),
                constructTab(checkInfoList, 'checking-right'),
                constructTab(checkInfoList, 'checking-left'),
                constructTab(slitExtraInfoList, 'extra'),
                Consultation(
                  isViewing: ((widget.isReviewing == 'true')? true : false),
                  patientName: widget.patientName,
                  dateOfBirth: widget.dateOfBirth,
                )
              ]
          )
        ),
      ),
    );
  }

  ListView constructTab(List<String> checkList, String type){
    List<Widget> list = [];

    if(type == 'checking-right')
      list.add(
        Center(
          child: Text(Strings.right,
            style: TextStyle(
              fontSize: Constants.normalFontSize + 5
            ),
          ),
        )
      );
    if(type == 'checking-left')
      list.add(
          Center(
            child: Text(Strings.left,
              style: TextStyle(
                  fontSize: Constants.normalFontSize + 5
              ),
            ),
          )
      );

    for(String item in checkList){
      switch(type){
        case 'basic':
          list.add(basicFieldRow(item));
          break;
        case 'checking-right':
          list.add(checkingRow(item, false));
          break;
        case 'checking-left':
          list.add(checkingRow(item, true));
          break;
        case 'extra':
          list.add(slitExtraRow(item));
          break;
        default:
          break;
      }
    }

    return ListView(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
      children: list,
    );
  }

  // TODO: fix the future builders below so that they will not be crashed during null case

  /*
    # Widget for create a list tile used for showing the information
    # It will take a info section then put them into a row
    @ parameter
    infoItem: take the infoItem from infoList
  */
  Widget checkingRow (String checkInfo, bool isLeft){
    return Container(
      height: MediaQuery.of(context).size.height * Constants.columnRatio,

      child: Card(
        color: Theme.of(context).disabledColor,

        child: ListTile(
          leading: Text(checkInfo,
            style: TextStyle(
              fontSize: Constants.normalFontSize
            ),
          ),

          title: FutureBuilder<CheckInfo>(
            future: getCheckInfo(isLeft, widget.patientName, widget.dateOfBirth),
            builder: (context, rep){
              if(rep == null){
                return Text('',);
              }
              else if (rep.hasData){
                if (checkInfo == Strings.vision_livingEyeSight){
                  return SizedBox(
                    child: Text((rep.data.vision_livingEyeSight == null) ? '' : rep.data.vision_livingEyeSight, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.vision_bareEyeSight){
                  return SizedBox(
                    child: Text((rep.data.vision_bareEyeSight == null)? '' : rep.data.vision_bareEyeSight, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.vision_eyeGlasses){
                  return SizedBox(
                    child: Text((rep.data.vision_eyeGlasses == null)?'':rep.data.vision_eyeGlasses, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.vision_bestEyeSight){
                  return SizedBox(
                    child: Text((rep.data.vision_bestEyeSight == null)?'':rep.data.vision_bestEyeSight, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.opto_diopter){
                  return SizedBox(
                    child: Text((rep.data.opto_diopter == null)?'':rep.data.opto_diopter, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.opto_astigmatism){
                  return SizedBox(
                    child: Text((rep.data.opto_astigmatism == null)?'':rep.data.opto_astigmatism, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.opto_astigmatismaxis){
                  return SizedBox(
                    child: Text((rep.data.opto_astigmatismaxis == null)?'':rep.data.opto_astigmatismaxis, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.slit_conjunctiva) {
                  return SizedBox(
                    child: Text((rep.data.slit_conjunctiva == null)?'':rep.data.slit_conjunctiva, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.slit_cornea) {
                  return SizedBox(
                    child: Text((rep.data.slit_cornea == null)?'':rep.data.slit_cornea, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.slit_eyelid) {
                  return SizedBox(
                    child: Text((rep.data.slit_eyelid == null)?'':rep.data.slit_eyelid, textAlign: TextAlign.center,),
                  );
                }
                else if (checkInfo == Strings.slit_lens) {
                  return SizedBox(
                      child: Text((rep.data.slit_lens == null)?'':rep.data.slit_lens, textAlign: TextAlign.center,)
                  );
                }
                else if (checkInfo == Strings.slit_Hirschbergtest) {
                  return SizedBox(
                    child: Text((rep.data.slit_Hirschbergtest == null)?'':rep.data.slit_Hirschbergtest, textAlign: TextAlign.center,),
                  );
                }
              }
              else if (rep.hasError){
                return Text("${rep.error}");
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget basicFieldRow (String basicInfo) {
    return Container(
        height: MediaQuery.of(context).size.height * Constants.columnRatio,

        child: Card(
            color: Theme.of(context).disabledColor,

            child: ListTile(
              leading: Text(basicInfo,
                style: TextStyle(
                    fontSize: Constants.normalFontSize
                ),
              ),
              title: FutureBuilder<BasicInfo>(
                future: getBasicInfo(widget.patientName, widget.dateOfBirth),
                builder: (context, rep){
                  if(rep == null){
                    return Text('',);
                  }
                  else if (rep.hasData){
                    if (basicInfo == Strings.studentName){
                      return SizedBox(
                        child: Text((rep.data.name == null)?'':rep.data.name, textAlign: TextAlign.center,),
                      );
                    }
                    else if (basicInfo == Strings.parentNumber){
                      return SizedBox(
                        child: Text((rep.data.number==null)?'':rep.data.number, textAlign: TextAlign.center,),
                      );
                    }
                    else if (basicInfo == Strings.studentSex){
                      return SizedBox(
                        child: Text((rep.data.sex == null)?'':rep.data.sex, textAlign: TextAlign.center,),
                      );
                    }
                    else if (basicInfo == Strings.studentBirth){
                      return SizedBox(
                        child: Text((rep.data.birth == null)?'':rep.data.birth, textAlign: TextAlign.center,),
                      );
                    }
                    else if (basicInfo == Strings.studentIDCard){
                      return SizedBox(
                        child: Text((rep.data.id == null)?'':rep.data.id, textAlign: TextAlign.center,),
                      );
                    }
                  }
                  else if (rep.hasError){
                    return Text("${rep.error}");
                  }
                  return Center(child:CircularProgressIndicator());
                },
              ),
            )
        )
    );
  }

  Widget slitExtraRow (String slitExtraInfo) {
    return Container(
      height: MediaQuery.of(context).size.height * Constants.columnRatio,

      child: Card(
        color: Theme.of(context).disabledColor,

        child: ListTile(
          leading: Text(slitExtraInfo,
            style: TextStyle(
                fontSize: Constants.normalFontSize
            ),
          ),
          title: FutureBuilder<SlitExtraInfo>(
            future: getSlitExtraInfo(widget.patientName, widget.dateOfBirth),
            builder: (context, rep){
              if(rep == null){
                return Text('',);
              }
              else if (rep.hasData){
                if (slitExtraInfo == Strings.slit_exchange){
                  return SizedBox(
                    child: Text((rep.data.slit_exchange == null)?'':rep.data.slit_exchange, textAlign: TextAlign.center,),
                  );
                }
                else if (slitExtraInfo == Strings.slit_eyeballshivering){
                  return SizedBox(
                    child: Text((rep.data.slit_eyeballshivering == null)?'':rep.data.slit_eyeballshivering, textAlign: TextAlign.center,),
                  );
                }
              }
              else if (rep.hasError){
                return Text("${rep.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}