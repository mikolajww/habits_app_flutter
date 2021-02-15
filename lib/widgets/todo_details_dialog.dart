import 'package:Habitect/data/to_do_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/ui/sound_player_ui.dart';

class TodoDetailsDialog extends StatefulWidget {
  TodoDetailsDialog({Key key, @required this.todo}) : super(key: key);
  final ToDoItem todo;
  @override
  _TodoDetailsDialogState createState() => _TodoDetailsDialogState();
}

class _TodoDetailsDialogState extends State<TodoDetailsDialog> {
  bool recordingExpanded = false;
  var playerStateKey = GlobalKey<_TodoDetailsDialogState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Task Description"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.todo.description),
          SizedBox(height: 50),
          if (widget.todo.recordingPath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Listen to recording"),
                  IconButton(
                    icon: Icon(Icons.headset),
                    onPressed: () {
                      setState(() {
                        recordingExpanded = !recordingExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          if (recordingExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SoundPlayerUI.fromLoader(
                (context) async {
                  return Track(trackPath: widget.todo.recordingPath, codec: Codec.defaultCodec);
                },
                backgroundColor: Color(0xff2e2e2e),
              ),
            ),
        ],
      ),
    );
  }
}
