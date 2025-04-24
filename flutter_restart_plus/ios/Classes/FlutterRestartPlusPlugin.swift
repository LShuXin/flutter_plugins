import Flutter
import UIKit

public class FlutterRestartPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_restart_plus", binaryMessenger: registrar.messenger())
    let instance = FlutterRestartPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "restartApp":
      scheduleLocalNotification(call.arguments as? [String: String])
      exitApp()
      result(nil)
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // 发送本地通知
  private func scheduleLocalNotification(_ params: [String: String]?) {
      let content = UNMutableNotificationContent()
      content.title = params?["iosNotificationTitle"] ?? "App Restarted"
      content.body = params?["iosNotificationContent"] ?? "Tap here to reopen the app."
      content.sound = UNNotificationSound.default

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      let request = UNNotificationRequest(identifier: "restartNotification", content: content, trigger: trigger)

      UNUserNotificationCenter.current().add(request) { error in
          if let error = error {
              print("Failed to schedule notification: \(error)")
          }
      }
  }

  private func exitApp() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          exit(0)
      }
  }
}
