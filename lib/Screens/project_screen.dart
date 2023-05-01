import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/Screens/project_task_screen.dart';
import 'package:torg/Screens/taskname_screen.dart';
import 'package:torg/components/projtask_form.dart';
import 'package:torg/providers/project.dart';
import 'package:torg/providers/task.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key, required this.project, required this.update});
  final Project project;
  final Function() update;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  void updateThis() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: context.read<Projects>().getProj(widget.project.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            Project project = snapshot.data!;
            List<Task> taskList = project.tasks.toList();
            List<Task> upcoming = taskList
                .where((element) => element.status == TaskStatus.upcoming)
                .toList();
            List<Task> done = taskList
                .where((element) => element.status == TaskStatus.done)
                .toList();
            List<Task> current = taskList
                .where((element) => element.status == TaskStatus.current)
                .toList();
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  widget.update();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskNameScreen(
                                              text: project.name!)),
                                    );
                                  },
                                  child: Text(
                                    project.name!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final nav = Navigator.of(context);
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Project?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              ).then((value) async {
                                if (value == true) {
                                  await context
                                      .read<Projects>()
                                      .delProj(project.id);
                                  widget.update();
                                  nav.pop();
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 255, 162, 179),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Delete Project',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 162, 179),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.grey.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
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
                                          child: ProjTaskForm(
                                            update: updateThis,
                                            type: TaskStatus.upcoming,
                                            proj: project,
                                          ))
                                    ]));
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0E9F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Icon(Icons.add,
                                  color: Color(0xFF0B5FF3)), // plus icon
                              SizedBox(
                                  width:
                                      8), // add some space between the icon and text
                              Text(
                                "New Task",
                                style: TextStyle(color: Color(0xFF0B5FF3)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(child: iterateList(upcoming)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Current",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.grey.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
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
                                            padding:
                                                EdgeInsets.only(left: 13.0),
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
                                            child: ProjTaskForm(
                                              update: updateThis,
                                              type: TaskStatus.current,
                                              proj: project,
                                            ))
                                      ]));
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0E9F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Icon(Icons.add,
                                  color: Color(0xFF0B5FF3)), // plus icon
                              SizedBox(
                                  width:
                                      8), // add some space between the icon and text
                              Text(
                                "New Task",
                                style: TextStyle(color: Color(0xFF0B5FF3)),
                              ), // text
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(child: iterateList(current)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.grey.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
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
                                            padding:
                                                EdgeInsets.only(left: 13.0),
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
                                            child: ProjTaskForm(
                                              update: updateThis,
                                              type: TaskStatus.done,
                                              proj: project,
                                            ))
                                      ]));
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0E9F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Icon(Icons.add,
                                  color: Color(0xFF0B5FF3)), // plus icon
                              SizedBox(
                                  width:
                                      8), // add some space between the icon and text
                              Text(
                                "New Task",
                                style: TextStyle(color: Color(0xFF0B5FF3)),
                              ), // text
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(child: iterateList(done))
                ]);
          }),
    );
  }

  Widget iterateList(List<Task> x) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: x.length,
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => TaskProv(),
                    child:
                        ProjectTaskScreen(id: x[index].id, updateParent: updateThis),
                  ),
                ));
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0)),
            ),
            child: ListTile(
              leading: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                         await context
                              .read<TaskProv>()
                              .prevTaskStatus(x[index].id);
                          updateThis();
                        },
                        icon: const Icon(Icons.arrow_circle_up_sharp)),
                    IconButton(
                        onPressed: () async {
                          await context
                              .read<TaskProv>()
                              .nextTaskStatus(x[index].id);
                          updateThis();
                          
                        },
                        icon: const Icon(Icons.arrow_circle_down_sharp)),
                  ],
                ),
              ),
              title: Text(
                x[index].name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
