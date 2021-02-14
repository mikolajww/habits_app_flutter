import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder extends StatefulWidget {
  VoiceRecorder({Key key, @required this.recordingName}) : super(key: key);
  final String recordingName;

  @override
  _VoiceRecorderState createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  FlutterSoundRecorder _Recorder = FlutterSoundRecorder();
  bool _RecorderIsInited = false;
  bool _isRecording = false;
  final String _mPath = 'flutter_sound_example.aac';

  @override
  void initState() {
    openRecorder().then((value) {
      setState(() {
        _RecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _Recorder.closeAudioSession();
    _Recorder = null;
    super.dispose();
  }

  Future<void> openRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _Recorder.openAudioSession();
    _RecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  record() async {
    _Recorder.startRecorder(
      toFile: widget.recordingName,
    ).then((value) {
      setState(() {
        _isRecording = true;
      });
    });
  }

  stopRecorder() async {
    await _Recorder.stopRecorder().then((value) {
      setState(() {
        _isRecording = false;
      });
    });
  }

// ----------------------------- UI --------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(
          Icons.mic,
          color: _isRecording ? Colors.red : null,
        ),
        onPressed: () async {
          setState(() {
            _isRecording = !_isRecording;
          });
          if (!_isRecording) {
            print("recording");
            await record();
          } else {
            print("stopping recording");
            await stopRecorder();
          }
        },
      ),
    );
  }
}
