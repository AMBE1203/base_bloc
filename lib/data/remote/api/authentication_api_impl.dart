import 'package:base_bloc/data/net/index.dart';
import 'package:base_bloc/data/remote/base/index.dart';
import 'package:base_bloc/domain/model/login/login_param.dart';
import 'package:base_bloc/domain/model/login/login_response.dart';
import 'package:base_bloc/domain/model/login/logout_param.dart';

class AuthenticationApiImpl extends BaseApi implements AuthenticationApi {
  @override
  Future<bool> logout({required LogoutParam param}) async {
    final connection = await initConnection();
    await connection.execute(ApiInput(
      endPointProvider!.endpoints['logout_account']!,
      body: param.toJson(),
    ));
    return Future.value(true);
  }

  @override
  Future<LoginResponse> login({required LoginParam param}) async {
    final connection = await initConnection();
    final json = await connection.execute(ApiInput(
      endPointProvider!.endpoints['login']!,
      body: param.toJson(),
    ));
    LoginResponse response = LoginResponse.fromJson(json);
    return response;
  }
}
