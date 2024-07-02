import 'package:base_bloc/core/utils/index.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserDataModel {
  int id;
  String userName;
  String address;

  UserDataModel({
    this.id = 0,
    required this.userName,
    required this.address,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    final userName = json['userName'] ?? '';
    final address = json['address'] ?? '';

    return UserDataModel(
      id: 0,
      userName: userName,
      address: address,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "userName": userName,
      "address": address,
    };
    return data;
  }
}
