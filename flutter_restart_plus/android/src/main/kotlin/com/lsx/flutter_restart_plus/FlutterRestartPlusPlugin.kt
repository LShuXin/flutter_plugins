package com.lsx.flutter_restart_plus

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterRestartPlusPlugin */
class FlutterRestartPlusPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  companion object {
    lateinit private var context : Context
    lateinit private var activity : Activity
  }
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_restart_plus")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // context = null
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(flutterPluginBinding: ActivityPluginBinding) {
    activity = flutterPluginBinding.activity
  }

  override fun onReattachedToActivityForConfigChanges(flutterPluginBinding: ActivityPluginBinding) {
    activity = flutterPluginBinding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // activity = null
  }

  // @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun onDetachedFromActivity() {
    // activity = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "restartApp") {
      try {
        val intent = context.packageManager?.getLaunchIntentForPackage(context.packageName)
        intent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        intent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        activity.startActivity(intent)
        result.success(true)
      } catch (e : Exception) {
        result.success(false)
      }
    } else {
      result.notImplemented()
    }
  }

}
