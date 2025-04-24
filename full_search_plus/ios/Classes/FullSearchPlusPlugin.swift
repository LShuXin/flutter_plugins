import Flutter
import UIKit

public class FullSearchPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "full_search_plus", binaryMessenger: registrar.messenger())
    let instance = FullSearchPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

    public static func dummyMethodToEnforceBundling() {
      last_error_length()
      // error_message_utf8("", 0)
      se_delete_by_str(0, "", "")
      se_delete_by_u64(0, "",0)
      se_exists(0)
      se_get_by_i64(0, "", 0)
      se_get_by_u64(0, "", 0)
      se_index(0, "")
      se_open_or_create("", "")
      se_search(0, "", "", 0, 0)
      se_update_by_str(0, "", "", "")
      se_update_by_u64(0, "", 0, "")

      let  tmp:DartPostCObjectFnPtr = { (DartPort, DartCObject) -> Bool in
          return false
      }

      store_dart_post_cobject(tmp)
    }
}
