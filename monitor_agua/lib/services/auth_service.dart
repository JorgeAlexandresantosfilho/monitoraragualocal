import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.105:3000/auth';

 static Future<Map<String, dynamic>> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // <- corrigido
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': username, 'senha': password}),
    );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final body = jsonDecode(response.body);
        return {'success': false, 'message': body['message'] ?? 'Erro ao logar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}
//a funcao pra guardar os dados do usuario usando sharedpreferences 
Future<void> saveUserData(Map<String, dynamic> userData) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('id', userData['id']);
  prefs.setString('nomeusuario', userData['nomeusuario']);
  prefs.setString('login', userData['login']);
  prefs.setString('email', userData['email']);
}