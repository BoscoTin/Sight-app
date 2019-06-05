import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:myapp/Utilities/Constant.dart';

Future<ConsultRecord> createConsultRecord(String patientID, Map body) async{
   return http.patch('${Constants.URL_RECORD}?patient_id=${patientID}', body: body).then((http.Response response){
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null){
      throw new Exception("Error while fetching data");
    }
    final rep = json.decode(response.body);
    final repJson = rep[0];
    return ConsultRecord.fromJson(repJson);
  });
}

Future<ConsultRecord> getConsultRecord(String patientID) async{
  try{
    final response = await http.get('${Constants.URL_RECORD}?patient_id=${patientID}', headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return ConsultRecord.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e){
    return null;
  }
}

class ConsultRecord{
  final String problems;
  final String handle;
  final String furtherreview;
  final String furtheropt;

  ConsultRecord({this.problems, this.handle, this.furtheropt, this.furtherreview});

  factory ConsultRecord.fromJson(Map<String, dynamic> json){
    return ConsultRecord(
      problems: json['problems'],
      handle: json['handle'],
      furtherreview: json['furtherreview'],
      furtheropt: json['furtheropt']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map['problems'] = problems;
    map['handle'] = handle;
    map['furtheropt'] = furtheropt;
    map['furtherreview'] = furtherreview;

    return map;
  }
}

// Updated
