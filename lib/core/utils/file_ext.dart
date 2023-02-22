import 'dart:io';
import 'dart:math';

Future<int> getFileSize({required String filePath}) async {
  final file = File(filePath);
  final bool isExist = await file.exists();
  if (!isExist) {
    return 0;
  }
  final size = await file.length();
  return max(0, size);
}

Future<int> getFileSizeInMB({required String filePath}) async {
  final bytes = await getFileSize(filePath: filePath);
  final mb = (bytes / 1024 / 1024).round();
  return mb;
}
