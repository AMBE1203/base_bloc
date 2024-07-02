import 'dart:convert';

import 'package:base_bloc/core/constants/index.dart';
import 'package:flutter/services.dart';

import 'index.dart';

class EndPointProvider {
  Map<String, EndPoint> endpoints = {};

  Future<void> load() async {
    String jsonContent = await rootBundle.loadString(mEndpointPath);
    Map<String, dynamic> jsonObj = json.decode(jsonContent);
    for (var e in jsonObj.entries) {
      var endpoint = EndPoint.fromJson(e.value);
      endpoints[e.key] = endpoint;
    }
  }
}
