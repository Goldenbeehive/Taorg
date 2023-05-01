import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/providers/db.dart';

class Projects extends ChangeNotifier {
  Future<Isar> db = Db.isar;

  Future<int> amountDone(String n) async {
    var isar = await db;
    final tasks = await isar.projects.filter().nameEqualTo(n).findAll();
    int done = 0;
    for (final t in tasks[0].tasks) {
      if (t.status == TaskStatus.done) {
        done++;
      }
    }
    return done;
  }

  Future<void> delProj(int id) async {
    var isar = await db;
    await isar.writeTxn(() async {
      await isar.projects.delete(id);
    });
  }

  Future<Project> getProj(int id) async {
    var isar = await db;
    final proj = await isar.projects.filter().idEqualTo(id).findFirst();
    return proj!;
  }

  Future<int> amountUpcoming(String n) async {
    var isar = await db;
    final tasks = await isar.projects.filter().nameEqualTo(n).findAll();
    int upcoming = 0;
    for (final t in tasks[0].tasks) {
      if (t.status == TaskStatus.upcoming) {
        upcoming++;
      }
    }
    return upcoming;
  }

  Future<int> amountCurrent(String n) async {
    var isar = await db;
    final tasks = await isar.projects.filter().nameEqualTo(n).findAll();
    int current = 0;
    for (final t in tasks[0].tasks) {
      if (t.status == TaskStatus.current) {
        current++;
      }
    }
    return current;
  }

  Future<List<Project>> getName() async {
    var isar = await db;
    var names = await isar.projects.filter().nameIsNotEmpty().findAll();
    return names;
  }

  Future<void> addProj(String n) async {
    var isar = await db;
    await isar.writeTxn(() async {
      await isar.projects.put(Project()..name = n);
    });
  }
}
