import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

/*
  # The function that will make use of the http.get method to do GET operation
*/
Future<BasicInfo> getBasicInfo(String patientID) async{
  http.Response response;
  try{
    response = await http.get('${Constants.URL_STU}?studentNumber=${patientID}', headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return BasicInfo.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e){
    return null;
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

  factory BasicInfo.fromList(Map<String, dynamic> json){
    return BasicInfo(
      name: json['studentName'],
      number: json['studentNumber'],
      sex: json['studentSex'],
      birth: json['studentBirth'],
    );
  }
}

Future<List<BasicInfo>> getSameNameInfos(String name) async{
  http.Response response;
  try{
    response = await http.get('${Constants.URL_STU}?studentName=${name}', headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return sameNameFromJaon(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e){
    return null;
  }
}

List<BasicInfo> sameNameFromJaon(Map<dynamic, dynamic> json){
  List<dynamic> list = json['data'];

  List<BasicInfo> returnList = [];
  for( Map<String, dynamic> item in list ){
    returnList.add(BasicInfo.fromList(item));
  }

  return returnList;
}
