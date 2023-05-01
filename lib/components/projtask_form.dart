import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import 'package:torg/Models/project.dart';
import 'package:torg/providers/task.dart';

 

class ProjTaskForm extends StatefulWidget {
  const ProjTaskForm({super.key, required this.update, required this.type,required this.proj});
  final Project proj;
  final TaskStatus type;
  final Function() update;
  @override
  State<ProjTaskForm> createState() => _ProjTaskFormState();
}

class _ProjTaskFormState extends State<ProjTaskForm> {
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
                            onPressed: () async{
                              final nav = Navigator.of(context);
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                               await context.read<TaskProv>().addTasktoProj(taskName, widget.type,widget.proj );
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
