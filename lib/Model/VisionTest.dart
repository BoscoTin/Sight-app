import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

/*
  # Function that will take the body as a map and POST it to the server as json format
  @parameter
  patientID: the patient ID of the taget that we want to write data to
  body: the body of the content that is needed to be posted  as the format of map
  @return
  http.post
*/
Future<VisionTest> createVisionTest(String patientID, {Map<String, dynamic> body}) async {
  //print(body);
  try{
    //print(Constants.URL_RECORD + '?patientIDCard=' + patientID);
    final response = await http.patch('${Constants.URL_RECORD}?patientIDCard=${patientID}', body: body);
    //print(response.body);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      final rep = json.decode(response.body);
      // Cause before the response body is the array in json['data']
      // we need to take the body out from array
      // now redJson is simply the Json format response
      final repJson = rep[0];
      return VisionTest.fromJson(repJson);
    } else {
      return null;
    }
  } catch(e){
    return null;
  }
}

class VisionTest{
  final String left_vision_livingEyeSight;
  final String right_vision_livingEyeSight;
  final String left_vision_bareEyeSight;
  final String right_vision_bareEyeSight;
  final String left_vision_eyeGlasses;
  final String right_vision_eyeGlasses;
  final String left_vision_bestEyeSight;
  final String right_vision_bestEyeSight;

  VisionTest({this.left_vision_livingEyeSight, this.right_vision_livingEyeSight, this.left_vision_bareEyeSight, this.right_vision_bareEyeSight, this.left_vision_eyeGlasses, this.right_vision_eyeGlasses, this.left_vision_bestEyeSight, this.right_vision_bestEyeSight});

  // Convert the json of the content of the http response to a VisionTest object
  factory VisionTest.fromJson(Map<String, dynamic> json){
    return VisionTest(

        left_vision_livingEyeSight: json['left_vision_livingEyeSight'],
        left_vision_bareEyeSight: json['left_vision_bareEyeSight'],
        left_vision_eyeGlasses: json['left_vision_eyeGlasses'],
        left_vision_bestEyeSight: json['left_vision_bestEyeSight'],

        right_vision_livingEyeSight: json['right_vision_livingEyeSight'],
        right_vision_bareEyeSight: json['right_vision_bareEyeSight'],
        right_vision_eyeGlasses: json['right_vision_eyeGlasses'],
        right_vision_bestEyeSight: json['right_vision_bestEyeSight']
    );
  }

  // Convert the content of the VisionTest object into a map for inputing into create as body
  Map toMap(){
    var map = new Map<String, dynamic>();

    map['left_vision_livingEyeSight'] = left_vision_livingEyeSight;
    map['left_vision_bareEyeSight'] = left_vision_bareEyeSight;
    map['left_vision_eyeGlasses'] = left_vision_eyeGlasses;
    map['left_vision_bestEyeSight'] = left_vision_bestEyeSight;

    map['right_vision_livingEyeSight'] = right_vision_livingEyeSight;
    map['right_vision_bareEyeSight'] = right_vision_bareEyeSight;
    map['right_vision_eyeGlasses'] = right_vision_eyeGlasses;
    map['right_vision_bestEyeSight'] = right_vision_bestEyeSight;

    return map;
  }

}
