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

  String recordingPath;

  _ToDoItem(this.name, this.description, this.isCompleted, this.date, this.category,
      {bool doNotify, DateTime notificationDate, String recordingPath}) {
    this.doNotify = doNotify ?? false;
    this.notificationDate = notificationDate;
    this.recordingPath = recordingPath;
  }

  _ToDoItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        date = DateTime.parse(json['date']),
        isCompleted = json['isCompleted'],
        category = ToDoCategory.fromJson(json['category']),
        doNotify = json['doNotify'],
        notificationDate = DateTime.parse(json['notificationDate']),
        recordingPath = json['recordingPath'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted,
        'category': category.toJson(),
        'doNotify': doNotify,
        'notificationDate': notificationDate.toIso8601String(),
        'recordingPath': recordingPath
      };
}
