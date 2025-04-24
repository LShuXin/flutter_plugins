import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'opus_recorder_method_channel.dart';

abstract class OpusRecorderPlatform extends PlatformInterface {
  /// Constructs a OpusRecorderPlatform.
  OpusRecorderPlatform() : super(token: _token);

  static final Object _token = Object();

  static OpusRecorderPlatform _instance = MethodChannelOpusRecorder();

  /// The default instance of [OpusRecorderPlatform] to use.
  ///
  /// Defaults to [MethodChannelOpusRecorder].
  static OpusRecorderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpusRecorderPlatform] when
  /// they register themselves.
  static set instance(OpusRecorderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future startRecord(Map<String, dynamic> params) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future stopRecord() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future playFile(String filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future playFileWithMode(String filePath, int mode) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void registerRef(OpusRecorderRef currentRef) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
