import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/domain/model/index.dart';
import 'package:base_bloc/domain/provider/index.dart';
import 'package:base_bloc/domain/repository/index.dart';
import 'package:base_bloc/domain/use_case/index.dart';
import 'package:dartz/dartz.dart';

abstract class LogoutUseCase {
  Future<Either<Failure, bool>> logout({bool isRemoteLogout = false});
}

class LogoutUseCaseImpl extends BaseUseCase<bool> implements LogoutUseCase {
  LogoutUseCaseImpl(
    this._authenticationRepository,
    this._deviceIdProvider,
  );

  final AuthenticationRepository _authenticationRepository;
  final DeviceIdProvider _deviceIdProvider;
  late bool _isRemoteLogout;

  @override
  Future<Either<Failure, bool>> logout({bool isRemoteLogout = false}) async {
    _isRemoteLogout = isRemoteLogout;
    return execute();
  }

  @override
  Future<bool> main() async {
    final deviceId = await _deviceIdProvider.getDeviceId();
    var result = await _authenticationRepository.logout(
        param: LogoutParam(deviceId: deviceId), remoteLogout: _isRemoteLogout);
    return result;
  }
}
