import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/Screens/task_screen.dart';
import 'package:torg/providers/task.dart';

class TasksByDateScreen extends StatefulWidget {
  const TasksByDateScreen({super.key});

  @override
  State<TasksByDateScreen> createState() => _TasksByDateScreenState();
}

class _TasksByDateScreenState extends State<TasksByDateScreen> {
  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 90,
      child: FutureBuilder(
        future: context.read<TaskProv>().getAllTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Task> taskList = snapshot.data!;

          taskList.sort((a, b) => a.createdIn!.compareTo(b.createdIn!));
          Map<String, List<Task>> groupedTasks = {};
          for (var task in taskList) {
            String day = DateFormat('EEEE, MMM d').format(task.createdIn!);

            if (!groupedTasks.containsKey(day)) {
              groupedTasks[day] = [];
            }
            groupedTasks[day]?.add(task);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:   EdgeInsets.only(left: 20.0),
                child: Text(
                  "Tasks List",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: groupedTasks.length,
                  itemBuilder: (context, index) {
                    String day = groupedTasks.keys.elementAt(index);
                    List<Task> tasksOfDay = groupedTasks[day]!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.grey.withOpacity(0.8),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: tasksOfDay.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 3.0,
                                  bottom: 3.0),
                              child: SizedBox(
                                height: 80,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                                  create: (context) =>
                                                      TaskProv(),
                                                  child: TaskScreen(
                                                    id: tasksOfDay[index].id,
                                                    updateParent: update,
                                                  )),
                                        ));
                                  },
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0)),
                                    ),
                                    color: Colors.white,
                                    elevation: 3.0,
                                    child: ListTile(
                                      leading: Checkbox(
                                          value: tasksOfDay[index].done,
                                          onChanged: (val) async {
                                            await context
                                                .read<TaskProv>()
                                                .toggleTask(
                                                    tasksOfDay[index].id);
                                            setState(() {});
                                          }),
                                      title: Text(
                                        tasksOfDay[index].name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        tasksOfDay[index].subtasks.isEmpty
                                            ? "No subtasks"
                                            : "Subtasks : ${tasksOfDay[index].subtasks.length}",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
