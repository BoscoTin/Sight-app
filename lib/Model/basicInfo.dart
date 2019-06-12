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
    response = await http.get('${Constants.URL_STU}?studentIDCard=${patientID}', headers: {"Accept": "application/json"});

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
  final String id;
  final String school;

  BasicInfo({this.name, this.number,this.sex, this.birth, this.id, this.school});

  // Method that take a
  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      name: json['data'][0]['studentName'],
      number: json['data'][0]['parentsNumber'],
      sex: json['data'][0]['studentSex'],
      birth: json['data'][0]['studentBirth'],
      id: json['data'][0]['studentIDCard'],
      school: json['data'][0]['studentSchool']
    );
  }

  factory BasicInfo.fromList(Map<String, dynamic> json){
    return BasicInfo(
      name: json['studentName'],
      number: json['parentsNumber'],
      sex: json['studentSex'],
      birth: json['studentBirth'],
      id: json['studentIDCard'],
      school: json['studentSchool']
    );
  }
}

Future<List<BasicInfo>> getSameInfos(String name, String date, String school, String idCard) async{
  http.Response response;

  String queryPath = Constants.URL_STU;
  if(name != '' || date != '' || school != '' || idCard != ''){
    queryPath += '?';
  }
  // TODO: check entity name
  if(name != ''){
    queryPath += 'studentName=${name}&';
  }
  if(date != '') {
    queryPath += 'studentBirth=${date}&';
  }
  if(school != ''){
    queryPath += 'studentSchool=${school}&';
  }
  if(idCard != ''){
    queryPath += 'studentIDCard=${idCard}&';
  }
  queryPath = queryPath.substring(0, queryPath.length - 1);

  if(queryPath == Constants.URL_STU) return null;

  try{
    response = await http.get(queryPath);
    if (response.statusCode == 200) {
      return samePplFromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e){
    return null;
  }
}

List<BasicInfo> samePplFromJson(Map<dynamic, dynamic> json){
  List<dynamic> list = json['data'];

  List<BasicInfo> returnList = [];
  for( Map<String, dynamic> item in list ){
    returnList.add(BasicInfo.fromList(item));
  }

  return returnList;
}
