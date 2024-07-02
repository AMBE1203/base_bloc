class LogoutParam {
  String deviceId;

  LogoutParam({
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    return data;
  }
}
