import 'package:financas_pessoais_flutter/modules/abstract/models/abstract_entity_model.dart';

class Categoria extends AbstractEntity {
  String nome;

  Categoria({
    required this.nome,
  });

@override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      nome: map['nome'] as String,
    )..
    id = map['id'] as int;
  }
}
