import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/database.dart';
import 'dart:async';

import 'package:todo_list/model/todo.dart';

// class Search extends StatelessWidget {
//   final String search;
//   const Search({super.key,  required this.search} );
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'To do list',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SearchPage(search: search),
//     );
//   }
// }

class SearchPage extends StatefulWidget {
  final String search;
  const SearchPage({super.key, required this.search});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  late String description;

  // final TextEditingController titleController = TextEditingController();
  // final FocusNode titleFocus = FocusNode();
  //
  // final TextEditingController descriptionController = TextEditingController();
  // final FocusNode searchFocus = FocusNode();
  //
  // final TextEditingController dateController = TextEditingController();
  // final FocusNode dateFocus = FocusNode();
  // DateTime selectedDate = DateTime.now();
  //
  // final TextEditingController timeController = TextEditingController();
  // final FocusNode timeFocus = FocusNode();
  // TimeOfDay selectedTime = TimeOfDay.now();


  // String selectType = "Tất cả";
  // bool ischeck = false;

  // String error = "";


  bool _isLoading = true;
  List<ToDo> todoList = [];

  // This function is used to fetch all data from the database
  void _getToDoListWithDescription(String description) async {
    final data = await Data.getToDoListWithDescript(description);
    setState(() {
      todoList = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getToDoListWithDescription(widget.search); // Loading the diary when the app starts
    description = widget.search;
  }

  void _updateToDo(ToDo todo) async {
    await Data.updateToDo(todo);
    _getToDoListWithDescription(widget.search);
  }

  // void _insertToDo(ToDo todo) async {
  //   await Data.insertTodo(todo);
  //   _getToDoList();
  // }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        // title: Text(widget.title),
      ),

      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: searchController..text = description,
                focusNode: searchFocus,
                decoration: InputDecoration(
                  // hintText: widget.search,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                  suffixIcon: (searchController.text.isNotEmpty) ?
                  IconButton(onPressed: () {setState(() {
                    // searchController.clear();
                    description = "";
                    // searchFocus.;
                  });}, icon: Icon(Icons.clear)) :
                  IconButton(
                      onPressed: () {
                        description = searchController.text;
                        if (searchController.text.isNotEmpty){
                          setState(() {
                            description = searchController.text;
                            // searchController.clear();
                            searchFocus.unfocus();
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(search: searchController.text)));
                            _getToDoListWithDescription(searchController.text);
                          });
                        }
                      }, icon: Icon(Icons.search)
                  ),
                ),

              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade100, width: 2),
                )
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Kết quả tìm kiếm cho công việc: \'" + description + "\' (${todoList.length})",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 5),
              child: Column(
                children: todoList.map((todo) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Checkbox(
                        value: todo.status != 0,
                        // value: ischeck,
                        onChanged: (bool? isSelect) => {
                          // setState(() {
                          //   ischeck = isSelect!;
                          // })
                          // setState(()  async {
                          //   todo.status == 1;
                          //   await Data.updateToDo(todo);
                          //   _getToDoList();
                          // }),
                          // todo.status = 1;
                          if (isSelect == true){
                            _updateToDo(ToDo(id: todo.id, title: todo.title, day: todo.day, time: todo.time, status: 1))
                          }
                          else
                            {
                              _updateToDo(ToDo(id: todo.id, title: todo.title, day: todo.day, time: todo.time, status: 0))
                            }
                        },
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    todo.day,
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    todo.time,
                                    textAlign: TextAlign.end,

                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )).toList(),
              ),
            )


            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: TextFormField(
            //     keyboardType: TextInputType.text,
            //     autofocus: false,
            //     controller: descriptionController,
            //     minLines: 3,
            //     maxLines: null,
            //     decoration: InputDecoration(
            //       hintText: 'Nhập công việc cầm làm mới tại đây',
            //       hintStyle: TextStyle(
            //           fontSize: 15
            //       ),
            //       contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(5.0)),
            //     ),
            //   ),
            // ),
            // Container(
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child:Container(
            //           //padding: EdgeInsets.all(5),
            //           padding: EdgeInsets.fromLTRB(5,2.5,2.5,2.5),
            //           child: TextFormField(
            //             keyboardType: TextInputType.text,
            //             // initialValue: "2001-04-04",
            //             focusNode: dateFocus,
            //             controller: dateController,
            //             autovalidateMode: AutovalidateMode.always,
            //             decoration: InputDecoration(
            //               hintText: "Ngày thực hiện",
            //               hintStyle: TextStyle(
            //                   fontSize: 15
            //               ),
            //               contentPadding: EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
            //               border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(50.0)),
            //               suffixIcon: (dateController.text.isNotEmpty &&
            //                   dateFocus.hasFocus) ?
            //               IconButton(onPressed: () {
            //                 setState(() {
            //                   dateController.clear();
            //                   selectedDate = DateTime.now();
            //                   dateFocus.unfocus();
            //                 });
            //               }, icon: Icon(Icons.clear)) :
            //               Icon(Icons.calendar_month_outlined),
            //             ),
            //             readOnly: true,
            //             onTap: () => _selectDate(context),
            //           ),
            //         ),
            //         flex: 1,
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           padding: EdgeInsets.fromLTRB(5,2.5,2.5,2.5),
            //           child: TextFormField(
            //             keyboardType: TextInputType.text,
            //             focusNode: timeFocus,
            //             controller: timeController,
            //             autovalidateMode: AutovalidateMode.always,
            //             decoration: InputDecoration(
            //               hintText: "Giờ thực hiện",
            //               hintStyle: TextStyle(
            //                   fontSize: 15
            //               ),
            //               contentPadding: EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
            //               border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(50.0)),
            //               suffixIcon: (timeController.text.isNotEmpty &&
            //                   timeFocus.hasFocus) ?
            //               IconButton(onPressed: () {
            //                 setState(() {
            //                   timeController.clear();
            //                   selectedTime = TimeOfDay.now();
            //                   timeFocus.unfocus();
            //                 });
            //               }, icon: Icon(Icons.clear)) :
            //               Icon(Icons.access_time_outlined),
            //             ),
            //             readOnly: true,
            //             onTap: () => _selectTime(context),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(5),
            //   child: Text(
            //     error,
            //     style: TextStyle(
            //       color: Colors.red,
            //       fontStyle: FontStyle.italic,
            //       fontSize: 14,
            //     ),
            //   ),
            // )


          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Navigator.pop(context);
      //     setState(() => {
      //       if(check()){
      //         _insertToDo(ToDo(id: widget.id, title: descriptionController.text, day: dateController.text, time: timeController.text, status: 0)),
      //       }
      //       else{
      //         print("Error: " + error),
      //       },
      //     });
      //   },
      //   tooltip: 'Lưu',
      //   child: const Text("Lưu công việc", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // _selectDate(BuildContext context) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2050),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     selectedDate = picked;
  //     setState(() {
  //       dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
  //       dateFocus.requestFocus();
  //     });
  //   }
  //   else if (picked == selectedDate) {
  //     return;
  //   }
  //   else {
  //     setState(() {
  //       dateController.clear();
  //       selectedDate = DateTime.now();
  //     });
  //   }
  // }
  //
  // _selectTime(BuildContext context) async {
  //   TimeOfDay? picked = await showTimePicker(
  //       context: context, initialTime: TimeOfDay.now());
  //   if (picked != null && picked != selectedTime) {
  //     selectedTime = picked;
  //     setState(() {
  //       String hour = selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}";
  //       String minute = selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}";
  //       timeController.text = hour + ":" + minute;
  //       timeFocus.requestFocus();
  //     });
  //   }
  //   else if (picked == selectedTime) {
  //     return;
  //   }
  //   else {
  //     setState(() {
  //       timeController.clear();
  //       selectedTime = TimeOfDay.now();
  //     });
  //   }
  // }
  //
  // bool check(){
  //   error = "";
  //   if (descriptionController.text.isEmpty){
  //     error = "Chưa nhập công việc cần làm";
  //     return false;
  //   }
  //
  //   if(dateController.text.isEmpty){
  //     error = "Chưa chọn ngày thực hiện";
  //     return false;
  //   }
  //
  //   if(timeController.text.isEmpty){
  //     error = "Chưa chọn giờ thực hiện";
  //     return false;
  //   }
  //
  //   return true;
  // }
// Text showError(){
//   return ;
// }
}