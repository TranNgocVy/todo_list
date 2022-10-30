import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/database.dart';
import 'dart:async';

import 'package:todo_list/model/todo.dart';

// class AddToDo extends StatelessWidget {
//   final int id;
//   const AddToDo({super.key,  required this.id} );
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'To do list',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AddToDoPage(id: id),
//     );
//   }
// }

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key, required this.id});
  final int id;

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocus = FocusNode();

  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocus = FocusNode();

  final TextEditingController dateController = TextEditingController();
  final FocusNode dateFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  final TextEditingController timeController = TextEditingController();
  final FocusNode timeFocus = FocusNode();
  TimeOfDay selectedTime = TimeOfDay.now();


  // String selectType = "Tất cả";
  // bool ischeck = false;

  String error = "";


  bool _isLoading = true;
  List<ToDo> todoList = [];

  var formatterDate = new DateFormat('yyyy-MM-dd');
  var formatterTime = new DateFormat('HH:mm');


  // This function is used to fetch all data from the database
  void _getToDoList() async {
    final data = await Data.getToDoList();
    setState(() {
      todoList = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Data.updateToDo(ToDo(id: 1, title: "Làm bài tập 1 cho rất rất nhiều môn", day: "20-10-2022", time: "20:30", status: 0));
    // Data.insertTodo(ToDo(id: 2, title: "Làm bài tập 2", day: "21-10-2022", time: "21:30", status: 0));
    // Data.insertTodo(ToDo(id: 3, title: "Làm bài tập 3", day: "22-10-2022", time: "22:30", status: 0));
    // Data.insertTodo(ToDo(id: 4, title: "Làm bài tập 4", day: "23-10-2022", time: "23:30", status: 0));
    // Data.insertTodo(ToDo(id: 5, title: "Làm bài tập 5", day: "24-10-2022", time: "20:00", status: 0));
    // Data.insertTodo(ToDo(id: 6, title: "Làm bài tập 6", day: "25-10-2022", time: "10:00", status: 0));
    _getToDoList(); // Loading the diary when the app starts
  }

  void _updateToDo(ToDo todo) async {
    await Data.updateToDo(todo);
    _getToDoList();
  }

  void _insertToDo(ToDo todo) async {
    await Data.insertTodo(todo);
    _getToDoList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
      ),

      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: descriptionController,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Nhập công việc cầm làm mới tại đây',
                  hintStyle: TextStyle(
                      fontSize: 15
                  ),
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child:Container(
                      //padding: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(5,2.5,2.5,2.5),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        // initialValue: "2001-04-04",
                        focusNode: dateFocus,
                        controller: dateController,
                        autovalidateMode: AutovalidateMode.always,
                        decoration: InputDecoration(
                          hintText: "Ngày thực hiện",
                          hintStyle: TextStyle(
                              fontSize: 15
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          suffixIcon: (dateController.text.isNotEmpty &&
                              dateFocus.hasFocus) ?
                          IconButton(onPressed: () {
                            setState(() {
                              dateController.clear();
                              selectedDate = DateTime.now();
                              dateFocus.unfocus();
                            });
                          }, icon: Icon(Icons.clear)) :
                          Icon(Icons.calendar_month_outlined),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                      flex: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5,2.5,2.5,2.5),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: timeFocus,
                        controller: timeController,
                        autovalidateMode: AutovalidateMode.always,
                        decoration: InputDecoration(
                          hintText: "Giờ thực hiện",
                          hintStyle: TextStyle(
                            fontSize: 15
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          suffixIcon: (timeController.text.isNotEmpty &&
                              timeFocus.hasFocus) ?
                          IconButton(onPressed: () {
                            setState(() {
                              timeController.clear();
                              selectedTime = TimeOfDay.now();
                              timeFocus.unfocus();
                            });
                          }, icon: Icon(Icons.clear)) :
                          Icon(Icons.access_time_outlined),
                        ),
                        readOnly: true,
                        onTap: () => _selectTime(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            )


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(check()){
            _insertToDo(ToDo(id: widget.id, title: descriptionController.text, day: dateController.text, time: timeController.text, status: 0));
            Navigator.pop(context, true);
          }
          else{
            setState(() => {
              print("Error: " + error),
            });
          }

        },
        tooltip: 'Lưu',
        child: const Text("Lưu công việc", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ), // This trailing comma makes auto-formatting nicer for build methods.
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
        dateFocus.requestFocus();
      });
    }
    else if (picked == selectedDate) {
      return;
    }
    else {
      setState(() {
        dateController.clear();
        selectedDate = DateTime.now();
      });
    }
  }

  _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      setState(() {
        String hour = selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}";
        String minute = selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}";
        timeController.text = hour + ":" + minute;
        timeFocus.requestFocus();
      });
    }
    else if (picked == selectedTime) {
      return;
    }
    else {
      setState(() {
        timeController.clear();
        selectedTime = TimeOfDay.now();
      });
    }
  }

  bool check(){
    error = "";
    if (descriptionController.text.isEmpty){
      error = "Chưa nhập công việc cần làm";
      return false;
    }

    if(dateController.text.isEmpty){
      error = "Chưa chọn ngày thực hiện";
      return false;
    }

    if(timeController.text.isEmpty){
      error = "Chưa chọn giờ thực hiện";
      return false;
    }

    return true;
  }
  // Text showError(){
  //   return ;
  // }
}