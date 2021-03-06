import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/widgets/todo_details_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoListItem extends StatelessWidget {
  ToDoItem todo;
  TodoListItem(this.todo);
  @override
  Widget build(BuildContext context) {
    final description = todo.description;
    var descriptionLines;
    if (description != null) {
      descriptionLines = description.split('\n');
    }
    final ToDoService toDoService = Provider.of(context);
    final GoogleAccountService googleAccountService = Provider.of(context);
    return Dismissible(
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Are you sure you wish to delete this item?"),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      textColor: Colors.red,
                      child: const Text("DELETE")),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        }
        return true;
      },
      key: UniqueKey(),
      background: Container(),
      secondaryBackground: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          this.todo.isCompleted = true;
        } else if (direction == DismissDirection.endToStart) {
          toDoService.removeTodo(this.todo);
          await googleAccountService.updateFile(toDoService.todos);
        }
      },
      child: Observer(builder: (_) {
        return Container(
          height: 88,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Time + category
                SizedBox(
                  width: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('kk:mm').format(todo.date),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(todo.category.name),
                        ),
                        decoration: BoxDecoration(
                          color: todo.category.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
                //Title + description
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TodoDetailsDialog(todo: todo);
                      },
                    );
                  },
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: RichText(
                              text: TextSpan(style: TextStyle(fontSize: 20), children: [
                                TextSpan(
                                  text: todo.name + "  ",
                                ),
                                if (todo.recordingPath != null)
                                  WidgetSpan(
                                    child: Icon(Icons.headset, size: 20),
                                  ),
                              ]),
                            )),
                        Flexible(
                          child: description != null
                              ? Text(
                                  descriptionLines.length > 2
                                      ? descriptionLines.sublist(0, 2).join("\n") + "..."
                                      : descriptionLines.join("\n"),
                                  maxLines: 2,
                                )
                              : Container(height: 0, width: 0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width: 50,
                    child: todo.doNotify
                        ? RichText(
                            text: TextSpan(style: TextStyle(fontSize: 12), children: [
                              WidgetSpan(
                                child: Icon(Icons.alarm, size: 20),
                              ),
                              TextSpan(
                                text: DateFormat('kk:mm').format(todo.notificationDate),
                              ),
                            ]),
                          )
                        : null),
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (newVal) async {
                    todo.isCompleted = newVal;
                    await toDoService.sync();
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
