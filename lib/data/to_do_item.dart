import 'package:Habitect/data/to_do_category.dart';
import 'package:mobx/mobx.dart';

part 'to_do_item.g.dart';

class ToDoItem = _ToDoItem with _$ToDoItem;

abstract class _ToDoItem with Store {
  @observable
  String name;

  @observable
  String description;

  @observable
  DateTime date;

  @observable
  bool isCompleted;

  @observable
  ToDoCategory category;

  bool doNotify;
  DateTime notificationDate;

  _ToDoItem(this.name, this.description, this.isCompleted, this.date, this.category,
      {bool doNotify, DateTime notificationDate}) {
    this.doNotify = doNotify ?? false;
    this.notificationDate = notificationDate;
  }
}
