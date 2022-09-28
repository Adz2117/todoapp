import 'package:adztodo/models/todo_model.dart';
import 'package:adztodo/repository/db_repo.dart';
import 'package:adztodo/screens/home_screen/todo_delegate.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<TodoModel> todoModels =[];

  GlobalKey<FormState> myFormKey= GlobalKey<FormState>();

  getdata() async{
    DbRepo dbRepo = DbRepo();
    await dbRepo.openDb();
    List<Map<String, dynamic>> mapsList = await dbRepo.retrieveDB('todos');
    setState(() {
      todoModels = mapsList.map((e) => TodoModel(todotext: e['todotext'], isDone: e['isDone'] == 1 ? true : false, id: e['id'])).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Todo app'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: todoModels.map((e) => TodoDelegate(todoModel: e,)).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: const Color(0xFF67daff),
          foregroundColor: Colors.black,
          onPressed:(){

            String? newTodoText;

            showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    color: Colors.white,
                    child: Form(
                      key: myFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,spreadRadius: 5,blurRadius: 6
                                  )
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  isDense: true
                                ),
                                validator: (text){
                                  if(text!.isEmpty){
                                    return "this field can not be empty , please complete it";
                                  }
                                  return null;
                                },
                                onSaved: (text){
                                  newTodoText = text!;
                                },
                              ),
                            ),
                            Container(height: 20,),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.white)
                              ),
                                onPressed: () async {
                                  if(myFormKey.currentState!.validate()){
                                    myFormKey.currentState!.save();

                                    DbRepo dbRepo = DbRepo();
                                    await dbRepo.openDb();
                                    Map<String , dynamic> newTodosData = {
                                      "todotext " : newTodoText,
                                      "isDone" : 0
                                    };
                                    await dbRepo.insertDb(newTodosData, 'todos');
                                    getdata();

                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,borderRadius: BorderRadius.all(Radius.elliptical(15, 10))
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [Text('Submit')],
                                  ),
                                )
                            )
                          ],
                        )),
                  ),
                )
            );
          },
      child: const Icon(Icons.add_sharp),
      ),
    );
  }
}
