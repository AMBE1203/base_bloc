import 'package:dartz/dartz.dart';
import 'package:lazi_chat/core/error/index.dart';
import 'package:lazi_chat/domain/repository/index.dart';

import 'index.dart';

abstract class LogoutUseCase {
  Future<Either<Failure, bool>> logout({bool isRemoteLogout = true});
}

class LogoutUseCaseImpl extends BaseUseCase<bool> implements LogoutUseCase {
  final AuthRepository _authRepository;
  bool _isRemoteLogout = false;

  LogoutUseCaseImpl(this._authRepository);

  @override
  Future<Either<Failure, bool>> logout({bool isRemoteLogout = true}) async {
    _isRemoteLogout = isRemoteLogout;
    return execute();
  }

  @override
  Future<bool> main() async {
    var result = await _authRepository.logout(remoteLogout: _isRemoteLogout);
    return result;
  }
}
