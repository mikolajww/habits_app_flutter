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
  ObservableList<ToDoItem> todos =
      ObservableList.of(List.generate(10, (i) {
        var addDays = r.nextInt(10);
        return ToDoItem("${generateWordPairs().take(1)} $i", "${generateWordPairs().take(1)} $i", r.nextBool(), DateTime.now().add(Duration(days: addDays)));
      }) + List.generate(2, (i) => ToDoItem("${generateWordPairs().take(1)} $i", "${generateWordPairs().take(1)} $i", r.nextBool(), DateTime.now())));

  @computed
  ObservableMap<DateTime, List> get asEvents {
    Map<DateTime, List> m = Map();
    todos.forEach((element) {
      if(!m.containsKey(element.getDateTime)){
        m.putIfAbsent(element.getDateTime, () => null);
        m[element.getDateTime] = [];
      }
      m[element.getDateTime].add(element);
    });
    return ObservableMap.of(m);
  }


  @computed
  ObservableList<ToDoItem> get todayTodos =>
      ObservableList.of(todos.where((todo) => isTheSameDay(todo.getDateTime, DateTime.now())));

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
