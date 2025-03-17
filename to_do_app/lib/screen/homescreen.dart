import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo_model.dart';
import 'package:to_do_app/screen/loginscreen.dart';
import 'package:to_do_app/services/auth_service.dart';
import 'package:to_do_app/services/database_service.dart';
import 'package:to_do_app/widgets/completedwidget.dart';
import 'package:to_do_app/widgets/pendingwidgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _buttonIndex = 0;

  final _widgets = [
    //pending Task Widget
    PendingWidgets(),
    //Completed Task Widget
    CompletedWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text('Todo'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _buttonIndex == 0 ? Colors.indigo : Colors.white,
                      //  border: _buttonIndex == 0? Border.all(color: Colors.black) : Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        "Pending",
                        style: TextStyle(
                            fontSize: _buttonIndex == 0 ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 0
                                ? Colors.white
                                : Colors.black38),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _buttonIndex == 0 ? Colors.indigo : Colors.white,
                      //  border: _buttonIndex == 0? Border.all(color: Colors.black) : Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        "Completed",
                        style: TextStyle(
                            fontSize: _buttonIndex == 0 ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 0
                                ? Colors.white
                                : Colors.black38),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          _showTaskDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
  void _showTaskDialog(BuildContext context,{Todo? todo}) {
    final TextEditingController _titleController = TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController = TextEditingController(text: todo?.description);
    final DatabaseService _databaseService = DatabaseService();

    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(todo != null ? "Add Task" : "Edit Task",
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller:_titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller:_descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
          child: Text("Cancel")
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: Text(todo == null ? "Add" : "Update"),
            onPressed: ()async{
              if(todo == null){
                await _databaseService.addTodoTask(
                  _titleController.text, 
                  _descriptionController.text);
              }else{
                await _databaseService.updateTodo(
                  todo.id,
                  _titleController.text, 
                  _descriptionController.text,
                  );
              }
              Navigator.pop(context);
            }, 
            
            )
        ],
      );
    },);
  }
}
