import 'package:base_bloc/data/net/index.dart';
import 'package:base_bloc/data/remote/base/index.dart';
import 'package:base_bloc/domain/model/setting/setting_model.dart';

class SettingApiImpl extends BaseApi implements SettingApi {
  @override
  Future<SettingModel> fetchCustomerSetting() async {
    final connection = await initConnection();
    final json = await connection.execute(ApiInput(
        endPointProvider!.endpoints['get_customer_setting']!,
        param: {'size': 20}));
    final setting = SettingModel.fromJson(json);
    return setting;
  }
}
