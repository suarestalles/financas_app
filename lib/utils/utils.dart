import 'package:intl/intl.dart';

class Utils{
  static convertDate(String data) {
    try{
      if (data.contains('T')) {
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(data));
      } else {
        return data.split(RegExp(r'(/|-)')).reversed.join(data.contains("/") ? '-' : '/');
      }
    } catch (e) {
      return "";
    }
  }

  static double converterMoedaParaDouble(String? valor) {
    if (valor == null) {
      valor = "0";
    } else if (valor == "null") {
      valor = "0";
    }
    final value = double.tryParse(
        valor.replaceAll(RegExp(r'[^0-9,]+'), '').replaceAll(',', '.'));
    return value ?? 0;
  }
}