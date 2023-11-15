import 'dart:developer';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:financas_pessoais_flutter/modules/categoria/controllers/categoria_controller.dart';
import 'package:financas_pessoais_flutter/modules/categoria/models/categoria_model.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/conta_dto.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/conta_model.dart';
import 'package:financas_pessoais_flutter/modules/conta/repository/conta_repository.dart';
import 'package:financas_pessoais_flutter/utils/back_routes.dart';
import 'package:financas_pessoais_flutter/utils/utils.dart';
import 'package:financas_pessoais_flutter/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class ContaController extends ChangeNotifier {
  List<Conta> contas = [];
  Categoria? categoriaSelected;
  String? tipoSelected;
  final dataController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final destinoOrigemController = TextEditingController();

  selectedCategoria(Categoria categoria) {
    categoriaSelected = categoria;
  }

  create(BuildContext context, {Conta? oldConta}) async {
    final formKey = GlobalKey<FormState>();
    categoriaSelected = oldConta?.categoria;
    tipoSelected = oldConta?.tipo == false ? 'Receita' : 'Despesa';
    dataController.text = oldConta?.data == null ? '' : Utils.convertDate(oldConta!.data);
    descricaoController.text = oldConta?.descricao ?? '';
    valorController.text = oldConta?.valor == null ? '' : UtilBrasilFields.obterReal(oldConta!.valor);
    destinoOrigemController.text = oldConta?.destinoOrigem ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(oldConta == null ? 'Nova Conta' :
          'Editando Conta',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    hintText: 'Tipo de Conta',
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Despesa',
                      child: Text('Despesa'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Receita',
                      child: Text('Receita'),
                    ),
                  ],
                  onChanged: (value) {
                    tipoSelected = value ?? 'Despesa';
                    notifyListeners();
                  },
                  validator: Validatorless.required('Campo Obrigatório!'),
                  value: tipoSelected,
                ),
                FutureBuilder<List<Categoria>?>(
                    future:
                        Provider.of<CategoriaController>(context, listen: false)
                            .findAll(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var categorias = snapshot.data!;
                        return DropdownButtonFormField(
                          value: categoriaSelected != null ? categorias.firstWhere((element) => element.id == categoriaSelected?.id) : null,
                          items: categorias
                              .map(
                                (e) => DropdownMenuItem<Categoria>(
                                  value: e,
                                  child: Text(e.nome),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            categoriaSelected = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Categorias',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Campo Obrigatório!';
                            }
                            return null;
                          },
                        );
                      }
                      return const CircularProgressIndicator();
                    }),
                TextFormField(
                  controller: dataController,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<ContaController>(context).tipoSelected ==
                                'Despesa'
                            ? 'Data Pagamento'
                            : 'Data Recebimento',
                  ),
                  validator: Validatorless.required('Campo Obrigatório!'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    selecionarData(context);
                  }
                ),
                TextFormField(
                  controller: descricaoController,
                  decoration: const InputDecoration(hintText: 'Descrição'),
                  validator: Validatorless.required('Campo Obrigatório!'),
                ),
                TextFormField(
                  controller: valorController,
                  decoration: const InputDecoration(hintText: 'Valor'),
                  validator: Validatorless.multiple([
                    Validatorless.required('Campo Obrigatório!'),
                    Validators.minDouble(0.01, 'Valor Inválido!')
                  ]),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(casasDecimais: 2),
                  ],
                ),
                TextFormField(
                  controller: destinoOrigemController,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<ContaController>(context).tipoSelected ==
                                'Despesa'
                            ? 'Destino'
                            : 'Origem',
                  ),
                  validator: Validatorless.required('Campo Obrigatório!'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                var conta = Conta(
                  categoria: categoriaSelected!,
                  tipo: tipoSelected == 'Despesa' ? true : false,
                  data: Utils.convertDate(dataController.text),
                  descricao: descricaoController.text,
                  valor: Utils.converterMoedaParaDouble(valorController.text),
                  destinoOrigem: destinoOrigemController.text,
                  status: false,
                )..id = oldConta?.id;
                oldConta == null ? await save(conta) : await update(conta);
                notifyListeners();
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
            label: Text(oldConta == null ? 'Salvar' : 'Atualizar'),
          ),
        ],
      ),
    );
  }

  Future<List<Conta>?> findAll() async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository
          .getAll(BackRoutes.baseUrl + BackRoutes.CONTA_ALL);
      if (response != null) {
        List<Conta> lista =
            response.map<Conta>((e) => Conta.fromMap(e)).toList();
        contas = lista;
        return contas;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> save(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.save(
          BackRoutes.baseUrl + BackRoutes.CONTA_SAVE, conta);
      if (response != null) {
        Conta conta = Conta.fromMap(response as Map<String, dynamic>);
        contas.add(conta);
        log(contas.length.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> delete(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.delete(
          BackRoutes.baseUrl + BackRoutes.CONTA_DELETE, conta);
      if (response != null) {
        contas.remove(conta);
        notifyListeners();
        log(contas.length.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.update(
          BackRoutes.baseUrl + BackRoutes.CONTA_UPDATE, conta);
      if (response != null) {
        Conta newConta = Conta.fromMap(response as Map<String, dynamic>);
        contas.add(newConta);
        contas.remove(conta);
        log(contas.length.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ContaDTO?> resumo() async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository
          .resumo(BackRoutes.baseUrl + BackRoutes.CONTA_RESUMO);
      if (response != null) {
        ContaDTO contaDTO = ContaDTO.fromMap(response);
        return contaDTO;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> selecionarData(BuildContext context) async {
    final dataSelecionada = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));
    if (dataSelecionada != null) {
      dataController.text = DateFormat('dd/MM/yyyy').format(dataSelecionada);
    }
    notifyListeners();
  }

  edit(BuildContext context, Conta conta) async {
    create(context, oldConta: conta);
  }
}
