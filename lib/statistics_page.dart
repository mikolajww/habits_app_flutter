import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TabBar(
              indicatorColor: Colors.green,
              controller: _tabController,
              tabs: [
                Tab(text: "Daily"),
                Tab(text: "Weekly"),
                Tab(text: "Monthly"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: ClampingScrollPhysics(),
              controller: _tabController,
              children: [
                Icon(Icons.subdirectory_arrow_left),
                WeeklyStatistics(context),
                Icon(Icons.sanitizer),
              ],
            ),
          )
        ],
      ),
    );
  }
}

charts.Series<TimeSeriesTodo, DateTime> getWeeklyStatistics(DateTime fromDate, DateTime toDate, BuildContext context) {
  final ToDoService toDoService = Provider.of(context);

  final weeklyTodos = toDoService.todos.where((element) => element.date.isBefore(toDate) && element.date.isAfter(fromDate)).toList()
    ..sort((ToDoItem a, ToDoItem b) => a.date.compareTo(b.date));

  final daysToGenerate = toDate.difference(fromDate).inDays + 1;
  var days = List.generate(daysToGenerate, (i) => DateTime(fromDate.year, fromDate.month, fromDate.day + (i)));

  Map<DateTime, List<ToDoItem>> weeklyTodosMapped = Map();

  days.forEach((element) {
    var key = DateTime(element.year, element.month, element.day);
    weeklyTodosMapped.putIfAbsent(key, () => null);
    weeklyTodosMapped[key] = [];
  });
  weeklyTodos.forEach((element) {
    var key = DateTime(element.date.year, element.date.month, element.date.day);
    weeklyTodosMapped[key].add(element);
  });

  List<TimeSeriesTodo> weeklyData = [];
  for (var entry in weeklyTodosMapped.entries) {
    var completion = 100 * entry.value.where((ToDoItem element) => element.isCompleted).length / entry.value.length;
    if (completion.isNaN) completion = 0;
    weeklyData.add(TimeSeriesTodo(entry.key, completion));
  }
  return charts.Series<TimeSeriesTodo, DateTime>(
      id: 'Todo',
      colorFn: (datum, index) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (datum, index) => datum.date,
      measureFn: (datum, index) => datum.percentComplete,
      data: weeklyData);
}

Widget WeeklyStatistics(BuildContext context) {
  final fromDate = DateTime.now().subtract(Duration(days: 6));
  final toDate = DateTime.now();
  final charts.Series<TimeSeriesTodo, DateTime> series = getWeeklyStatistics(fromDate, toDate, context);
  return Center(
    child: charts.TimeSeriesChart(
      [series],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    ),
  );
}

class TimeSeriesTodo {
  final DateTime date;
  final double percentComplete;

  TimeSeriesTodo(this.date, this.percentComplete);
}
