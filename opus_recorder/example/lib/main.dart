import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:opus_recorder/opus_recorder.dart';
import 'package:opus_recorder/opus_recorder_method_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class RecordInfo {
  final String filePath;
  final String time;

  RecordInfo(this.filePath,this.time);

}

class _MyAppState extends State<MyApp> implements OpusRecorderRef {

  List<RecordInfo> infos = [];

  @override
  void initState() {
    super.initState();
    OpusRecorder.registerRef(this);
  }


  @override
  void onRecordFinished(String filePath, String time) {
    // currently not work
    setState(() {
      infos.add(RecordInfo(filePath, time));
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: infos.length,
            itemBuilder: (BuildContext context, int index) {
              RecordInfo info = infos[index];
              return GestureDetector(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '【Path】: ${info.filePath} \n【Duration】: ${info.time}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  OpusRecorder.playFile(info.filePath);
                },
              );
            }
          ),
        ),
        floatingActionButton: GestureDetector(
          onLongPressStart: (LongPressStartDetails details) async {
            debugPrint("onLongPressStart");
            var hasPermission = await _requestMicrophonePermission();
            if (!hasPermission) {
              debugPrint('权限不足');
              return;
            }
            var savePath = await _getAudioSaveFilePath();
            if (savePath.isEmpty) {
              debugPrint('获取存储目录失败');
              return;
            }
            debugPrint('开始录音...');
            var res = await OpusRecorder.startRecord(savePath, 60);
            debugPrint('是否开始录制： $res');
          },
          onLongPressEnd: (LongPressEndDetails details) async {
            debugPrint("onLongPressEnd");
            List res = await OpusRecorder.stopRecord();
            setState(() {
              infos.add(RecordInfo(res[0].toString(), res[1].toString()));
            });
            print('录制结果');
            print(res);
          },
          child: FloatingActionButton(
            onPressed: () {  },
            child:Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestMicrophonePermission() async {
    // Check if microphone permission is already granted
    if (await Permission.microphone.isGranted) {
      return true; // Permission already granted
    }

    // Check if permission is permanently denied (user selected 'Don't ask again')
    if (await Permission.microphone.isPermanentlyDenied) {
      return false; // Permission permanently denied, no need to ask again
    }

    // Request microphone permission
    var status = await Permission.microphone.request();

    // Return whether the permission was granted or not
    return status.isGranted;
  }

  Future<String> _getAudioSaveFilePath() async {
    try {
      // Get the documents directory path
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Create the path for the 'saved_audios' folder
      final Directory savedAudiosDirectory = Directory('${documentsDirectory.path}/saved_audios');

      // Check if the directory exists, and create it if it doesn't
      if (!(await savedAudiosDirectory.exists())) {
        await savedAudiosDirectory.create(recursive: true);  // Create the directory if it doesn't exist
        debugPrint('Created saved_audios directory at: ${savedAudiosDirectory.path}');
      }

      // Generate a unique filename based on the current timestamp
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = "$timestamp.audio";

      // Create the full file path
      final File audioFile = File('${savedAudiosDirectory.path}/$fileName');
      // Return the full path of the audio file
      return audioFile.path;
    } catch (e) {
      debugPrint("Error getting or creating the saved_audios directory: $e");
      return '';
    }
  }
}
