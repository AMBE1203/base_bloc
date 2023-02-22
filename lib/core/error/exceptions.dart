class RemoteException implements Exception {
  String? errorCode;
  String? errorMessage;
  int? httpStatusCode;

  RemoteException({this.httpStatusCode, this.errorCode, this.errorMessage});
}

class LocalException implements Exception {
  String? errorCode;
  String? errorMessage;

  LocalException({this.errorCode, this.errorMessage});
}

class CacheException implements Exception {
  String? errorMessage;
  CacheException({this.errorMessage});
}

class IOException implements Exception {
  String? errorMessage;
  String? errorCode;
  IOException({this.errorMessage, this.errorCode});
}
