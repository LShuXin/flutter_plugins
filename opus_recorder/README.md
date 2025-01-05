# opus_recorder

Opus media record、play

## Getting Started

**The plugin is currently work on Android**

When encountering the following error on Android platform：
```agsl
/opus_recorder/example/android/app/src/debug/AndroidManifest.xml Error:
	Attribute application@label value=(opus_recorder_example) from (unknown)
	is also present at [opuslib-1.0.2.aar] AndroidManifest.xml:13:9-41 value=(@string/app_name).
	Suggestion: add 'tools:replace="android:label"' to <application> element at AndroidManifest.xml to override.
```

you should:
**first**
add `xmlns:tools="http://schemas.android.com/tools"` to your `<manifest>`
**then**
add `tools:replace="label"` to your `<application>`


### Record
```
// you should grant microphone permission at in advance
var res = await OpusRecorder.stopRecord('savePath', 60 /* max duration */);
// savePath
print(res[0]);
/// record duration
print(res[1]);
```

### Play
```
await OpusRecorder.playFile('filePath');
```


## Permissions
Android
```
 <uses-permission android:name="android.permission.RECORD_AUDIO"/>
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
 <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

IOS
```
<key>NSMicrophoneUsageDescription</key>
<string>need microphone access to record</string>
```

## Notes
>When developing a native Android project, you can add an .aar file to android/app/libs/opuslib-1.0.2.aar and declare it in android/app/build.gradle with implementation fileTree(dir: 'libs', include: ['*.jar', '*.aar']) to use it as a dependency. However, this approach does not work in a plugin project, because "Direct local .aar file dependencies are not supported when building an AAR. The resulting AAR would be broken because the classes and Android resources from any local .aar file dependencies would not be packaged in the resulting AAR."
In other words, while local .aar files can be directly referenced in an Android app project, they cannot be directly referenced in an Android library project.
For plugin projects, you must either reference Maven packages hosted in a repository (not .aar files) or reference Maven packages hosted on GitHub.

