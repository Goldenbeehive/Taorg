import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/providers/task.dart';

class DonutCheck extends StatefulWidget {
  const DonutCheck({super.key, required this.id});

  final int id;
  @override
  State<DonutCheck> createState() => _DonutCheckState();
}

class _DonutCheckState extends State<DonutCheck> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<TaskProv>().getOneSubtask(widget.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        Subtask sub = snapshot.data!;
        return GestureDetector(
          onTap: () async {
            await context.read<TaskProv>().toggleSubTask(widget.id);

            setState(() {});
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Center(child: check(sub.done!)),
            ],
          ),
        );
      },
    );
  }

  Widget check(bool checked) {
    if (checked) {
      return const Icon(
        Icons.check,
        color: Colors.green,
        size: 30,
      );
    }
    return Container();
  }
}
