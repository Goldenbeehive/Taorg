import 'package:isar/isar.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/Models/user.dart';

class Db {
  static final Future<Isar> isar =
      Isar.open([ProjectSchema, UserSchema, TaskSchema, SubtaskSchema]);

  Db._();

  Future<Isar> get db => isar;
}
