import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'to_do_item.g.dart';

class ToDoItem = _ToDoItem with _$ToDoItem;

abstract class _ToDoItem with Store{

  static DateFormat df = DateFormat("yMMMMd jm");

  @observable
  String name;

  @observable
  String description;

  @observable
  DateTime date;

  @observable
  bool isCompleted;

  _ToDoItem(this.name, this.description, this.isCompleted, DateTime date) {
    this.date = date;
  }
}