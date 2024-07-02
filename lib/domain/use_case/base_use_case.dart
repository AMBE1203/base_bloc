import 'package:base_bloc/core/constants/index.dart';
import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/domain/repository/index.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

abstract class BaseUseCase<T> {
  Future<Either<Failure, T>> execute() async {
    try {
      final res = await main();
      return Right(res);
    } on RemoteException catch (ex) {
      return Left(RemoteFailure(
          msg: (ex.errorMessage?.isNotEmpty ?? false)
              ? ex.errorMessage
              : unknownErrorMessage,
          httpStatusCode: ex.httpStatusCode,
          errorCode: ex.errorCode));
    } on CacheException catch (ex) {
      return Left(LocalFailure(
          msg: (ex.errorMessage?.isNotEmpty ?? false)
              ? ex.errorMessage
              : unknownErrorMessage,
          errorCode: unknownErrorCode));
    } on PlatformException catch (ex) {
      return Left(LocalFailure(msg: ex.message, errorCode: unknownErrorCode));
    } on Exception {
      return Left(UnknownFailure(msg: unknownErrorCode));
    } on Error catch (ex) {
      return Left(UnknownFailure(msg: ex.toString()));
    }
  }

  Future<T> main();

  Future<bool> validateLoggedIn(
      {required AuthenticationRepository repository}) async {
    bool isLoggedIn = await repository.isLogged();
    if (!isLoggedIn) {
      throw RemoteException(
          errorCode: requireLoginErrorCode,
          errorMessage: requireLoginErrorCode);
    }
    return true;
  }
}
