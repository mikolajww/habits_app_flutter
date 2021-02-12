import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/to_do_service.dart';
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
    final ToDoService toDoService = Provider.of(context);
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
                  FlatButton(onPressed: () => Navigator.of(context).pop(true), textColor: Colors.red, child: const Text("DELETE")),
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
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          this.todo.isCompleted = true;
        } else if (direction == DismissDirection.endToStart) {
          toDoService.removeTodo(this.todo);
        }
      },
      child: Observer(
        builder: (_) => CheckboxListTile(
          tileColor: Color(0xff2e2e2e),
          activeColor: Colors.green,
          value: todo.isCompleted,
          title: Text(todo.name),
          subtitle: Text(todo.description),
          secondary: Column(
            children: [
              Text(
                DateFormat('kk:mm').format(todo.date),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          onChanged: (newValue) {
            todo.isCompleted = newValue;
          },
        ),
      ),
    );
  }
}
