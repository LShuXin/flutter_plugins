import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_restart_plus/flutter_restart_plus.dart';
import 'package:flutter_restart_plus/flutter_restart_plus_platform_interface.dart';
import 'package:flutter_restart_plus/flutter_restart_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterRestartPlusPlatform
    with MockPlatformInterfaceMixin
    implements FlutterRestartPlusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterRestartPlusPlatform initialPlatform = FlutterRestartPlusPlatform.instance;

  test('$MethodChannelFlutterRestartPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRestartPlus>());
  });

  test('getPlatformVersion', () async {
    FlutterRestartPlus flutterRestartPlusPlugin = FlutterRestartPlus();
    MockFlutterRestartPlusPlatform fakePlatform = MockFlutterRestartPlusPlatform();
    FlutterRestartPlusPlatform.instance = fakePlatform;

    expect(await flutterRestartPlusPlugin.getPlatformVersion(), '42');
  });
}
