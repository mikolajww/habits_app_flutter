import 'dart:core';
import 'dart:math';

import 'package:Habitect/data/to_do_item.dart';
import 'package:mobx/mobx.dart';

import 'package:english_words/english_words.dart';

part 'to_do_service.g.dart';

class ToDoService = _ToDoService with _$ToDoService;

bool isTheSameDay(DateTime first, DateTime other) {
  return first.day == other.day && first.month == other.month && first.year == other.year;
}

abstract class _ToDoService with Store {
  static Random r = Random();

  static List<String> defaultCategories = ["Work", "Personal"];

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
      if(!m.containsKey(key)){
        m.putIfAbsent(key, () => null);
        m[key] = [];
      }
      m[key].add(element);
    });
    print(m);
    return ObservableMap.of(m);
  }

  @computed
  ObservableList<ToDoItem> get todayTodos =>
      ObservableList.of(todos.where((todo) => isTheSameDay(todo.date, DateTime.now())));

  @action
  void addTodo(String title, String description, bool isCompleted, DateTime dateTime) {
    todos.add(ToDoItem(title, description, isCompleted, dateTime));
    print(todos);
  }

  @action
  void removeTodo(ToDoItem todo) {
    todos.removeWhere((x) => x == todo);
  }
}
