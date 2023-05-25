import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

import '../Widgets/todo_item_list.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();

  List<Todo> tasks = [];

  Todo? deletedtTodo;
  int? deletedTodoPos;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Ex. Estudar matemática',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      String text = taskController.text;
                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        tasks.add(newTodo);
                      });
                      taskController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff00d7f3),
                      padding: EdgeInsets.all(14),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in tasks)
                      TodoListItem(
                        tasks: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui ${tasks.length} tarefas pendentes',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: showDeletedTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14)),
                    child: Text('Limpar Tudo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedtTodo = todo;
    deletedTodoPos = tasks.indexOf(todo);

    setState(() {
      tasks.remove(todo);
    });


    // cancelar deletação da tarefa
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa ${todo.title} foi removida com sucesso!!"),
        action: SnackBarAction(
          label: "Cancelar",
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              tasks.insert(deletedTodoPos!, deletedtTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // função do botão limpar tudo
  void showDeletedTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limpar tudo?"),
        content: Text("você tem certeza que deseja excluir todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Color(0xff00d7f3)),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deletedAllTodos();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text("Limpar tudo"),
          ),
        ],
      ),
    );
  }
  void deletedAllTodos() {
    setState(() {
      tasks.clear();
    });
  }
}
