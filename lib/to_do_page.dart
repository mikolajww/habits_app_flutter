import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ToDoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ToDoService toDoService = Provider.of(context);
    return Observer(builder: (_) =>
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return TodoListItem(toDoService.todos[index]);
            },
            itemCount: toDoService.todos.length, // +1 for the header
            separatorBuilder: (BuildContext context, int index) {
              return index > 0
                  ? Divider(thickness: 1, indent: 5, endIndent: 5, height: 5)
                  : Container();
            },
          ),
        ),
    );
  }
}
