import 'package:Habitect/data/to_do_category.dart';
import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/styles/app_styles.dart';
import 'package:Habitect/widgets/voice_recorder.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoDialog extends StatefulWidget {
  AddTodoDialog({Key key}) : super(key: key);

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  DateTime selectedDate = DateTime.now();
  String title;
  String description;
  ToDoCategory selectedCategory = ToDoService.categories[0];
  bool doNotify = false;
  DateTime notificationDate = DateTime.now();
  final uuid = Uuid();
  var randomId;
  bool recordingPressed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    randomId = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    final ToDoService toDoService = Provider.of(context);

    final GoogleAccountService googleAccountService = Provider.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Color(0xff2e2e2e),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            height: doNotify ? 630 : 590,
            padding: EdgeInsets.fromLTRB(32, 20, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add a new item",
                  style: AppStyles.MED_ROBOTO,
                ),
                SizedBox(height: 32),
                _buildTextField(),
                SizedBox(height: 16),
                _buildDescriptionField(),
                SizedBox(height: 16),
                DateTimeField(
                  dateTextStyle: TextStyle(fontSize: 18),
                  dateFormat: DateFormat("d/MM/y HH:mm"),
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  selectedDate: selectedDate,
                ),
                SizedBox(height: 16),
                _buildCategorySelector(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Set notification"),
                    Checkbox(value: doNotify, onChanged: (newVal) => setState(() => doNotify = newVal)),
                  ],
                ),
                if (doNotify)
                  DateTimeField(
                    dateTextStyle: TextStyle(fontSize: 18),
                    dateFormat: DateFormat("d/MM/y HH:mm"),
                    onDateSelected: (date) {
                      setState(() {
                        notificationDate = date;
                      });
                    },
                    selectedDate: notificationDate,
                  ),
                VoiceRecorder(
                    recordingName: randomId + ".aac",
                    f: () => setState(() {
                          recordingPressed = true;
                        })),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      color: Colors.red,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    ),
                    RaisedButton(
                      color: Colors.green,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await toDoService.addTodo(ToDoItem(title, description, false, selectedDate, selectedCategory,
                              doNotify: doNotify,
                              notificationDate: notificationDate,
                              recordingPath: recordingPressed ? randomId + ".aac" : null));
                          await googleAccountService.updateFile(toDoService.todos);
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: const Text("ADD"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Category:"),
        DropdownButton<ToDoCategory>(
          value: selectedCategory,
          hint: Text("Category"),
          selectedItemBuilder: (context) {
            return ToDoService.categories.map((ToDoCategory c) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(c.name),
                ],
              );
            }).toList();
          },
          items: ToDoService.categories.map((ToDoCategory c) {
            return DropdownMenuItem<ToDoCategory>(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(c.name),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                ],
              ),
              value: c,
            );
          }).toList(),
          onChanged: (ToDoCategory newItem) {
            setState(() {
              selectedCategory = newItem;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      minLines: 2,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: "Task description",
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      ),
      onChanged: (text) {
        setState(() {
          description = text;
        });
      },
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "Please name your task";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Task name",
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      ),
      onChanged: (text) {
        setState(() {
          title = text;
        });
      },
    );
  }
}
