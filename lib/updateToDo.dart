import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/database.dart';
import 'dart:async';

import 'package:todo_list/model/todo.dart';
import 'package:todo_list/notification/notification.dart';

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

class UpdateToDoPage extends StatefulWidget {
  const UpdateToDoPage({super.key, required this.todo});
  final ToDo todo;

  @override
  State<UpdateToDoPage> createState() => _UpdateToDoPageState();
}

class _UpdateToDoPageState extends State<UpdateToDoPage> {
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocus = FocusNode();

  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocus = FocusNode();

  final TextEditingController dateController = TextEditingController();
  final FocusNode dateFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  // late DateTime selectedDate;

  final TextEditingController timeController = TextEditingController();
  final FocusNode timeFocus = FocusNode();
  // TimeOfDay selectedTime = TimeOfDay.now();
  late TimeOfDay selectedTime;

  String description = "";
  String date = "";
  String time = "";


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
    _getToDoList(); // Loading the diary when the app starts
    description = widget.todo.title;
    date = widget.todo.day;
    time = widget.todo.time;

    selectedDate = DateTime.parse(date);
    selectedTime = TimeOfDay(hour:int.parse(time.split(":")[0]),minute: int.parse(time.split(":")[1]));
  }

  void _updateToDo(ToDo todo) async {
    await Data.updateToDo(todo);
    // _getToDoList();
  }

  void _deleteToDo(ToDo todo) async {
    await Data.deleteToDo(todo);
    // _getToDoList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm công việc"),
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
        actions: [
          IconButton(
            onPressed: (){
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  title: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200, width: 2)
                        )
                    ),
                    child: Text('Xác nhận'),
                  ),
                  content: Text('Bạn thực sự muốn xóa công việc \'${widget.todo.title}\' vào lúc ${widget.todo.time}'),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(30,10,30,10)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        ),
                        backgroundColor:MaterialStateProperty.all(Colors.blue),
                      ),

                      onPressed: () => Navigator.pop(context),
                      child: const Text('Trở lại', style: TextStyle(color: Colors.white),),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(30,10,30,10)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        ),
                        backgroundColor:MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () => {
                        _deleteToDo(widget.todo),
                        NotificationServer.deleteScheduleNotification(widget.todo),
                        Navigator.pop(context),
                        Navigator.pop(context, true),
                      },
                      child: const Text('Xóa', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              );


            },
            // icon: Icon(Icons.remove_circle_outlined, color: Colors.red,),
            icon: Image(
              image: Svg('assets/icons/icon_remove.svg'),
            ),
          )
        ],
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
                controller: descriptionController..text = description,
                onChanged: (String text){
                  description = text;

                },
                // initialValue: descriptionController,
                minLines: 3,

                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Nhập công việc cầm làm tại đây',
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
                        controller: dateController..text = date,
                        // initialValue: dateController,
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
                        controller: timeController..text = time,
                        // initialValue: timeController,
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
            ),

            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      if(check(context)){
                        ToDo newToDo = ToDo(id: widget.todo.id, title: descriptionController.text, day: dateController.text, time: timeController.text, status: 0);
                        _updateToDo(newToDo);
                        NotificationServer.deleteScheduleNotification(widget.todo);
                        NotificationServer.createScheduleNotification(newToDo);
                        Navigator.pop(context, true);
                      }
                      else{
                        setState(() => {
                          print("Error: " + error),
                        });
                      }

                    },

                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(30,10,30,10)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                    child: const Text("Lưu thay đổi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                  )
                ],
              ),
            )


          ],
        ),
      ),
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
        date = "${selectedDate.toLocal()}".split(' ')[0];
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
        time = hour + ":" + minute;
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

  bool check(BuildContext context){
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

    if(DateTime.parse("${dateController.text} ${timeController.text}").isBefore(DateTime.now())){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 2)
                )
            ),
            child: Text('Thông báo'),
          ),
          content: Text('Thời gian bạn chọn để thực hiện công việc đã qua. Vui lòng chọn lại ngày/giờ khác'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(30,10,30,10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // side: BorderSide(color: Colors.red)
                    )
                ),
                backgroundColor:MaterialStateProperty.all(Colors.blue),
              ),

              onPressed: () => Navigator.pop(context),
              child: const Text('Trở lại', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );

      return false;
    }

    return true;
  }
// Text showError(){
//   return ;
// }
}