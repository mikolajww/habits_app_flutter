import 'package:Habitect/data/to_do_category.dart';
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
                Tab(text: "Weekly"),
                Tab(text: "Monthly"),
                Tab(text: "Overall"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: ClampingScrollPhysics(),
              controller: _tabController,
              children: [
                weeklyStatistics(context),
                monthlyStatistics(context),
                overallStatistics(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TimeSeriesTodo {
  final DateTime date;
  final double percentComplete;

  TimeSeriesTodo(this.date, this.percentComplete);
}

charts.Series<TimeSeriesTodo, DateTime> getStatistics(DateTime fromDate, DateTime toDate, BuildContext context) {
  final ToDoService toDoService = Provider.of(context);

  final weeklyTodos = toDoService.todos
      .where((element) => element.date.isBefore(toDate) && element.date.isAfter(fromDate))
      .toList()
        ..sort((ToDoItem a, ToDoItem b) => a.date.compareTo(b.date));

  final daysToGenerate = toDate.difference(fromDate).inDays + 1;
  var days = List.generate(daysToGenerate, (i) => DateTime(fromDate.year, fromDate.month, fromDate.day + i));

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
    if (completion.isNaN) completion = 100;
    weeklyData.add(TimeSeriesTodo(entry.key, completion));
  }
  return charts.Series<TimeSeriesTodo, DateTime>(
      id: 'Todo',
      colorFn: (datum, index) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (datum, index) => datum.date,
      measureFn: (datum, index) => datum.percentComplete,
      data: weeklyData);
}

Widget weeklyStatistics(BuildContext context) {
  final fromDate = DateTime.now().subtract(Duration(days: 6));
  final toDate = DateTime.now();
  final charts.Series<TimeSeriesTodo, DateTime> series = getStatistics(fromDate, toDate, context);
  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.9,
      child: charts.TimeSeriesChart(
        [series],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: charts.DateTimeAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.green.shadeDefault),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.green.shadeDefault),
            lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.green.shadeDefault.darker),
          ),
        ),
      ),
    ),
  );
}

Widget monthlyStatistics(BuildContext context) {
  final fromDate = DateTime.now().subtract(Duration(days: 30));
  final toDate = DateTime.now();
  final charts.Series<TimeSeriesTodo, DateTime> series = getStatistics(fromDate, toDate, context);
  return Center(
    child: charts.TimeSeriesChart(
      [series],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.green.shadeDefault),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.green.shadeDefault),
          lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.green.shadeDefault.darker),
        ),
      ),
    ),
  );
}

class CategoryBreakdown {
  final ToDoCategory category;
  final int total;

  CategoryBreakdown(this.category, this.total);

  @override
  String toString() {
    return "${category.name} - $total";
  }
}

Widget overallStatistics(BuildContext context) {
  final ToDoService toDoService = Provider.of(context);
  final data = <CategoryBreakdown>[];
  for (ToDoCategory category in ToDoService.categories) {
    var fittingTodos = toDoService.todos.where((element) => element.category == category);
    data.add(CategoryBreakdown(category, fittingTodos.length));
  }

  final charts.Series<CategoryBreakdown, String> series = charts.Series<CategoryBreakdown, String>(
    id: 'Category Breakdown',
    domainFn: (datum, index) => datum.category.name,
    measureFn: (datum, index) => datum.total,
    colorFn: (datum, index) => charts.ColorUtil.fromDartColor(datum.category.color),
    data: data,
    labelAccessorFn: (datum, index) => '${datum.category.name}: ${datum.total}',
  );

  var totalTodos = toDoService.todos.length;
  var completedTodos = toDoService.todos.where((element) => element.isCompleted).length;

  var longestStreak = 0;
  var streak = 0;
  var currentStreak = 0;

  final sortedTodos = toDoService.todos..sort((ToDoItem a, ToDoItem b) => a.date.compareTo(b.date));
  final earliestTodo = sortedTodos.first.date;
  final latestTodo = DateTime.now();

  var days = List.generate(latestTodo.difference(earliestTodo).inDays + 1,
      (i) => DateTime(earliestTodo.year, earliestTodo.month, earliestTodo.day + i));
  var todoMap = toDoService.asEvents;
  for (var day in days) {
    print(day);
    if (!todoMap.containsKey(day)) {
      streak++;
      continue;
    }
    var todoList = todoMap[day];
    if (todoList.every((element) => element.isCompleted)) {
      streak++;
    } else {
      if (streak > longestStreak) {
        longestStreak = streak;
        streak = 0;
      }
    }
  }
  if (streak > longestStreak) {
    longestStreak = streak;
  }

  for (var day in days.reversed) {
    if (!todoMap.containsKey(day)) {
      currentStreak++;
      continue;
    }
    var todoList = todoMap[day];
    if (todoList.every((element) => element.isCompleted)) {
      currentStreak++;
    } else {
      break;
    }
  }

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Lifetime Statistics",
          style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Todos: $totalTodos",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                ),
                Text(
                  "Completed Todos: $completedTodos",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Streak: $currentStreak",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                ),
                Text(
                  "Longest Streak: $longestStreak",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 30),
        Text(
          "Category Breakdown",
          style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
        ),
        SizedBox(
          height: 400,
          child: charts.PieChart(
            [series],
            animate: true,
            defaultRenderer: new charts.ArcRendererConfig(
              arcRendererDecorators: [
                charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside,
                  insideLabelStyleSpec: charts.TextStyleSpec(fontFamily: "Roboto", fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
