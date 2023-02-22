import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:lazi_chat/core/utils/index.dart';
import 'package:package_info_plus/package_info_plus.dart';

const kForceUpdateKey = 'force_update';

class RemoteConfigManager {
  FirebaseRemoteConfig? _remoteConfig;

  setupConfig() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig?.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 30),
      minimumFetchInterval: Duration.zero,
    ));
  }

  Future<RemoteConfigModel?> fetchAndActiveRemoteConfig() async {
    RemoteConfigModel? config;
    if (_remoteConfig == null) {
      await setupConfig();
    }
    await _remoteConfig!.fetchAndActivate();
    final value = _remoteConfig!.getValue(kForceUpdateKey);
    final json = jsonDecode(value.asString());
    if (json != null && json is List<dynamic>) {
      final listConfigs =
          json.map((e) => RemoteConfigModel.fromJson(e)).toList();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final currentPlatform =
          Platform.isIOS ? PlatformS.ios : PlatformS.android;

      config = listConfigs.firstWhereOrNull(
        (e) =>
            currentPlatform == e.platform &&
            e.package == (packageInfo.packageName),
      );
      config?.needUpdate =
          config.needUpdate && (packageInfo.version != config.version);
    }
    return config;
  }
}

class RemoteConfigModel {
  PlatformS platform;
  String package;
  String storeUrl;
  String version;
  bool needUpdate;

  RemoteConfigModel({
    required this.platform,
    required this.package,
    required this.storeUrl,
    required this.version,
    required this.needUpdate,
  });

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    final platform =
        json['platfom'] == 'ios' ? PlatformS.ios : PlatformS.android;
    final package = json['package'] ?? '';
    final storeUrl = json['storeUrl'] ?? '';
    final version = json['version'] ?? '';
    final needUpdate = json['needUpdate']?.toString().toBoolValue() ?? false;
    return RemoteConfigModel(
      platform: platform,
      package: package,
      storeUrl: storeUrl,
      version: version,
      needUpdate: needUpdate,
    );
  }
}

enum PlatformS { ios, android }
