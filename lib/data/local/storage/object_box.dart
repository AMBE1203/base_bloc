import 'dart:io';

import 'package:base_bloc/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final store = openStore(directory: '${dir.path}/objectbox');
    return ObjectBox._create(store);
  }
}
