import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder extends StatefulWidget {
  VoiceRecorder({Key key, @required this.recordingName, this.f}) : super(key: key);
  final String recordingName;
  final Function f;

  @override
  _VoiceRecorderState createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;

  Future<void> openRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _recorder.openAudioSession();
  }

  record() async {
    _recorder.startRecorder(
      toFile: widget.recordingName,
    );
  }

  stopRecorder() async {
    await _recorder.stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              Icons.mic,
              color: _isRecording ? Colors.red : null,
            ),
            onPressed: () async {
              widget.f();
              setState(() {
                _isRecording = !_isRecording;
              });
              if (_isRecording) {
                await openRecorder();
                await record();
              } else {
                await stopRecorder();
                await _recorder.closeAudioSession();
              }
            },
          ),
          Text(_isRecording ? "Recording..." : "Tap to record")
        ],
      ),
    );
  }
}
