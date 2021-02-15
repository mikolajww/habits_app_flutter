import 'dart:core';

import 'package:Habitect/data/to_do_category.dart';
import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'to_do_service.g.dart';

class ToDoService extends _ToDoService with _$ToDoService {
  static List<ToDoCategory> categories = [
    ToDoCategory("Work", Colors.red),
    ToDoCategory("Personal", Colors.blue),
    ToDoCategory("School", Colors.green),
    ToDoCategory("Medical", Colors.amber),
    ToDoCategory("Leisure", Colors.deepPurpleAccent)
  ];

  ToDoService(GoogleAccountService googleAccountService) : super(googleAccountService);
}

bool isTheSameDay(DateTime first, DateTime other) {
  return first.day == other.day && first.month == other.month && first.year == other.year;
}

abstract class _ToDoService with Store {
  final GoogleAccountService googleAccountService;
  _ToDoService(this.googleAccountService) {}

  @computed
  ObservableList<ToDoItem> get completedTodayTodos =>
      ObservableList.of(todayTodos.where((todo) => todo.isCompleted == true));

  @computed
  double get getPercentCompleteToday => completedTodayTodos.length / todayTodos.length;

  @observable
  ObservableList<ToDoItem> todos = ObservableList();

  @computed
  ObservableMap<DateTime, List> get asEvents {
    Map<DateTime, List> m = Map();
    todos.forEach((element) {
      var key = DateTime(element.date.year, element.date.month, element.date.day);
      if (!m.containsKey(key)) {
        m.putIfAbsent(key, () => null);
        m[key] = [];
      }
      m[key].add(element);
    });
    return ObservableMap.of(m);
  }

  @computed
  ObservableList<ToDoItem> get todayTodos =>
      ObservableList.of(todos.where((todo) => isTheSameDay(todo.date, DateTime.now())));

  @action
  Future<void> addTodo(ToDoItem toDoItem) async {
    todos.add(toDoItem);
    if (toDoItem.doNotify) {
      await Notifications.scheduleNotification(toDoItem.name, toDoItem.description, toDoItem.notificationDate);
    }
  }

  @action
  Future<void> fetchTodos() async {
    var tasks = await googleAccountService.getTasksFromDrive();
    todos = ObservableList.of(tasks);
  }

  @action
  void removeTodo(ToDoItem todo) {
    todos.removeWhere((x) => x == todo);
  }
}
