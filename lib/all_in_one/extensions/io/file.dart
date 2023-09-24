import 'dart:io';

extension FileX on File {
  bool notExistsSync() {
    return !existsSync();
  }
}