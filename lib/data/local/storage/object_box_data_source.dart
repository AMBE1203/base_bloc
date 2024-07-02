import 'dart:io';

import 'package:base_bloc/domain/model/index.dart';
import 'package:path_provider/path_provider.dart';

import 'index.dart';

abstract class ObjectBoxDataSource {
  Future<bool> clearAllProduct();
}

class ObjectBoxDataSourceImpl implements ObjectBoxDataSource {
  final ObjectBox _objectBox;

  ObjectBoxDataSourceImpl(
    this._objectBox,
  );

  @override
  Future<bool> clearAllProduct() async {
    _objectBox.store.box<UserDataModel>().removeAll();
    Directory docDir = await getApplicationDocumentsDirectory();
    String dbPath = '${docDir.path}/objectbox/data.mdb';
    if (Directory(dbPath).existsSync()) {
      Directory(dbPath).deleteSync(recursive: true);
    }
    String lockPath = '${docDir.path}/objectbox/lock.mdb';
    if (Directory(lockPath).existsSync()) {
      Directory(lockPath).deleteSync(recursive: true);
    }
    return Future.value(true);
  }
}
