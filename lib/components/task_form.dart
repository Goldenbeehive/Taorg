
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import 'package:torg/providers/task.dart';
class TaskForm extends StatefulWidget {
  const TaskForm({super.key, required this.update});
  final Function() update;
  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  void updateFrom(TimeOfDay? x) {
    setState(() {
      if (x != null) {
        from = x;
      }
    });
  }

  void updateTo(TimeOfDay? x) {
    setState(() {
      if (x != null) {
        to = x;
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  String taskName = "";
  TimeOfDay from = const TimeOfDay(hour: 3, minute: 0);
  TimeOfDay to = const TimeOfDay(hour: 4, minute: 0);
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onSaved: (newValue) {
                  taskName = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    labelText: "Task Name"),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: [
                      const Text(
                        "From",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      timeLabel(from, context, updateFrom),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: [
                      const Text(
                        "To",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      timeLabel(to, context, updateTo),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ElevatedButton(
                            onPressed: () async{
                              final nav =Navigator.of(context);
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                await context
                                    .read<TaskProv>()
                                    .addTaskToday(taskName, from, to);
                                widget.update();
                                nav.pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Ok")),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }

  Widget timeLabel(
    TimeOfDay x, BuildContext context, void Function(TimeOfDay? x) update) {
  return ElevatedButton(
    onPressed: () async {
      TimeOfDay? changed = await showTimePicker(
        context: context,
        initialTime: x,
      );

      update(changed);
    },
    child: Text(x.format(context)),
  );
}
}
