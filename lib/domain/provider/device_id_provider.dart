import 'package:base_bloc/data/local/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:uuid/uuid.dart';

abstract class DeviceIdProvider {
  Future<String> getDeviceId();

  Future<void> clearDeviceId();
}

class DeviceIdProviderImpl extends DeviceIdProvider {
  final _storage = const FlutterSecureStorage();

  DeviceIdProviderImpl();

  @override
  Future<void> clearDeviceId() async {
    try {
      _storage.delete(key: kDeviceIdKey);
    } catch (ex) {
      Logger().d('clearDeviceId Exception ${ex.toString()}');
    }
  }

  @override
  Future<String> getDeviceId() async {
    String deviceId = '';
    try {
      deviceId = await _storage.read(key: kDeviceIdKey) ?? '';
      if (deviceId.isEmpty) {
        deviceId = await PlatformDeviceId.getDeviceId ?? const Uuid().v4();
        await _storage.write(key: kDeviceIdKey, value: deviceId);
      }
    } catch (ex) {
      Logger().d('getDeviceId Exception ${ex.toString()}');
    }

    return deviceId;
  }
}
