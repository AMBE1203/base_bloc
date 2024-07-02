import 'constants.dart';

enum FlavorsEnum { dev, stg, prod }

class Flavor {
  final FlavorsEnum flavorEnum;
  final String name;
  final String prefix;
  final String envPath;
  final String baseUrl;
  final String apiKey;

  const Flavor({
    required this.flavorEnum,
    required this.name,
    required this.prefix,
    required this.envPath,
    required this.baseUrl,
    required this.apiKey,
  });

  bool isEqualToString(String value) {
    final String formattedValue = value.toLowerCase().trim();
    return formattedValue.contains(name.toLowerCase().trim()) ||
        formattedValue.contains(prefix.toLowerCase().trim());
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data[flavorKey] = name;
    data[baseUrlKey] = baseUrl;
    data[xApiKey] = apiKey;
    return data;
  }

}
