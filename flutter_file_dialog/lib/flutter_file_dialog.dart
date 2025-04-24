import 'dart:typed_data';
import 'flutter_file_dialog_platform_interface.dart';

class FlutterFileDialog {
  static Future<String?> getPlatformVersion() {
    return FlutterFileDialogPlatform.instance.getPlatformVersion();
  }

  static Future<String?> pickFile({OpenFileDialogParams? params}) {
    return FlutterFileDialogPlatform.instance.pickFile(params: params);
  }

  static Future<DirectoryLocation?> pickDirectory() async {
    return FlutterFileDialogPlatform.instance.pickDirectory();
  }

  static Future<bool> isPickDirectorySupported() async {
    return FlutterFileDialogPlatform.instance.isPickDirectorySupported();
  }

  static Future<String?> saveFile({SaveFileDialogParams? params}) {
    return FlutterFileDialogPlatform.instance.saveFile(params: params);
  }

  static Future<String?> saveFileToDirectory({
    required DirectoryLocation directory,
    required Uint8List data,
    required String fileName,
    String? mimeType,
    bool replace = false,
    Future Function()? onFileExists,
  }) async {
    return FlutterFileDialogPlatform.instance.saveFileToDirectory(
      directory: directory,
      data: data,
      fileName: fileName,
      mimeType: mimeType,
      replace: replace,
      onFileExists: onFileExists
    );
  }
}
