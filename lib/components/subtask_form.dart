import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:torg/providers/task.dart';

class SubtaskForm extends StatefulWidget {
  const SubtaskForm({super.key, required this.update, required this.id});
  final int id;
  final Function() update;
  @override
  State<SubtaskForm> createState() => _SubtaskFormState();
}

class _SubtaskFormState extends State<SubtaskForm> {
  final _formKey = GlobalKey<FormState>();
  String taskName = "";
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
                            onPressed: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                final nav = Navigator.of(context);
                               await  context
                                    .read<TaskProv>()
                                    .addSubTask(widget.id, taskName);
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
}
