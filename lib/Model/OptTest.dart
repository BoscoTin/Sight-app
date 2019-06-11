import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

Future<OptTest> createOptTest(String patientID, Map<String, dynamic> body) async {
  try{
    return http.patch('${Constants.URL_RECORD}?patientIDCard=${patientID}', body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      //print(statusCode);
      //print(response.body);

      if (statusCode < 200 || statusCode > 400 || json == null){
        return null;
      }
      final rep = json.decode(response.body);
      final repJson = rep[0];
      return OptTest.fromJson(repJson);
    });
  } catch(e){
    return null;
  }
}

class OptTest{
  //final String patient_id;
  final String left_opto_diopter;
  final String right_opto_diopter;
  final String left_opto_astigmatism;
  final String right_opto_astigmatism;
  final String left_opto_astigmatismaxis;
  final String right_opto_astigmatismaxis;

  OptTest({this.left_opto_diopter, this.right_opto_diopter, this.left_opto_astigmatism, this.right_opto_astigmatism, this.left_opto_astigmatismaxis, this.right_opto_astigmatismaxis});

  factory OptTest.fromJson(Map<String, dynamic> json){
    return OptTest(
      left_opto_diopter: json['left_opto_diopter'],
      right_opto_diopter: json['right_opto_diopter'],
      left_opto_astigmatism: json['left_opto_astigmatism'],
      right_opto_astigmatism: json['right_opto_astigmatism'],
      left_opto_astigmatismaxis: json['left_opto_astigmatismaxis'],
      right_opto_astigmatismaxis: json['right_opto_astigmatismaxis'],
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map['left_opto_diopter'] = left_opto_diopter;
    map['right_opto_diopter'] = right_opto_diopter;
    map['left_opto_astigmatism'] = left_opto_astigmatism;
    map['right_opto_astigmatism'] = right_opto_astigmatism;
    map['left_opto_astigmatismaxis'] = left_opto_astigmatismaxis;
    map['right_opto_astigmatismaxis'] = right_opto_astigmatismaxis;

    return map;
  }

}

// Updated
