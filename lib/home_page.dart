import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/todo_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var url = "https://mocki.io/v1/996532b2-5815-4c10-b3da-0bd42d81e7a0";
    Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body) as List;
        final transformed = json.map((e) {
          return Todo(
              id: e['id'],
              title: e['title'],
              completed: e['completed'],
              priority: e['priority']);
        }).toList();
        setState(() {
          todos = transformed;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 13, 32),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 13, 32),
        title: const Text(
          "Todo List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final currentTodo = todos[index];
            return ListTile(
                title: Text(
                  currentTodo.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Row(
                  children: [
                    Text("Completed - ${currentTodo.completed}"),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Priority - ${currentTodo.priority}"),
                  ],
                ),
                leading: currentTodo.completed
                    ? Image.asset("assets/check.png")
                    : Image.asset("assets/delete.png"));
          }),
    );
  }
}
