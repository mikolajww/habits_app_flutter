// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ToDoService on _ToDoService, Store {
  Computed<ObservableList<ToDoItem>> _$completedTodayTodosComputed;

  @override
  ObservableList<ToDoItem> get completedTodayTodos =>
      (_$completedTodayTodosComputed ??= Computed<ObservableList<ToDoItem>>(
              () => super.completedTodayTodos,
              name: '_ToDoService.completedTodayTodos'))
          .value;
  Computed<double> _$getPercentCompleteTodayComputed;

  @override
  double get getPercentCompleteToday => (_$getPercentCompleteTodayComputed ??=
          Computed<double>(() => super.getPercentCompleteToday,
              name: '_ToDoService.getPercentCompleteToday'))
      .value;
  Computed<ObservableMap<DateTime, List<dynamic>>> _$asEventsComputed;

  @override
  ObservableMap<DateTime, List<dynamic>> get asEvents => (_$asEventsComputed ??=
          Computed<ObservableMap<DateTime, List<dynamic>>>(() => super.asEvents,
              name: '_ToDoService.asEvents'))
      .value;
  Computed<ObservableList<ToDoItem>> _$todayTodosComputed;

  @override
  ObservableList<ToDoItem> get todayTodos => (_$todayTodosComputed ??=
          Computed<ObservableList<ToDoItem>>(() => super.todayTodos,
              name: '_ToDoService.todayTodos'))
      .value;

  final _$todosAtom = Atom(name: '_ToDoService.todos');

  @override
  ObservableList<ToDoItem> get todos {
    _$todosAtom.reportRead();
    return super.todos;
  }

  @override
  set todos(ObservableList<ToDoItem> value) {
    _$todosAtom.reportWrite(value, super.todos, () {
      super.todos = value;
    });
  }

  final _$syncAsyncAction = AsyncAction('_ToDoService.sync');

  @override
  Future<void> sync() {
    return _$syncAsyncAction.run(() => super.sync());
  }

  final _$addTodoAsyncAction = AsyncAction('_ToDoService.addTodo');

  @override
  Future<void> addTodo(ToDoItem toDoItem) {
    return _$addTodoAsyncAction.run(() => super.addTodo(toDoItem));
  }

  final _$fetchTodosAsyncAction = AsyncAction('_ToDoService.fetchTodos');

  @override
  Future<void> fetchTodos() {
    return _$fetchTodosAsyncAction.run(() => super.fetchTodos());
  }

  final _$_ToDoServiceActionController = ActionController(name: '_ToDoService');

  @override
  void removeTodo(ToDoItem todo) {
    final _$actionInfo = _$_ToDoServiceActionController.startAction(
        name: '_ToDoService.removeTodo');
    try {
      return super.removeTodo(todo);
    } finally {
      _$_ToDoServiceActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
todos: ${todos},
completedTodayTodos: ${completedTodayTodos},
getPercentCompleteToday: ${getPercentCompleteToday},
asEvents: ${asEvents},
todayTodos: ${todayTodos}
    ''';
  }
}
