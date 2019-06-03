import 'package:flutter/material.dart';
import 'string.dart';
import 'Constant.dart';

class CustomRadioButton extends StatefulWidget{
  // radio value
  String radioValue;
  // choice list
  List<String> choiceList;
  // to control whether "other" field exist in this area or not
  bool isOther;
  // control text field
  TextEditingController otherField;

  /// constructors
  CustomRadioButton({Key key, @required this.choiceList, @required this.isOther})
      : super(key:key);

  /// function for accessing the value
  String value(){
    if(radioValue != Strings.choice_others)
      return radioValue;
    else return otherField.text;
  }

  @override
  _CustomRadioButtonState createState ()=> _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton>{
  int rowNumber;

  @override
  void initState(){
    widget.otherField = new TextEditingController();

    // calculating the rows that the widget should be occupied
    rowNumber = (widget.choiceList.length / Constants.rowCount).ceil();
    if(widget.isOther) rowNumber += 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: GridView(
              shrinkWrap: true,
              // row count
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Constants.rowCount,
                childAspectRatio: 2
              ),
              children: gridViewList(),
            ),
          ),

          (widget.isOther) ? Card(
            color: Theme.of(context).disabledColor,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  widget.radioValue = Strings.choice_others;
                });
              },
              child: ListTile(
                leading: Text(Strings.choice_others + ': ',
                  style: TextStyle(
                    fontSize: Constants.normalFontSize,
                  ),
                ),
                title: TextField(
                  controller: widget.otherField,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Strings.typeHere,
                    hintStyle: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontSize: Constants.normalFontSize,
                    ),
                  ),
                ),

              ),
            ),
          ): null,
        ],
      )
    );
  }

  /// FOR GENERATING SINGLE BUTTOn
  Widget choiceButton(String item){
    return GestureDetector(
      onTap: (){
        setState(() {
          if(widget.radioValue != item)
            widget.radioValue = item;
          else widget.radioValue = '';
        });
      },
      child: Card(
        color: (widget.radioValue == item)? Theme.of(context).hintColor : Theme.of(context).disabledColor,
        child: Center(
          child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Constants.normalFontSize,
            ),
          ),
        ),
      ),
    );
  }

  /// FOR GENERATING BUTTON LIST
  List<Widget> gridViewList(){
    List<Widget> list = [];

    for(String item in widget.choiceList)
      list.add(choiceButton(item));

    return list;
  }
}