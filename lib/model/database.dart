import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/todo.dart';
import 'package:flutter/widgets.dart';

class Data{
  static Future<void> insertTodo(ToDo todo) async {
    final db = await Data.creatData();

    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ToDo>> getToDoList() async {
    final db = await Data.creatData();

    final List<Map<String, dynamic>> maps = await db.query('todo');

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        day: maps[i]['day'],
        time: maps[i]['time'],
        status: maps[i]['status'],
      );
    });
  }
  static Future<List<ToDo>> getToDoListNotDone() async {
    final db = await Data.creatData();

    final List<Map<String, dynamic>> maps = await db.query('todo', where: 'status = ?', whereArgs: [0]);

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        day: maps[i]['day'],
        time: maps[i]['time'],
        status: maps[i]['status'],
      );
    });
  }
  static Future<List<ToDo>> getToDoListDone() async {
    final db = await Data.creatData();

    final List<Map<String, dynamic>> maps = await db.query('todo', where: 'status = ?', whereArgs: [1]);

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        day: maps[i]['day'],
        time: maps[i]['time'],
        status: maps[i]['status'],
      );
    });
  }
  static Future<List<ToDo>> getToDoListNotCancel() async {
    final db = await Data.creatData();

    final List<Map<String, dynamic>> maps = await db.query('todo', where: 'status = ?', whereArgs: [-1]);

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        day: maps[i]['day'],
        time: maps[i]['time'],
        status: maps[i]['status'],
      );
    });
  }

  static Future<void> updateToDo(ToDo todo) async {
    final db = await Data.creatData();

    await db.update(
      'todo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<void> deleteToDo(int id) async {
    final db = await Data.creatData();

    await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Database> creatData() async{
    WidgetsFlutterBinding.ensureInitialized();
    return  openDatabase(
      join(await getDatabasesPath(), 'todolist.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, day TEXT, time TEXT, status INTEGER)',
        );
      },
      version: 1,
    );

  }
}
