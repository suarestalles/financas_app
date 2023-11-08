import 'package:financas_pessoais_flutter/modules/categoria/controllers/categoria_controller.dart';
import 'package:financas_pessoais_flutter/modules/conta/controllers/conta_controller.dart';
import 'package:financas_pessoais_flutter/modules/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoriaController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContaController(),
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
    return const MaterialApp(
      title: 'App Finanças',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
