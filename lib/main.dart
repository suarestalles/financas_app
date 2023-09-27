import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List<String> contas = [
  'Teste',
  'Teste',
  'Teste',
  'Teste',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanças',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text('Minhas Finanças'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
          itemCount: contas.length,
          itemBuilder: (context, index) {
            return Text(contas[index]);
          }),
      ),
    );
  }
}
