// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_item.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ToDoItem on _ToDoItem, Store {
  Computed<DateTime> _$getDateTimeComputed;

  @override
  DateTime get getDateTime =>
      (_$getDateTimeComputed ??= Computed<DateTime>(() => super.getDateTime,
              name: '_ToDoItem.getDateTime'))
          .value;

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

  final _$dateAtom = Atom(name: '_ToDoItem.date');

  @override
  String get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(String value) {
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

  @override
  String toString() {
    return '''
name: ${name},
date: ${date},
isCompleted: ${isCompleted},
getDateTime: ${getDateTime}
    ''';
  }
}
