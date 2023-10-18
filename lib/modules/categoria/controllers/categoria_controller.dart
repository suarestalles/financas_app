import 'dart:developer';

import 'package:financas_pessoais_flutter/modules/categoria/models/categoria_model.dart';
import 'package:financas_pessoais_flutter/modules/categoria/repository/categoria_repository.dart';
import 'package:financas_pessoais_flutter/utils/back_routes.dart';
import 'package:flutter/material.dart';

class CategoriaController extends ChangeNotifier {

  List<Categoria> categorias = [];

  create(BuildContext context, {Categoria? oldCategoria}) {
    var formKey = GlobalKey<FormState>();
    var nomeController = TextEditingController(text: oldCategoria?.nome);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          oldCategoria == null ? 'Nova Categoria' : 'Editar Categoria',
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
            onPressed: () async {
              if(formKey.currentState?.validate() ?? false) {
                var categoria = Categoria(nome: nomeController.text)..id = oldCategoria?.id;
                oldCategoria == null
                  ? await save(categoria)
                  : await update(categoria);
                notifyListeners();
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
            label: Text(oldCategoria == null ? 'Salvar' : 'Atualizar'),
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
        List<Categoria> lista =
            response.map<Categoria>((e) => Categoria.fromMap(e)).toList();
            categorias = lista;
        return categorias;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> save(Categoria categoria) async {
    var categoriaRepository = CategoriaRepository();
    try {
      final response = await categoriaRepository.save(
          BackRoutes.baseUrl + BackRoutes.CATEGORIA_SAVE, categoria);
      if (response != null) {
        Categoria categoria =
            Categoria.fromMap(response as Map<String, dynamic>);
        categorias.add(categoria);
        log(categorias.length.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> delete(Categoria categoria) async {
    var categoriaRepository = CategoriaRepository();
    try {
      final response = await categoriaRepository.delete(
          BackRoutes.baseUrl + BackRoutes.CATEGORIA_DELETE, categoria);
      if (response != null) {
        categorias.remove(categoria);
        notifyListeners();
        log(categorias.length.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update(Categoria categoria) async {
    var categoriaRepository = CategoriaRepository();
    try {
      final response = await categoriaRepository.update(
          BackRoutes.baseUrl + BackRoutes.CATEGORIA_UPDATE, categoria);
      if (response != null) {
        Categoria newCategoria =
            Categoria.fromMap(response as Map<String, dynamic>);
        categorias.add(newCategoria);
        categorias.remove(categoria);
        log(categorias.length.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  edit(BuildContext context, Categoria categoria) async {
    create(context, oldCategoria: categoria);
  }
}