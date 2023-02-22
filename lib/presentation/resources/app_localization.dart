import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  String get appName => text('application_name');
  String get shareTitleDialog => text('application_name');

  String get sessionExpiredMessage =>
      text('common_message_error_session_expired');

  String get commonMessageConnectionError =>
      text('common_message_connection_error');

  String get commonMessageServerMaintenance =>
      text('common_message_server_maintenance');

  String get commonMessagePasswordError =>
      text('common_message_password_error');

  String get commonMessageConfirmPasswordError =>
      text('common_message_confirm_password_error');

  String get commonMessageEmailError => text('common_message_account_error');

  String get commonMessageNoData => text('common_message_no_data');

  String get commonMessageNoSearchResult =>
      text('common_message_no_search_result');

  String get commonMessageCopied => text('common_message_copied');

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
