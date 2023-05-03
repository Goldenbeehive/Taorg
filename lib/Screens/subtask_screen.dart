import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/providers/task.dart';

class SubtaskScreen extends StatelessWidget {
  const SubtaskScreen(
      {super.key, required this.id, required this.updateParent});
  final Function() updateParent;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: context.read<TaskProv>().getOneSubtask(id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            Subtask sub = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      updateParent();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("${sub.name}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 30)),
                    ),
                    SizedBox(
                      width: 159,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          final nav = Navigator.of(context);
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Subtask?'),
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
                                  .read<TaskProv>()
                                  .deleteSubtaskById(id);
                              updateParent();
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
                              'Delete subtask',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 162, 179),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
