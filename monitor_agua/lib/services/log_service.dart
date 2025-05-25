import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/log_model.dart';

class LogService {
  static Future<List<LogModel>> getLogs() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.105:3000/api/logs'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => LogModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar logs');
    }
  }
}
