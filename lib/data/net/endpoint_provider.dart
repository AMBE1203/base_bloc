import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'api_endpoint_input.dart';

class EndPointProvider {
  Map<String, EndPoint> endpoints = {};

  Future<void> load() async {
    String jsonContent =
        await rootBundle.loadString("assets/jsons/api_endpoint.json");
    Map<String, dynamic> jsonObj = json.decode(jsonContent);
    for (var e in jsonObj.entries) {
      var endpoint = EndPoint.fromJson(e.value);
      endpoints[e.key] = endpoint;
    }
  }
}
