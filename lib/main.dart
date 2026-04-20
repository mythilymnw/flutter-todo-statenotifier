import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'core/abstract_todo_service.dart';
import 'service/todo_service_impl.dart';
import 'viewmodel/todo_provider.dart';
import 'views/todo_screen.dart';

void main() {
  final firestore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
       
        Provider<AbstractTodoService>(
          create: (_) => TodoServiceImpl(firestore),
        ),

      
        ChangeNotifierProvider(
          create: (context) =>
              TodoProvider(context.read<AbstractTodoService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TodoScreen());
  }
}
