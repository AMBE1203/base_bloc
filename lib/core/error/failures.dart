abstract class Failure {
  String? message;
  int? httpStatusCode;
  String? errorCode;
  Failure({this.message, this.httpStatusCode, this.errorCode});
}

class RemoteFailure extends Failure {
  dynamic data;
  RemoteFailure(
      {String? msg, this.data, int? httpStatusCode, String? errorCode})
      : super(
      message: msg, httpStatusCode: httpStatusCode, errorCode: errorCode);
}

class LocalFailure extends Failure {
  LocalFailure({String? msg, String? errorCode})
      : super(message: msg, errorCode: errorCode);
}

class PlatformFailure extends Failure {
  PlatformFailure({String? msg, String? errorCode})
      : super(message: msg, errorCode: errorCode);
}

class UnknownFailure extends Failure {
  UnknownFailure({String? msg, int? code, String? errorCode})
      : super(message: msg, httpStatusCode: code, errorCode: errorCode);
}
