class ContaDTO {
  double? totalReceita;
  double? totalDespesa;
  double? saldo;

  ContaDTO({
    required this.totalReceita,
    required this.totalDespesa,
    required this.saldo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalReceita': totalReceita,
      'totalDespesa': totalDespesa,
      'saldo': saldo,
    };
  }

  factory ContaDTO.fromMap(Map<String, dynamic> map) {
    return ContaDTO(
      totalReceita: map['totalReceita'] as double,
      totalDespesa: map['totalDespesa'] as double,
      saldo: map['saldo'] as double,
    );
  }
}