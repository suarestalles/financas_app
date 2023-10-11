import 'package:financas_pessoais_flutter/modules/categoria/controllers/categoria_controller.dart';
import 'package:financas_pessoais_flutter/modules/categoria/models/categoria_model.dart';
import 'package:financas_pessoais_flutter/modules/categoria/repository/categoria_repository.dart';
import 'package:financas_pessoais_flutter/utils/back_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriaListPage extends StatelessWidget {
  CategoriaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categorias'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.lightBlueAccent,
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                color: Colors.amber,
                child: const Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('assets/images/avatar.png'),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Bem-Vindo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Consumer<CategoriaController>(
          builder: (context, controller, child) => FutureBuilder(
            future: controller.findAll(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<Categoria> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) => Card(
                      child: ListTile(
                        title: Text(data[index].nome),
                        trailing: const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Erro ao buscar categorias..."),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<CategoriaController>().create(context),
          child: const Icon(Icons.book),
        ));
  }
}
