import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'http://192.168.0.105:3000/monitoapi';

  static Future<Map<String, dynamic>> register({
    required String usuario,
    required String nomeusuario,
    required String telefone,
    required String email,
    required String login,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': usuario,
          'nomeusuario': nomeusuario,
          'telefone': telefone,
          'email': email,
          'login': login,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Cadastro realizado com sucesso'};
      } else {
        final body = jsonDecode(response.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Erro ao cadastrar'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}
