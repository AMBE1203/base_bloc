import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

import 'index.dart';

Map<String, String> readDartDefineFromEnv(String path, Flavor flavor) {
  final file = File(path);
  final map = flavor.toJson();
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    map.forEach(
        (k, v) => file.writeAsStringSync('$k=$v\n', mode: FileMode.append));
  }

  return map;
}

String convertEnvToDartDefineString(Map<String, String>? envs) {
  final StringBuffer buffer = StringBuffer();
  envs?.forEach((key, value) {
    buffer.write('--dart-define $key=$value ');
  });
  final string = buffer.toString();
  return string.substring(0, string.length - 1);
}

Flavor? getFlavorFromString(String launcherName) {
  return flavorsList
      .firstWhereOrNull((element) => element.isEqualToString(launcherName));
}
