import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'services/google_account_service.dart';

class ToDoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ToDoService toDoService = Provider.of(context);
    final GoogleAccountService googleAccountService = Provider.of(context);
    return Center(
      child: FutureBuilder(
        future: googleAccountService.getUserFileList(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.red),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
    /*return Observer(builder: (_) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return TodoListItem(toDoService.todos[index]);
            },
            itemCount: toDoService.todos.length,
            separatorBuilder: (BuildContext context, int index) {
              return index > 0
                  ? Divider(thickness: 1, indent: 5, endIndent: 5, height: 5)
                  : Container();
            },
          ),
        ),
    );*/
  }
}
