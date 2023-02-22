import 'package:lazi_chat/data/remote/base/index.dart';

class AuthApiImpl extends BaseApi implements AuthApi {
  @override
  Future<bool> logout() async {
    return true;
  }
}
