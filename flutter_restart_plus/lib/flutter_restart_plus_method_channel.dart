import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_restart_plus_platform_interface.dart';

/// An implementation of [FlutterRestartPlusPlatform] that uses method channels.
class MethodChannelFlutterRestartPlus extends FlutterRestartPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_restart_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion', {});
    return version;
  }

  @override
  Future<bool?> restartApp({
    String? iosNotificationTitle,
    String? iosNotificationContent
  }) async {
    final success = await methodChannel.invokeMethod<bool>('restartApp', {
      'iosNotificationTitle': iosNotificationTitle,
      'iosNotificationContent': iosNotificationContent
    });
    return success;
  }
}
