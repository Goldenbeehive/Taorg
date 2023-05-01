import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:torg/Models/user.dart';
import 'package:torg/providers/db.dart';

class Name extends ChangeNotifier {
  Future<Isar> db = Db.isar;

  Future<void> addName(String n) async {
    var isar = await db;
    await isar.writeTxn(() async {
      await isar.users.put(User()..name = n);
    });
  }

  Future<Isar> getDb() {
    return db;
  }

  Future<User> getName() async {
    var isar = await db;
    var username = await isar.users.filter().nameIsNotEmpty().findAll();
    return username[0];
  }

  Future<void> changeName(String name) async {
    var isar = await db;
    var username = await isar.users.filter().nameIsNotEmpty().findFirst();

    await isar.writeTxn(() async {
      username!.name = name;
      isar.users.put(username);
    });
  }
}
