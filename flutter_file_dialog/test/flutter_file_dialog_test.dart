import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_file_dialog/flutter_file_dialog_platform_interface.dart';
import 'package:flutter_file_dialog/flutter_file_dialog_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFileDialogPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFileDialogPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isPickDirectorySupported() {
    // TODO: implement isPickDirectorySupported
    throw UnimplementedError();
  }

  @override
  Future<DirectoryLocation?> pickDirectory() {
    // TODO: implement pickDirectory
    throw UnimplementedError();
  }

  @override
  Future<String?> pickFile({OpenFileDialogParams? params}) {
    // TODO: implement pickFile
    throw UnimplementedError();
  }

  @override
  Future<String?> saveFile({SaveFileDialogParams? params}) {
    // TODO: implement saveFile
    throw UnimplementedError();
  }

  @override
  Future<String?> saveFileToDirectory({required DirectoryLocation directory, required Uint8List data, required String fileName, String? mimeType, bool replace = false, Future Function()? onFileExists}) {
    // TODO: implement saveFileToDirectory
    throw UnimplementedError();
  }
}

void main() {
  final FlutterFileDialogPlatform initialPlatform = FlutterFileDialogPlatform.instance;

  test('$MethodChannelFlutterFileDialog is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFileDialog>());
  });

  test('getPlatformVersion', () async {
    MockFlutterFileDialogPlatform fakePlatform = MockFlutterFileDialogPlatform();
    FlutterFileDialogPlatform.instance = fakePlatform;

    expect(await FlutterFileDialog.getPlatformVersion(), '42');
  });
}
