import 'package:flutter/foundation.dart';

enum Flavor { dev, stg, prod }

const flavorKey = 'FLAVOR';
const baseUrlKey = 'BASEURL';
const xApiKey = 'XAPI';

class EnvConstants {
  const EnvConstants._();

  static Flavor flavor =
      Flavor.values.byName(const String.fromEnvironment(flavorKey));
  static String apiKey = const String.fromEnvironment(xApiKey);
  static String baseUrl = const String.fromEnvironment(baseUrlKey);

  static void init() {
    if (kDebugMode) {
      print("flavor: $flavor");
      print("apiKey: $apiKey");
      print("baseUrl: $baseUrl");
    }
  }
}
