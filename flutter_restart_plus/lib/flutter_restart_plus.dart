import 'flutter_restart_plus_platform_interface.dart';

class FlutterRestartPlus {
  Future<String?> getPlatformVersion() {
    return FlutterRestartPlusPlatform.instance.getPlatformVersion();
  }
  Future<bool?> restartApp({
    String? iosNotificationTitle,
    String? iosNotificationContent
  }) {
    return FlutterRestartPlusPlatform.instance.restartApp(
      iosNotificationTitle: iosNotificationTitle,
      iosNotificationContent: iosNotificationContent
    );
  }
}
