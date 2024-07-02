import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations shared = AppLocalizations._();
  Map<dynamic, dynamic> _localisedValues = {};

  AppLocalizations._();

  static AppLocalizations of(BuildContext context) {
    return shared;
  }

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }

  // defined text
  String get appName => text("appName");
  String get shareTitleDialog => text("shareTitleDialog");
  String get sessionExpiredMessage => text("sessionExpiredMessage");
  String get commonMessageConnectionError => text("commonMessageConnectionError");
  String get commonMessageServerMaintenance => text("commonMessageServerMaintenance");

  Future<void> reloadLanguageBundle({required String languageCode}) async {
    String path =
        "assets/jsons/localization_${languageCode.toLowerCase()}.json";
    String jsonContent = "";
    try {
      jsonContent = await rootBundle.loadString(path);
    } catch (_) {
      //use default Vietnamese
      jsonContent =
          await rootBundle.loadString("assets/jsons/localization_vi.json");
    }
    _localisedValues = json.decode(jsonContent);
  }
}
