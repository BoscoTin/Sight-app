import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

/*
  # The function that will make use of the http.get method to do GET operation
*/
Future<BasicInfo> getBasicInfo(String patientName, String dateOfBirth) async{
  http.Response response;
  try{
    response = await http.get('${Constants.URL_STU}?q={{"\$and": [{"patientName=":"${patientName}"}, {"patientBirth":"${dateOfBirth}"}]}}', headers: {"Accept": "application/json"});
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

Future<List<BasicInfo>> getSameInfos(String name, String date) async{
  http.Response response;

  date = date.replaceAll('.', '-');

  String queryPath = Constants.URL_STU;
  if(name != '' && date != ''){
    queryPath += '?q={{"\$and": [{"patientName=":"${name}"}, {"patientBirth":"${date}"}]}}';
  } else if (name != ''){
    queryPath += '?q={{"\$and": [{"patientName=":"${name}"}]}}';
  } else if (date != ''){
    queryPath += '?q={{"\$and": [{"patientBirth=":"${date}"}]}}';
  } else return null;

  print(queryPath);

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
