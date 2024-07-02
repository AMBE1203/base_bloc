import 'package:base_bloc/domain/model/index.dart';

abstract class SettingRepository {
  Future<SettingModel> fetchCustomerSetting();
}
