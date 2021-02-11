import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List> _events = Map();
  CalendarController _calendarController;

  List selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendar(),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  Widget _buildCalendar() {
    final ToDoService toDoService = Provider.of(context);
    return TableCalendar(
      initialSelectedDay: null,
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      events: toDoService.asEvents,
      calendarStyle: CalendarStyle(
        todayColor: Colors.green[300],
        selectedColor: Colors.green,
        markersColor: Colors.white,
      ),
      onDaySelected: (day, events, holidays) {
        setState(() {
          selectedEvents = events;
        });
      },
    );
  }

  Widget _buildEventList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return TodoListItem(selectedEvents[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
          thickness: 1,
        );
      },
      itemCount: selectedEvents.length,
    );
  }
}
