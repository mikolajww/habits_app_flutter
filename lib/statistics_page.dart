import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:bezier_chart/bezier_chart.dart';
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

getWeeklyStatistics(fromDate, toDate, context) {
  final ToDoService toDoService = Provider.of(context);

  final weeklyTodos = toDoService.todos.where((element) => element.date.isBefore(toDate) && element.date.isAfter(fromDate)).toList();

  Map<DateTime, List<ToDoItem>> weeklyTodosMapped = Map();
  weeklyTodos.forEach((element) {
    var key = DateTime(element.date.year, element.date.month, element.date.day);
    if (!weeklyTodosMapped.containsKey(key)) {
      weeklyTodosMapped.putIfAbsent(key, () => null);
      weeklyTodosMapped[key] = [];
    }
    weeklyTodosMapped[key].add(element);
  });

  List<DataPoint> weeklyData = [];

  for (var entry in weeklyTodosMapped.entries) {
    var completion = 100 * entry.value.where((ToDoItem element) => element.isCompleted).length / entry.value.length;
    weeklyData.add(DataPoint<DateTime>(value: completion, xAxis: entry.key));
  }
  return weeklyData;
}

Widget WeeklyStatistics(BuildContext context) {
  final fromDate = DateTime.now().subtract(Duration(days: 7));
  final toDate = DateTime.now();

  return Center(
    child: Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: BezierChart(
        fromDate: fromDate,
        bezierChartScale: BezierChartScale.WEEKLY,
        toDate: toDate,
        selectedDate: toDate,
        series: [
          BezierLine(
            label: "% completed",
            data: [...getWeeklyStatistics(fromDate, toDate, context)],
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          verticalIndicatorFixedPosition: false,
          backgroundColor: Color(0xFF2e2e2e),
          footerHeight: 30.0,
        ),
      ),
    ),
  );
}
