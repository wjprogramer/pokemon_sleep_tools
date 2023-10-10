import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileUtility {
  FileUtility._();

  static Future<File?> pickSingleFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    final filePath = result?.files.firstOrNull?.path;
    return filePath != null ? File(filePath) : null;
  }

}