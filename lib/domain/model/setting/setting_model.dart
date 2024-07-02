import 'package:base_bloc/core/utils/index.dart';
import 'package:base_bloc/domain/enum/index.dart';
import 'package:collection/collection.dart';

const kNotification = "NOTIFICATION";
const kLanguage = "LANGUAGE";

class SettingItem {
  String name;
  String value;

  SettingItem({required this.name, required this.value});

  factory SettingItem.fromJson(Map<String, dynamic> json) {
    final name = json['id']['configType'];
    final value = json['configValue'];
    return SettingItem(name: name, value: value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'configValue': value};
    final jsonName = {'configType': name};
    json['id'] = jsonName;
    return json;
  }
}

class SettingModel {
  List<SettingItem> items = [];

  SettingModel({required this.items});

  LanguageCode? get language {
    final languageSetting = items.firstWhereOrNull((e) => e.name == kLanguage);
    return languageSetting != null
        ? getLanguageCodeFromString(code: languageSetting.value)
        : null;
  }

  bool get enableNotification {
    final languageSetting =
        items.firstWhereOrNull((e) => e.name == kNotification);
    return languageSetting != null ? languageSetting.value.toBoolValue() : true;
  }

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    List<SettingItem> items = [];
    final jsonSetting = json['content'];
    if (jsonSetting != null && jsonSetting is List<dynamic>) {
      items = jsonSetting.map((e) => SettingItem.fromJson(e)).toList();
    }
    return SettingModel(items: items);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> settingJson =
        items.map((e) => e.toJson()).toList();
    return {
      "content": settingJson,
    };
  }

  Future<bool> updateSettingItem({required SettingItem item}) async {
    final index = items.indexWhere((e) => e.name == item.name);
    if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }
    return true;
  }

}
