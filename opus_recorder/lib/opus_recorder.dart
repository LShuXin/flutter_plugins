import 'opus_recorder_method_channel.dart';
import 'opus_recorder_platform_interface.dart';

class OpusRecorder {
  static Future<String?> getPlatformVersion() {
    return OpusRecorderPlatform.instance.getPlatformVersion();
  }

  static Future startRecord(String savePath, int maxDurationSec) async {
    return OpusRecorderPlatform.instance.startRecord({
      'savePath': savePath,
      'maxDurationSec': maxDurationSec
    });
  }

  static Future stopRecord() async {
    return OpusRecorderPlatform.instance.stopRecord();
  }

  static Future playFile(String filePath) async {
    return OpusRecorderPlatform.instance.playFile(filePath);
  }

  static Future playFileWithMode(String filePath, int mode) {
    return OpusRecorderPlatform.instance.playFileWithMode(filePath, mode);
  }

  static void registerRef(OpusRecorderRef currentRef) {
    OpusRecorderPlatform.instance.registerRef(currentRef);
  }

}
