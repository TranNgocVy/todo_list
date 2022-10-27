import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ToDo{
  final int id;
  final String title;
  final String day;
  final String time;
  final int status;

  const ToDo({
    required this.id,
    required this.title,
    required this.day,
    required this.time,
    required this.status,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'day': day,
      'time': time,
      'status': status,
    };
  }
}
