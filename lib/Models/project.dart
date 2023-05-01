import 'package:isar/isar.dart';
part 'project.g.dart';

@Collection()
class Project {
   Id id = Isar.autoIncrement;

  String? name;

  var tasks = IsarLinks<Task>();

 
}

@Collection()
class Task {
  Id id = Isar.autoIncrement;

  String? name;

  DateTime? createdIn;
  DateTime? from;
  DateTime? to;
  bool? done;
  var project = IsarLink<Project>();
  var subtasks = IsarLinks<Subtask>();
  @enumerated
  TaskStatus status = TaskStatus.upcoming;

  
}

@Collection()
class Subtask {
  Id id = Isar.autoIncrement;

  String? name;
  bool? done;
   
  var task = IsarLink<Task>();

   

}

enum TaskStatus { done, upcoming, current }
 