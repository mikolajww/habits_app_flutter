import 'package:Habitect/data/to_do_item.dart';
import 'package:Habitect/services/google_account_service.dart';
import 'package:Habitect/services/to_do_service.dart';
import 'package:Habitect/styles/app_styles.dart';
import 'package:Habitect/widgets/add_todo_dialog.dart';
import 'package:Habitect/widgets/home_top_bar.dart';
import 'package:Habitect/widgets/pie_chart.dart';
import 'package:Habitect/widgets/todo_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  bool isTopBarExpanded = true;
  bool bottomSheetExpanded = false;
  bool fetchedFromDrive = false;

  @override
  Widget build(BuildContext context) {
    final GoogleAccountService googleAccountService = Provider.of(context);
    final ToDoService toDoService = Provider.of(context);
    return Container(
      color: Color(0xff2e2e2e),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isTopBarExpanded = !isTopBarExpanded;
                bottomSheetExpanded = !bottomSheetExpanded;
              });
            },
            child: HomeTopBar(
              photoUrl: googleAccountService.currentAccount.photoUrl,
              username: googleAccountService.currentAccount.displayName,
              isExpanded: isTopBarExpanded,
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) => Stack(alignment: Alignment.topCenter, children: [
                Container(
                    alignment: Alignment.bottomRight,
                    height: toDoService.todayTodos.length > 0 ? 300 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: () async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddTodoDialog();
                            },
                          );
                        },
                        backgroundColor: Colors.green,
                        child: Icon(Icons.add),
                      ),
                    )),
                ...getWidgetsForTaskList(toDoService)
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  List<Widget> getWidgetsForTaskList(ToDoService toDoService) {
    if (toDoService.todayTodos.length == 0) {
      return [
        Align(
          child: Text(
            "You have no tasks for today",
            style: AppStyles.MED_ROBOTO,
          ),
          alignment: Alignment.center,
        )
      ];
    } else {
      var todayTodos = toDoService.todayTodos..sort((ToDoItem a, ToDoItem b) => a.date.compareTo(b.date));
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: PieChart(width: 250, height: 250, percentCompleted: toDoService.getPercentCompleteToday),
        ),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (DraggableScrollableNotification notification) {
            if (notification.extent > notification.minExtent + 0.02) {
              setState(() {
                bottomSheetExpanded = true;
                isTopBarExpanded = false;
              });
            } else {
              setState(() {
                bottomSheetExpanded = false;
                isTopBarExpanded = true;
              });
            }
            return false; //Bubble up
          },
          child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              maxChildSize: 1,
              minChildSize: 0.2,
              builder: (BuildContext ctx, scrollableController) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (bottomSheetExpanded) BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, -10))
                    ],
                    color: Color(0xff2e2e2e),
                  ),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        var header = Container(
                          height: 15,
                          child: Center(
                            child: bottomSheetExpanded
                                ? Icon(Icons.arrow_drop_down, size: 20)
                                : Icon(Icons.arrow_drop_up, size: 20),
                          ),
                        );
                        return header;
                      }
                      return TodoListItem(todayTodos[index - 1]);
                    },
                    itemCount: todayTodos.length + 1, // +1 for the header
                    controller: scrollableController,
                    separatorBuilder: (BuildContext context, int index) {
                      return index > 0 ? Divider(thickness: 1, indent: 5, endIndent: 5, height: 5) : Container();
                    },
                  ),
                );
              }),
        ),
      ];
    }
  }
}
