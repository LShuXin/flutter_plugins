import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_restart_plus_method_channel.dart';

abstract class FlutterRestartPlusPlatform extends PlatformInterface {
  /// Constructs a FlutterRestartPlusPlatform.
  FlutterRestartPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterRestartPlusPlatform _instance = MethodChannelFlutterRestartPlus();

  /// The default instance of [FlutterRestartPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterRestartPlus].
  static FlutterRestartPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterRestartPlusPlatform] when
  /// they register themselves.
  static set instance(FlutterRestartPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> restartApp({
    String? iosNotificationTitle,
    String? iosNotificationContent
  }) async {
    throw UnimplementedError('restartApp() has not been implemented.');
  }
}
