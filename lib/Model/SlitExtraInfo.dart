import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:myapp/Utilities/Constant.dart';

Future<SlitExtraInfo> getSlitExtraInfo(String patientID) async{
  try{
    final response = await http.get('${Constants.URL_RECORD}?patientIDCard=${patientID}', headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return SlitExtraInfo.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e){
    return null;
  }
}

class SlitExtraInfo{
  final String slit_exchange;
  final String slit_eyeballshivering;

  SlitExtraInfo({this.slit_exchange, this.slit_eyeballshivering});

  factory SlitExtraInfo.fromJson(Map<String, dynamic> json){
    return SlitExtraInfo(
      slit_exchange: json['data'][0]['slit_exchange'],
      slit_eyeballshivering: json['data'][0]['slit_eyeballshivering'],
    );
  }
}