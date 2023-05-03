import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/Screens/subtask_screen.dart';
import 'package:torg/components/subtask_form.dart';
import 'package:torg/providers/task.dart';
import 'package:torg/screens/taskname_screen.dart';

class ProjectTaskScreen extends StatefulWidget {
  final int id;
  const ProjectTaskScreen(
      {super.key, required this.id, required this.updateParent});
  final Function() updateParent;

  @override
  State<ProjectTaskScreen> createState() => _ProjectTaskScreenState();
}

class _ProjectTaskScreenState extends State<ProjectTaskScreen> {
  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Future.wait([
            context.read<TaskProv>().getTaskById(widget.id),
            context.read<TaskProv>().getSubtasksById(widget.id)
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            Task task = snapshot.data![0] as Task;
            List<Subtask> list = snapshot.data![1] as List<Subtask>;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                widget.updateParent();
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
                                        builder: (context) =>
                                            TaskNameScreen(text: task.name!)),
                                  );
                                },
                                child: Text(
                                  task.name!,
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
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: SizedBox(
                                      height: 220,
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
                                              'New Subtask',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ChangeNotifierProvider(
                                          create: (context) => TaskProv(),
                                          child: SubtaskForm(
                                            id: widget.id,
                                            update: update,
                                          ),
                                        )
                                      ])),
                                );
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
                                "New Subtask",
                                style: TextStyle(color: Color(0xFF0B5FF3)),
                              ), // text
                            ],
                          ),
                        ))
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Icon(Icons.access_alarm),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Sub-Tasks",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 60,
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
                                        create: (context) => TaskProv(),
                                        child: SubtaskScreen(
                                            id: list[index].id,
                                            updateParent: update),
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
                                  leading: Checkbox(
                                      value: list[index].done,
                                      onChanged: (val) async {
                                        await context
                                            .read<TaskProv>()
                                            .toggleSubTask(list[index].id);
                                        setState(() {});
                                      }),
                                  title: Text(
                                    list[index].name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final nav = Navigator.of(context);
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Task?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    ).then((value) async {
                      if (value == true) {
                        await context
                            .read<TaskProv>()
                            .deleteTaskById(widget.id);
                        widget.updateParent();
                        nav.pop();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
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
                        'Delete Task',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 162, 179),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
