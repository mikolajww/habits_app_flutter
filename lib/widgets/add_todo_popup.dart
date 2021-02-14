import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/styles/app_styles.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTodoDialog extends StatefulWidget {
  AddTodoDialog({Key key}) : super(key: key);

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  DateTime selectedDate = DateTime.now();
  String title;
  String description;
  final List<String> categories = ["Work", "School", "Personal"];
  String selectedCategory = "Work";

  @override
  Widget build(BuildContext context) {

    final ToDoService toDoService = Provider.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.green.shade800,
      child: Container(
        height: 450,
        padding: EdgeInsets.fromLTRB(32, 20, 32, 16),
        child: Column(
          children: [
            Text(
              "Add a new item",
              style: AppStyles.MED_ROBOTO,
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Task name", border: OutlineInputBorder()),
              onChanged: (text) {
                setState(() {
                  title = text;
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: "Task description", border: OutlineInputBorder()),
              onChanged: (text) {
                setState(() {
                  description = text;
                });
              },
            ),
            SizedBox(
              height: 16,
            ),
            DateTimeField(
              dateTextStyle: TextStyle(fontSize: 18),
              dateFormat: DateFormat("d/M/y H:m"),
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              selectedDate: selectedDate,
            ),
            DropdownButton<String>(
              items: categories.map((String e) {
                return DropdownMenuItem<String>(child: Text(e), value: e,);
              }).toList(),
              onChanged: (_) {},
            ),
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
                  onPressed: () {
                    toDoService.addTodo(title, description, false, selectedDate);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("ADD"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*
* title: const Text("Add Item"),
      content: Column(

      ),
      actions: [

      ],*/
