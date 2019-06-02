import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

Future<PatientInfo> createPatientInfo(Map body) async{
  return http.post(Constants.URL_STU, body: body).then((http.Response response){
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null){
      throw new Exception("Error while fetching data");
    }
    final rep = json.decode(response.body);
    final repJson = rep;
    return PatientInfo.fromJson(repJson);
  });
}

class PatientInfo{
  final String studentName;
  final String studentNumber;
  final String studentSex;
  final String studentBirth;

  PatientInfo({this.studentName, this.studentNumber, this.studentBirth, this.studentSex});

  factory PatientInfo.fromJson(Map<String, dynamic> json){
    return PatientInfo(
        studentName: json['studentName'],
        studentBirth: json['studentBirth'],
        studentNumber: json['studentNumber'],
        studentSex: json['studentSex']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map['studentName'] = studentName;
    map['studentNumber'] = studentNumber;
    map['studentBirth'] = studentBirth;
    map['studentSex'] = studentSex;

    return map;
  }
}

Future<PatientID> createPatientID(Map body) async{
  return http.post(Constants.URL_RECORD, body: body).then((http.Response response){
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null){
      throw new Exception("Error while fetching data");
    }
    final rep = json.decode(response.body);
    final repJson = rep;
    return PatientID.fromJson(repJson);
  });
}

class PatientID{
  final String patient_id;

  PatientID({this.patient_id});

  factory PatientID.fromJson(Map<String, dynamic> json){
    return PatientID(
        patient_id: json['patient_id']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['patient_id'] = patient_id;

    return map;
  }
}