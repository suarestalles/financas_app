import 'package:financas_pessoais_flutter/modules/categoria/pages/categoria_list_page.dart';
import 'package:financas_pessoais_flutter/modules/conta/controllers/conta_controller.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/conta_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContaListPage extends StatelessWidget {
  const ContaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContaController>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contas'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.lightBlueAccent,
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.amber,
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.jpg')),
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
              MenuItemButton(
                style: const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20, horizontal: 20))),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CategoriaListPage())),
                child: const Text('Categorias'),
              ),
              MenuItemButton(
                style: const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20, horizontal: 20))),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContaListPage())),
                child: const Text('Contas'),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: controller.findAll(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Conta> data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) => Card(
                    child: ListTile(
                      title: Text(data[index].descricao),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => controller.edit(context, data[index]),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.amber,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.delete(data[index]),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("Erro ao buscar contas..."),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.create(context, oldConta: null),
          child: const Icon(Icons.book),
        ));
  }
}
