package com.lsx.opus_recorder;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.AudioManager;
import android.os.Build;
// import android.support.v4.app.ActivityCompat
import androidx.core.app.ActivityCompat;
//import android.support.v4.content.ContextCompat
import androidx.core.content.ContextCompat;

import android.util.Log;

import androidx.annotation.NonNull;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** OpusRecorderPlugin */
public class OpusRecorderPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static final int REQUEST_EXTERNAL_STORAGE = 1;
  private static String[] PERMISSIONS_STORAGE = {
    Manifest.permission.READ_EXTERNAL_STORAGE,
    Manifest.permission.WRITE_EXTERNAL_STORAGE,
  };
  private static final int MODE_NORMAL = 1;
  private static final int MODE_IN_CALL = 2;
  AudioPlayerHandler audioPlayerHandler;
  private String savePath = null;
  private Integer maxDurationSec = null;
  private AudioRecordHandler currentAudioRecordHandler = null;
  private Context applicationContext;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    applicationContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "opus_recorder");
    channel.setMethodCallHandler(this);
    audioPlayerHandler = AudioPlayerHandler.getInstance();
    audioPlayerHandler.setAudioMode(AudioManager.MODE_NORMAL, applicationContext);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if ("startRecord".equals(call.method)) {
      boolean permission = isMicPermissionGranted(activity);
      if (!permission) {
        result.success(false);
        return;
      }
      Map<String, Object> params = call.arguments();
      savePath = (String) params.get("savePath");
      maxDurationSec = (Integer) params.get("maxDurationSec");

      if (currentAudioRecordHandler != null) {
        currentAudioRecordHandler.setRecording(false);
      }

      currentAudioRecordHandler = new AudioRecordHandler(savePath);
      currentAudioRecordHandler.setRecording(true);
      new Thread(currentAudioRecordHandler).start();
      result.success(true);
    } else if ("stopRecord".equals(call.method)) {
      if (currentAudioRecordHandler != null) {
        currentAudioRecordHandler.setRecording(false);
        List<Object> arguments = new ArrayList<>();
        arguments.add(savePath);
        arguments.add(Double.valueOf(currentAudioRecordHandler.getRecordTime()).toString());
        channel.invokeMethod("finishedRecord", arguments);
        result.success(arguments);
      }
    } else if ("playFile".equals(call.method)) {
      if (audioPlayerHandler != null) {
        List<Object> arguments = (List<Object>) call.arguments;
        Log.i("OpusRecorder", "play:" + arguments.get(0).toString());
        audioPlayerHandler.startPlay(arguments.get(0).toString());
      }
    } else if ("playFileWithMode".equals(call.method)) {
      List<Object> arguments = (List<Object>) call.arguments;
      if (audioPlayerHandler != null && arguments.size() == 2) {
        // List<Object> arguments = (List<Object>) call.arguments;
        String path = arguments.get(0).toString();
        Log.i("OpusRecorder", "play:" + arguments.get(0).toString());
        int mode = (int) arguments.get(1);
        if (mode == MODE_IN_CALL) {
          mode = AudioManager.MODE_IN_CALL;
        } else {
          mode = AudioManager.MODE_NORMAL;
        }
        audioPlayerHandler.setAudioMode(mode, applicationContext);
        audioPlayerHandler.startPlay(path);
      } else {
        Log.i("OpusRecorder", "play fail for:" + call.toString());
        result.notImplemented();
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    applicationContext = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  public static boolean isMicPermissionGranted(Activity activity) {
    try {
      // Check if the app is running on Android M (API level 23) or higher
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        // Check if the microphone permission is granted
        boolean microphonePermissionGranted = hasPermission(activity, Manifest.permission.RECORD_AUDIO);

        // Return the result of microphone permission check
        return microphonePermissionGranted;
      }
    } catch (Exception e) {
      Log.e("PermissionCheck", "Error verifying microphone permission", e);
    }

    // Return true if running on Android versions lower than M, where permissions are automatically granted
    return true;
  }

  // Helper method to check if a specific permission is granted
  private static boolean hasPermission(Activity activity, String permission) {
    return ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED;
  }



}
