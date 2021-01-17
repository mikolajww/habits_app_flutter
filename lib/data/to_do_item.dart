import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'to_do_item.g.dart';

class ToDoItem = _ToDoItem with _$ToDoItem;

abstract class _ToDoItem with Store{

  static DateFormat df = DateFormat("yMMMMd jm");

  @observable
  String name;

  @observable
  String date;

  @observable
  bool isCompleted;

  @computed
  DateTime get getDateTime => df.parse(this.date);

  _ToDoItem(this.name, this.isCompleted, DateTime date) {
    this.date = df.format(date);
  }

}