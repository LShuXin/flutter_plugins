import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'opus_recorder_platform_interface.dart';

abstract class OpusRecorderRef {
  void onRecordFinished(String filePath, String time);
}

/// An implementation of [OpusRecorderPlatform] that uses method channels.
class MethodChannelOpusRecorder extends OpusRecorderPlatform {
  static const int MODE_NORMAL = 1;
  static const int MODE_IN_CALL = 2;

  OpusRecorderRef? currentRef;

  /// The method channel used to interact with the native platform.
  // @visibleForTesting
  final methodChannel = const MethodChannel('opus_recorder');

  MethodChannelOpusRecorder() {
    methodChannel.setMethodCallHandler((MethodCall methodCall) {
      print('原生调用...');
      if ('finishedRecord' == methodCall.method) {
        if (null == currentRef) {
          currentRef!.onRecordFinished(
            methodCall.arguments[0],
            methodCall.arguments[1],
          );
        }
      }
      return Future.value(methodCall.method);
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    return await methodChannel.invokeMethod<String>('getPlatformVersion');
  }

  @override
  Future startRecord(Map<String, dynamic> params) async {
    return methodChannel.invokeMethod('startRecord', params);
  }

  @override
  Future stopRecord() async {
    return methodChannel.invokeMethod('stopRecord');
  }

  @override
  Future playFile(String filePath) async {
    return methodChannel.invokeMethod('playFile',[filePath]);
  }

  @override
  Future playFileWithMode(String filePath, int mode) {
    return methodChannel.invokeMethod('playFileWithMode',[filePath,mode]);
  }

  @override
  void registerRef(OpusRecorderRef currentRef) {
    this.currentRef = currentRef;
  }

}
