import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/providers/db.dart';

class TaskProv extends ChangeNotifier {
  Future<Isar> db = Db.isar;

  Future<void> addTaskToday(String n, TimeOfDay from, TimeOfDay to) async {
    var isar = await db;
    final now = DateTime.now();
    await isar.writeTxn(() async {
      await isar.tasks.put(Task()
        ..name = n
        ..createdIn = now
        ..from = DateTime(now.year, now.month, now.day, from.hour, from.minute)
        ..to = DateTime(now.year, now.month, now.day, to.hour, to.minute)
        ..done = false);
    });
  }

  Future toggleTask(int id) async {
    var isar = await db;
    return await isar.writeTxn(() async {
      var task = await isar.tasks.get(id);
      task!.done = !task.done!;
      isar.tasks.put(task);
    });
  }

  Future<void> addTasktoProj(String n, TaskStatus stat, Project proj) async {
    var isar = await db;
    Task t = Task()
      ..name = n
      ..status = stat
      ..project.value = proj;

    await isar.writeTxn(() async {
      await isar.tasks.put(t);
      Project? p = await isar.projects.filter().idEqualTo(proj.id).findFirst();
      p?.tasks.add(t);
      p?.tasks.save();
      t.project.save();
    });
  }

  Future<List<Task>> getAllTasks() async {
    var isar = await db;
    var tasks = await isar.tasks.filter().projectIsNull().findAll();
    return tasks;
  }

  Future<Task> getTaskById(int id) async {
    var isar = await db;
    var task = await isar.tasks.filter().idEqualTo(id).findAll();
    return task[0];
  }

  Future<List<Subtask>> getSubtasksById(int id) async {
    var isar = await db;
    var task = await isar.tasks.filter().idEqualTo(id).findAll();
    return task[0].subtasks.toList();
  }

  Future<void> addSubTask(int id, String n) async {
    var isar = await db;
    var tasks = await isar.tasks.filter().idEqualTo(id).findAll();
    Subtask sub = Subtask()
      ..name = n
      ..done = false;
    await isar.writeTxn(() async {
      await isar.subtasks.put(sub);
    });

    tasks[0].subtasks.add(sub);
    await isar.writeTxn(() async {
      await tasks[0].subtasks.save();
    });
  }

  Future<Subtask> getOneSubtask(int id) async {
    var isar = await db;
    var sub = await isar.subtasks.filter().idEqualTo(id).findFirst();
    return sub!;
  }

  Future<void> deleteSubtaskById(int id) async {
    var isar = await db;
    await isar.writeTxn(() async {
      await isar.subtasks.delete(id);
    });
  }

  Future<bool> deleteTaskById(int id) async {
    var isar = await db;
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
    return true;
  }

  Future toggleSubTask(int id) async {
    var isar = await db;

    return await isar.writeTxn(() async {
      var sub = await isar.subtasks.get(id);
      sub!.done = !sub.done!;
      isar.subtasks.put(sub);
    });
  }

  Future<void> nextTaskStatus(int id) async {
    var isar = await db;
    return await isar.writeTxn(() async {
      var task = await isar.tasks.get(id);
      task = task!;
      if (task.status == TaskStatus.upcoming) {
        task.status = TaskStatus.current;
        isar.tasks.put(task);
        return;
      }
      if (task.status == TaskStatus.current) {
        task.status = TaskStatus.done;
        isar.tasks.put(task);
        return;
      }
      if (task.status == TaskStatus.done) {
        return;
      }
    });
  }

  Future<void> prevTaskStatus(int id) async {
    var isar = await db;
    return await isar.writeTxn(() async {
      var task = await isar.tasks.get(id);
      task = task!;
      if (task.status == TaskStatus.upcoming) {
        return;
      }
      if (task.status == TaskStatus.current) {
        task.status = TaskStatus.upcoming;
        isar.tasks.put(task);
        return;
      }
      if (task.status == TaskStatus.done) {
        task.status = TaskStatus.current;
        isar.tasks.put(task);
        return;
      }
    });
  }

  Future<void> setTaskStatus(TaskStatus x, int id) async {
    var isar = await db;
    return await isar.writeTxn(() async {
      var task = await isar.tasks.get(id);
      task!.status = x;
      isar.tasks.put(task);
    });
  }

  Future<List<Task>> getTodayTasks() async {
    var isar = await db;

    DateTime now = DateTime.now();

    DateTime beginningOfDay = DateTime(now.year, now.month, now.day);

    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1)
        .subtract(const Duration(milliseconds: 1));
    var tasks = await isar.tasks
        .filter()
        .projectIsNull()
        .createdInBetween(beginningOfDay, endOfDay)
        .findAll();
    return tasks;
  }

  Future<Isar> getDb() {
    return db;
  }
}
