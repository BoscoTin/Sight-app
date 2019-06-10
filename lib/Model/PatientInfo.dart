import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

Future<PatientInfo> createPatientInfo(Map body) async{
  print(body);

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
  final String studentName;
  final String parentNumber;
  final String studentSex;
  final String studentBirth;
  final String studentIDCard;

  PatientInfo({this.studentName, this.studentIDCard, this.parentNumber, this.studentBirth, this.studentSex});

  factory PatientInfo.fromJson(Map<String, dynamic> json){
    return PatientInfo(
        studentName: json['studentName'],
        studentBirth: json['studentBirth'],
        parentNumber: json['parentsNumber'],
        studentSex: json['studentSex'],
        studentIDCard: json['studentIDCard']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map['studentName'] = studentName;
    map['parentsNumber'] = parentNumber;
    map['studentBirth'] = studentBirth;
    map['studentSex'] = studentSex;
    map['studentIDCard'] = studentIDCard;

    return map;
  }
}

Future<PatientID> createPatientID(Map body) async{
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

  PatientID({this.patientName, this.patientBirth});

  factory PatientID.fromJson(Map<String, dynamic> json){
    return PatientID(
        patientName: json['patientName'],
        patientBirth: json['patientBirth']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['patientName'] = patientName;
    map['patientBirth'] = patientBirth;

    return map;
  }
}