import 'dart:developer';

import 'package:financas_pessoais_flutter/modules/categoria/models/categoria_model.dart';
import 'package:financas_pessoais_flutter/modules/categoria/repository/categoria_repository.dart';
import 'package:financas_pessoais_flutter/utils/back_routes.dart';
import 'package:flutter/material.dart';

class CategoriaController extends ChangeNotifier {

  //   var categorias = [
  //   Categoria(
  //     nome: "FARMACIA",
  //   ),
  //   Categoria(
  //     nome: "MERCADO",
  //   ),
  // ];

  create(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Nova Categoria',
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório!';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              if(formKey.currentState?.validate() ?? false) {
                var categoria = Categoria(nome: nomeController.text);
                // categorias.add(categoria);
                Navigator.of(context).pop();
                notifyListeners();
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<List<Categoria>?> findAll() async {
    var categoriaRepository = CategoriaRepository();
    try {
      final response = await categoriaRepository
          .getAll(BackRoutes.baseUrl + BackRoutes.CATEGORIA_ALL);
      if (response != null) {
        List<Categoria> categorias =
            response.map<Categoria>((e) => Categoria.fromMap(e)).toList();
        return categorias;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}