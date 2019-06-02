import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

/*
  # The function that check if the patientID exists in database
 */
Future<String> isIDExist(String patientID) async{
  final response = await http.get('${Constants.URL_STU}?studentNumber=${patientID}', headers: {"Accept": "application/json"});

  if(response.statusCode == 200){
    BasicInfo info = BasicInfo.fromJson(json.decode(response.body));
    if(info.name != '') return info.name;
    else return '';
  } else return '';
}

/*
  # The function that will make use of the http.get method to do GET operation
*/
Future<BasicInfo> getBasicInfo(String patientID) async{
  final response = await http.get('${Constants.URL_STU}?studentNumber=${patientID}', headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    return BasicInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

/*
  The class contains all the information needed in the basic information section
*/
class BasicInfo{
  final String name;
  final String number;
  final String sex;
  final String birth;

  BasicInfo({this.name, this.number,this.sex, this.birth});

  // Method that take a
  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      name: json['data'][0]['studentName'],
      number: json['data'][0]['studentNumber'],
      sex: json['data'][0]['studentSex'],
      birth: json['data'][0]['studentBirth'],
    );
  }
}
