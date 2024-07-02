import 'package:base_bloc/domain/model/index.dart';

abstract class AuthenticationApi {
  Future<bool> logout({required LogoutParam param});

  Future<LoginResponse> login({required LoginParam param});

}

abstract class SettingApi {
  Future<SettingModel> fetchCustomerSetting();

}
