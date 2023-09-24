import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MyLocalStorage {

  late Directory _parent;

  Future<void> init() async {
    _parent = await getApplicationSupportDirectory();
  }

  // region Meta
  String get _metaFilePath {
    return path.join(_parent.path, 'meta.json');
  }

  Future<String?> readRawMetaFile() async {
    final file = File(_metaFilePath);
    file.readAsStringSync();
  }

  Future writeMetaFile(String value) async {

  }
  // endregion Meta

}