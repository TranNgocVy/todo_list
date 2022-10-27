import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/database.dart';
import 'dart:async';

import 'package:todo_list/model/todo.dart';

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

  var formatterDate = new DateFormat('dd-MM-yyyy');
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
                decoration: InputDecoration(
                  hintText: '',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                  suffixIcon: (searchController.text.isNotEmpty && searchFocus.hasFocus) ?
                  IconButton(onPressed: () {setState(() {
                    searchController.clear();
                    searchFocus.unfocus();
                  });}, icon: Icon(Icons.clear)) :
                  Icon(Icons.search),
                ),

              ),
            ),
            Container(
              child: Row(
                  children: <String>["Tất cả", "Hôm nay", "Sắp tới"].map((type) => Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          selectType = type;
                        });
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
          _insertToDo(ToDo(id: todoList.length + 1, title: "Làm bài tập ${todoList.length + 1}", day: formatterDate.format(new DateTime.now()), time: formatterTime.format(new DateTime.now()), status: 0))
        },
        tooltip: 'Thêm',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//
// // main.dart
// import 'package:flutter/material.dart';
//
// import 'temp.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Remove the debug banner
//         debugShowCheckedModeBanner: false,
//         title: 'Kindacode.com',
//         theme: ThemeData(
//           primarySwatch: Colors.orange,
//         ),
//         home: const HomePage());
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   // All journals
//   List<Map<String, dynamic>> _journals = [];
//
//   bool _isLoading = true;
//   // This function is used to fetch all data from the database
//   void _refreshJournals() async {
//     final data = await SQLHelper.getItems();
//     setState(() {
//       _journals = data;
//       _isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshJournals(); // Loading the diary when the app starts
//   }
//
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//
//   // This function will be triggered when the floating button is pressed
//   // It will also be triggered when you want to update an item
//   void _showForm(int? id) async {
//     if (id != null) {
//       // id == null -> create new item
//       // id != null -> update an existing item
//       final existingJournal =
//       _journals.firstWhere((element) => element['id'] == id);
//       _titleController.text = existingJournal['title'];
//       _descriptionController.text = existingJournal['description'];
//     }
//
//     showModalBottomSheet(
//         context: context,
//         elevation: 5,
//         isScrollControlled: true,
//         builder: (_) => Container(
//           padding: EdgeInsets.only(
//             top: 15,
//             left: 15,
//             right: 15,
//             // this will prevent the soft keyboard from covering the text fields
//             bottom: MediaQuery.of(context).viewInsets.bottom + 120,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               TextField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(hintText: 'Title'),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(hintText: 'Description'),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Save new journal
//                   if (id == null) {
//                     await _addItem();
//                   }
//
//                   if (id != null) {
//                     await _updateItem(id);
//                   }
//
//                   // Clear the text fields
//                   _titleController.text = '';
//                   _descriptionController.text = '';
//
//                   // Close the bottom sheet
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(id == null ? 'Create New' : 'Update'),
//               )
//             ],
//           ),
//         ));
//   }
//
// // Insert a new journal to the database
//   Future<void> _addItem() async {
//     await SQLHelper.createItem(
//         _titleController.text, _descriptionController.text);
//     _refreshJournals();
//   }
//
//   // Update an existing journal
//   Future<void> _updateItem(int id) async {
//     await SQLHelper.updateItem(
//         id, _titleController.text, _descriptionController.text);
//     _refreshJournals();
//   }
//
//   // Delete an item
//   void _deleteItem(int id) async {
//     await SQLHelper.deleteItem(id);
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Successfully deleted a journal!'),
//     ));
//     _refreshJournals();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kindacode.com'),
//       ),
//       body: _isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : ListView.builder(
//         itemCount: _journals.length,
//         itemBuilder: (context, index) => Card(
//           color: Colors.orange[200],
//           margin: const EdgeInsets.all(15),
//           child: ListTile(
//               title: Text(_journals[index]['title']),
//               subtitle: Text(_journals[index]['description']),
//               trailing: SizedBox(
//                 width: 100,
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _showForm(_journals[index]['id']),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () =>
//                           _deleteItem(_journals[index]['id']),
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _showForm(null),
//       ),
//     );
//   }
// }