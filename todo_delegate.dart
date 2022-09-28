import 'package:adztodo/models/todo_model.dart';
import 'package:adztodo/repository/db_repo.dart';
import 'package:flutter/material.dart';
class TodoDelegate extends StatefulWidget {
  TodoDelegate({Key? key,required this.todoModel}) : super(key: key);
  TodoModel todoModel;


  @override
  State<TodoDelegate> createState() => _TodoDelegateState();
}

class _TodoDelegateState extends State<TodoDelegate> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(widget.todoModel.isDone? Colors.green :Colors.red),
          overlayColor: MaterialStateProperty.all(Colors.blue),
        shadowColor: MaterialStateProperty.all(Colors.brown),
      ),
        onLongPress: ()async{
          DbRepo dbRepo = DbRepo();
          await dbRepo.openDb();
          await dbRepo.deleteDb('todos', widget.todoModel.id!);
        },
        onPressed: ()async{
        DbRepo dbRepo= DbRepo();
        await dbRepo.openDb();
        await dbRepo.updateDb('todos',
            {
              "todotext" : widget.todoModel.todotext,
              "isDone" : widget.todoModel.isDone? 0 : 1},
            widget.todoModel.id!
        );
          setState(() {
        widget.todoModel.isDone = !widget.todoModel.isDone;
      });
    },
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10,
                spreadRadius: 6
              )
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.todoModel.todotext,style: const TextStyle(fontSize: 30),),
              Icon(widget.todoModel.isDone? Icons.check_circle_rounded: Icons.dangerous_rounded ),
            ],),
        )
    );
  }
}
