import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Screens/task_screen.dart';
import 'package:torg/components/task_form.dart';
import 'package:torg/providers/task.dart';
import 'package:torg/Models/project.dart';
import 'package:dotted_border/dotted_border.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<TaskProv>().getTodayTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        List<Task> list = snapshot.data!;

        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 406 > 0
              ? MediaQuery.of(context).size.height - 406
              : 100,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == list.length) {
                return addTaskToday();
              }
              return Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 3.0, bottom: 3.0),
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
                            builder: (context) => ChangeNotifierProvider(
                                create: (context) => TaskProv(),
                                child: TaskScreen(
                                  id: list[index].id,
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
                            value: list[index].done,
                            onChanged: (val) async {
                              await context
                                  .read<TaskProv>()
                                  .toggleTask(list[index].id);
                              setState(() {});
                            }),
                        title: Text(
                          list[index].name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          list[index].subtasks.isEmpty
                              ? "No subtasks"
                              : "Subtasks : ${list[index].subtasks.length}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget addTaskToday() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return SizedBox(
                  height: 350,
                  child: Column(children: [
                    const SizedBox(
                      width: 100,
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.black,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 13.0),
                        child: Text(
                          'New Task',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    ChangeNotifierProvider(
                        create: (context) => TaskProv(),
                        child: TaskForm(
                          update: update,
                        ))
                  ]));
            },
          );
        },
        child: DottedBorder(
            dashPattern: const [5, 5],
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            child: SizedBox(
              height: 60,
              child: Center(
                child: DottedBorder(
                  dashPattern: const [5, 5],
                  borderType: BorderType.Circle,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
