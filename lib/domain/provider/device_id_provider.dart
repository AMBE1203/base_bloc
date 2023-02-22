import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lazi_chat/core/utils/index.dart';
import 'package:logger/logger.dart';

const kDeviceIdKey = 'kDeviceIdKey';

abstract class DeviceIdProvider {
  Future<String> getDeviceId();

  Future<void> clearDeviceId();
}

class DeviceIdProviderImpl extends DeviceIdProvider {
  final _storage = const FlutterSecureStorage();
  final _deviceInfo = DeviceInfo();

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
      await _storage.read(key: kDeviceIdKey);
      if (deviceId.isEmpty) {
        deviceId = await _deviceInfo.deviceId ?? '';
        await _storage.write(key: kDeviceIdKey, value: deviceId);
      }
    } catch (ex) {
      Logger().d('getDeviceId Exception ${ex.toString()}');
    }

    return deviceId;
  }
}
