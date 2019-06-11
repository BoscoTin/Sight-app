import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

Future<PatientInfo> createPatientInfo(Map body) async{
  try{
    return http.post(Constants.URL_STU, body: body).then((http.Response response){
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 400 || json == null){
        return null;
      }
      final rep = json.decode(response.body);
      final repJson = rep;
      return PatientInfo.fromJson(repJson);
    });
  } catch(e){
    return null;
  }
}

class PatientInfo{
  final String name;
  final String phoneNumber;
  final String sex;
  final String birth;
  final String id;
  final String school;

  PatientInfo({this.name, this.phoneNumber, this.sex, this.birth, this.id, this.school});

  factory PatientInfo.fromJson(Map<String, dynamic> json){
    return PatientInfo(
        name: json['studentName'],
        birth: json['studentBirth'],
        phoneNumber: json['parentsNumber'],
        sex: json['studentSex'],
        id: json['studentIDCard'],
        school: json['studentSchool']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map['studentName'] = name;
    map['parentsNumber'] = phoneNumber;
    map['studentBirth'] = birth;
    map['studentSex'] = sex;
    map['studentIDCard'] = id;
    map['studentSchool'] = school;

    return map;
  }
}

Future<PatientID> createPatientID(Map body) async{
  print(body);
  return http.post(Constants.URL_RECORD, body: body).then((http.Response response){
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400 || json == null){
      return null;
    }
    final rep = json.decode(response.body);
    final repJson = rep;
    return PatientID.fromJson(repJson);
  });
}

class PatientID{
  final String patientName;
  final String patientBirth;
  final String patientID;
  final String patientSchool;

  PatientID({this.patientName, this.patientBirth, this.patientID, this.patientSchool});

  factory PatientID.fromJson(Map<String, dynamic> json){
    return PatientID(
        patientName: json['patientName'],
        patientBirth: json['patientBirth'],
        patientID: json['patientIDCard'],
        patientSchool: json['patientSchool']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['patientName'] = patientName;
    map['patientBirth'] = patientBirth;
    map['patientIDCard'] = patientID;
    map['patientSchool'] = patientSchool;

    return map;
  }
}