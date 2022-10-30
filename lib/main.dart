import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/addtodo.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/model/database.dart';
import 'dart:async';

import 'package:todo_list/model/todo.dart';
import 'package:todo_list/search/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'To do list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  String selectType = "Tất cả";
  bool ischeck = false;

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

  void _getToDayTodoList() async{
    final data = await Data.getToDayToDoList();
    setState(() {
      todoList = data;
      _isLoading = false;
    });
  }

  void _getUpComingTodoList() async{
    final data = await Data.getUpComingToDoList();
    setState(() {
      todoList = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getToDoList();// Loading the diary when the app starts
  }

  void _updateToDo(ToDo todo) async {
    await Data.updateToDo(todo);
    _getToDoList();
  }

  void _insertToDo(ToDo todo) async {
    await Data.insertTodo(todo);
    _getToDoList();
  }

  void _deleteToDo(ToDo todo) async {
    await Data.deleteToDo(todo);
    _getToDoList();
  }



  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
                controller: searchController,
                focusNode: searchFocus,
                decoration: InputDecoration(
                  hintText: '',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                  suffixIcon: (searchController.text.isNotEmpty && searchFocus.hasFocus) ?
                  IconButton(onPressed: () {setState(() {
                    searchController.clear();
                    searchFocus.unfocus();
                  });}, icon: Icon(Icons.clear)) :
                  IconButton(
                    onPressed: () {
                      if (searchController.text.isNotEmpty){
                        String description = searchController.text;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(search: description)));
                        setState(() {
                          searchController.clear();
                          searchFocus.unfocus();});
                      }
                    }, icon: Icon(Icons.search)
                  ),
                ),

              ),
            ),
            Container(
              child: Row(
                  children: <String>["Tất cả", "Hôm nay", "Sắp tới"].map((type) => Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: (){
                        if(selectType != type){
                          _changeTag(type);
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                        ),
                        backgroundColor:  selectType == type ? MaterialStateProperty.all(Colors.grey.shade100) : MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                            color: selectType == type ? Colors.blue : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                  )).toList()
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(1),
            //   decoration: BoxDecoration(
            //     border: Border(
            //       bottom: BorderSide(color: Colors.grey.shade300, width: 2)
            //     )
            //   ),
            // ),
            SizedBox(height: 5,),
            Container(
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


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _addToDo(context),
        },
        tooltip: 'Thêm',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _changeTag(String type){
    setState(() {
      selectType = type;
      if (type == "Hôm nay") {
        _getToDayTodoList();
      }
      else {
        if (type == "Sắp tới") {
          _getUpComingTodoList();
        }
        else {
          _getToDoList();
        }
      }
    });
  }

  Future<void> _addToDo(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToDoPage(id: todoList.length)),
    );

    if (result == true){
      _changeTag(selectType);
    }
  }
}
