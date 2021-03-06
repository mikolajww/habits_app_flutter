// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_item.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ToDoItem on _ToDoItem, Store {
  final _$nameAtom = Atom(name: '_ToDoItem.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_ToDoItem.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$dateAtom = Atom(name: '_ToDoItem.date');

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  final _$isCompletedAtom = Atom(name: '_ToDoItem.isCompleted');

  @override
  bool get isCompleted {
    _$isCompletedAtom.reportRead();
    return super.isCompleted;
  }

  @override
  set isCompleted(bool value) {
    _$isCompletedAtom.reportWrite(value, super.isCompleted, () {
      super.isCompleted = value;
    });
  }

  final _$categoryAtom = Atom(name: '_ToDoItem.category');

  @override
  ToDoCategory get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(ToDoCategory value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  @override
  String toString() {
    return '''
name: ${name},
description: ${description},
date: ${date},
isCompleted: ${isCompleted},
category: ${category}
    ''';
  }
}
