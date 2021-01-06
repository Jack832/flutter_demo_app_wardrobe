import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Utility {

  static Image imageFromBase64String(String base64){
    return Image.memory(base64Decode(base64),fit: BoxFit.fill,);
  }

  static Uint8List dataFromBase64String(String base64) {
    return base64Decode(base64);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

}