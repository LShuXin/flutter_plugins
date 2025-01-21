import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_file_dialog_platform_interface.dart';

/// An implementation of [FlutterFileDialogPlatform] that uses method channels.
class MethodChannelFlutterFileDialog extends FlutterFileDialogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_dialog');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> pickFile({OpenFileDialogParams? params}) {
    return methodChannel.invokeMethod('pickFile', params?.toJson());
  }

  @override
  Future<DirectoryLocation?> pickDirectory() async {
    final String? uriString = await methodChannel.invokeMethod('pickDirectory');
    if (uriString == null) return null;
    return DirectoryLocation(uriString);
  }

  @override
  Future<bool> isPickDirectorySupported() async {
    return (await methodChannel.invokeMethod<bool>('isPickDirectorySupported'))!;
  }

  @override
  Future<String?> saveFile({SaveFileDialogParams? params}) {
    return methodChannel.invokeMethod('saveFile', params?.toJson());
  }

  @override
  Future<String?> saveFileToDirectory({
    required DirectoryLocation directory,
    required Uint8List data,
    required String fileName,
    String? mimeType,
    bool replace = false,
    Future Function()? onFileExists,
  }) async {
    try {
      return await methodChannel.invokeMethod('saveFileToDirectory', {
        'directory': directory.rawUri,
        'data': data,
        'fileName': fileName,
        'mimeType': mimeType,
        'replace': replace,
      });
    } on PlatformException catch (e) {
      if (e.code == 'file_already_exists') {
        if (onFileExists != null) await onFileExists();
        return null;
      }

      rethrow;
    }
  }
}
