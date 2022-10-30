import 'dart:async';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/todo.dart';
import 'package:flutter/widgets.dart';

class Data{
  static var formatterDate = new DateFormat('yyyy-MM-dd');
  static var formatterTime = new DateFormat('HH:mm');

  static Future<void> insertTodo(ToDo todo) async {
    final db = await Data.createData();

    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ToDo>> getToDoList() async {
    final db = await Data.createData();

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

  static Future<List<ToDo>> getToDayToDoList() async {
    String today = formatterDate.format(DateTime.now());

    final db = await Data.createData();

    final List<Map<String, dynamic>> maps = await db.query('todo',where: 'day LIKE ?', whereArgs: [today]);

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

  static Future<List<ToDo>> getUpComingToDoList() async {
    final now = DateTime.now();
    final upcoming = now.add(const Duration(hours: 1));

    final String nowdate = formatterDate.format(now);
    final String nowtime = formatterTime.format(now);

    final String upcomingdate = formatterDate.format(upcoming);
    final String upcomingtime = formatterTime.format(upcoming);

    final db = await Data.createData();

    final List<Map<String, dynamic>> maps = await db.query(
        'todo',
        where: upcomingdate == nowdate ? 'day LIKE ? AND time >= ? AND time <= ?' : '(day LIKE ? AND time >= ?) OR (day LIKE ? AND time <= ?',
        whereArgs: upcomingdate == nowdate ? [nowdate, nowtime, upcomingtime] : [nowdate, nowtime, upcomingdate, upcomingtime]
    );

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

  static Future<List<ToDo>> getToDoListWithDescript(String description) async {
    final db = await Data.createData();

    final List<Map<String, dynamic>> maps = await db.query(
        'todo',
        where: 'title LIKE ?',
        whereArgs: ['%' + description + '%']
    );

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
    final db = await Data.createData();

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
    final db = await Data.createData();

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
    final db = await Data.createData();

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
    final db = await Data.createData();

    await db.update(
      'todo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<void> deleteToDo(ToDo todo) async {
    final db = await Data.createData();

    await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<Database> createData() async{
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
