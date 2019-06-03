import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

Future<CheckInfo> getCheckInfo(bool isLeft, String patientID) async{
  final response = await http.get('${Constants.URL_RECORD}?patient_id=${patientID}', headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    return CheckInfo.fromJson(json.decode(response.body), isLeft);
  } else {
    throw Exception('Failed to load post');
  }
}

class CheckInfo{
  final String vision_livingEyeSight;
  final String vision_bareEyeSight;
  final String vision_eyeGlasses;
  final String vision_bestEyeSight;
  final String opto_diopter;
  final String opto_astigmatism;
  final String opto_astigmatismaxis;
  final String slit_eyelid;
  final String slit_conjunctiva;
  final String slit_cornea;
  final String slit_lens;
  final String slit_Hirschbergtest;


  CheckInfo({this.vision_livingEyeSight, this.vision_bareEyeSight, this.vision_eyeGlasses, this.vision_bestEyeSight, this.opto_diopter, this.opto_astigmatism, this.opto_astigmatismaxis, this.slit_conjunctiva, this.slit_cornea, this.slit_eyelid, this.slit_Hirschbergtest, this.slit_lens});

  factory CheckInfo.fromJson(Map<String, dynamic> json, bool isLeft) {
    if (isLeft){
      return CheckInfo(
          vision_livingEyeSight: json['data'][0]['left_vision_livingEyeSight'],
          vision_bareEyeSight: json['data'][0]['left_vision_bareEyeSight'],
          vision_eyeGlasses: json['data'][0]['left_vision_eyeGlasses'],
          vision_bestEyeSight: json['data'][0]['left_vision_bestEyeSight'],
          opto_diopter: json['data'][0]['left_opto_diopter'],
          opto_astigmatism: json['data'][0]['left_opto_astigmatism'],
          opto_astigmatismaxis: json['data'][0]['left_opto_astigmatismaxis'],
          slit_cornea: json['data'][0]['left_slit_cornea'],
          slit_conjunctiva: json['data'][0]['left_slit_conjunctiva'],
          slit_eyelid: json['data'][0]['left_slit_eyelid'],
          slit_Hirschbergtest: json['data'][0]['left_slit_Hirschbergtest'],
          slit_lens: json['data'][0]['left_slit_lens']
        //// TODO: Add the slit_exchage and slit_eyeball
      );
    }
    else{
      return CheckInfo(
          vision_livingEyeSight: json['data'][0]['right_vision_livingEyeSight'],
          vision_bareEyeSight: json['data'][0]['right_vision_bareEyeSight'],
          vision_eyeGlasses: json['data'][0]['right_vision_eyeGlasses'],
          vision_bestEyeSight: json['data'][0]['right_vision_bestEyeSight'],
          opto_diopter: json['data'][0]['right_opto_diopter'],
          opto_astigmatism: json['data'][0]['right_opto_astigmatism'],
          opto_astigmatismaxis: json['data'][0]['right_opto_astigmatismaxis'],
          slit_conjunctiva: json['data'][0]['right_slit_conjunctiva'],
          slit_cornea: json['data'][0]['right_slit_cornea'],
          slit_eyelid: json['data'][0]['right_slit_eyelid'],
          slit_Hirschbergtest: json['data'][0]['right_slit_Hirschbergtest'],
          slit_lens: json['data'][0]['right_slit_lens']
      );
    }
  }
}
