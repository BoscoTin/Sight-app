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

  String profileID;

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
    basicInfoList = [Strings.name, Strings.IDCard, Strings.phoneNumber, Strings.sex, Strings.dateOfBirth, Strings.school];
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
      widget.profileID = args[1];
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
                constructTab('basic'),
                constructTab('checking-right'),
                constructTab('checking-left'),
                constructTab('extra'),
                Consultation(
                  isViewing: ((widget.isReviewing == 'true')? true : false),
                  profileID: widget.profileID,
                )
              ]
          )
        ),
      ),
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

  ListView constructTab(String type){
    List<Widget> list = [];

    switch(type){
      case 'basic':
        list = basicFieldRow();
        break;
      case 'checking-right':
        list = checkingRow(false);
        break;
      case 'checking-left':
        list = checkingRow(true);
        break;
      case 'extra':
        list = slitExtraRow();
        break;
    }

    return ListView(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
      children: list,
    );
  }


  /*
    # Widget for create a list tile used for showing the information
    # It will take a info section then put them into a row
    @ parameter
    infoItem: take the infoItem from infoList
  */
  List<Widget> checkingRow (bool isLeft){
    List<Widget> list = [];

    list.add(
        FutureBuilder<CheckInfo>(
            future: getCheckInfo(isLeft, widget.profileID),
            builder: (context, rep){
              if(rep.hasData){
                return(Column(
                  children: <Widget>[
                    oneRow(Strings.vision_livingEyeSight, rep.data.vision_livingEyeSight),
                    oneRow(Strings.vision_bareEyeSight, rep.data.vision_bareEyeSight),
                    oneRow(Strings.vision_eyeGlasses, rep.data.vision_eyeGlasses),
                    oneRow(Strings.vision_bestEyeSight, rep.data.vision_bestEyeSight),
                    oneRow(Strings.opto_diopter, rep.data.opto_diopter),
                    oneRow(Strings.opto_astigmatism, rep.data.opto_astigmatism),
                    oneRow(Strings.opto_astigmatismaxis, rep.data.opto_astigmatismaxis),
                    oneRow(Strings.slit_conjunctiva, rep.data.slit_conjunctiva),
                    oneRow(Strings.slit_cornea, rep.data.slit_cornea),
                    oneRow(Strings.slit_eyelid, rep.data.slit_eyelid),
                    oneRow(Strings.slit_lens, rep.data.slit_lens),
                    oneRow(Strings.slit_Hirschbergtest, rep.data.slit_Hirschbergtest),
                  ],
                ));
              }
              else{
                return oneRow('档案', '搜寻中');
              }
            })
    );

    return list;
  }

  List<Widget> basicFieldRow () {
    List<Widget> list = [];

    list.add(
        FutureBuilder<BasicInfo>(
            future: getBasicInfo(widget.profileID),
            builder: (context, rep){
              if(rep.hasData){
                return( Column(
                  children: <Widget>[
                    oneRow(Strings.name, rep.data.name),
                    oneRow(Strings.phoneNumber, rep.data.number),
                    oneRow(Strings.sex, rep.data.sex),
                    oneRow(Strings.dateOfBirth, rep.data.birth),
                    oneRow(Strings.IDCard, rep.data.id),
                    oneRow(Strings.school, rep.data.school)
                  ],
                ));
              }
              else{
                return oneRow('档案', '搜寻中');
              }
            })
    );

    return list;
  }

  List<Widget> slitExtraRow () {
    List<Widget> list = [];

    list.add(
        FutureBuilder<SlitExtraInfo>(
            future: getSlitExtraInfo(widget.profileID),
            builder: (context, rep){
              if(rep.hasData){
                return(Column(
                  children: <Widget>[
                    oneRow(Strings.slit_exchange, rep.data.slit_exchange),
                    oneRow(Strings.slit_eyeballshivering, rep.data.slit_eyeballshivering)
                  ],
                ));
              }
              else{
                return oneRow('档案', '搜寻中');
              }
            })
    );

    return list;
  }
}