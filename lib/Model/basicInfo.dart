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
    response = await http.get('${Constants.URL_STU}?studentName=${patientName}&studentBirth=${dateOfBirth}', headers: {"Accept": "application/json"});

    print(response.statusCode);
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

  BasicInfo({this.name, this.number,this.sex, this.birth, this.id});

  // Method that take a
  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      name: json['data'][0]['studentName'],
      number: json['data'][0]['parentNumber'],
      sex: json['data'][0]['studentSex'],
      birth: json['data'][0]['studentBirth'],
      //id: json['data'][0]['studentIDCard']
    );
  }

  factory BasicInfo.fromList(Map<String, dynamic> json){
    return BasicInfo(
      name: json['studentName'],
      number: json['parentNumber'],
      sex: json['studentSex'],
      birth: json['studentBirth'],
      //id: json['studentIDCard']
    );
  }
}

Future<List<BasicInfo>> getSameInfos(String name, String date) async{
  http.Response response;

  String queryPath = Constants.URL_STU;
  if(name != '' && date != ''){
    queryPath += '?studentName=${name}&studentBirth=${date}';
  } else if (name != ''){
    queryPath += '?studentName=${name}';
  } else if (date != ''){
    queryPath += '?studentBirth=${date}';
  } else return null;

  try{
    response = await http.get(queryPath);
    print(response.statusCode);
    print(queryPath);
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
