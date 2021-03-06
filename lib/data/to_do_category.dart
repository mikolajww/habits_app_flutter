import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'to_do_category.g.dart';

class ToDoCategory = _ToDoCategory with _$ToDoCategory;

abstract class _ToDoCategory with Store {
  @observable
  String name = "";

  @observable
  Color color = Colors.red;

  _ToDoCategory(this.name, this.color);

  _ToDoCategory.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        color = Color(json['color']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color.value,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _ToDoCategory && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
