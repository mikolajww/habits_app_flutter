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

}
