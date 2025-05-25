import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  int? userId;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
      _usuarioController.text = prefs.getString('usuario') ?? '';
      _nomeController.text = prefs.getString('nomeusuario') ?? '';
      _telefoneController.text = prefs.getString('telefone') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _loginController.text = prefs.getString('login') ?? '';
      _senhaController.text = prefs.getString('senha') ?? '';
    });
  }

  Future<void> _updateUser() async {
    if (userId == null) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://192.168.0.105:3000/monitoapi/usuarios/$userId');
    final body = jsonEncode({
      "usuario": _usuarioController.text,
      "nomeusuario": _nomeController.text,
      "telefone": _telefoneController.text,
      "email": _emailController.text,
      "login": _loginController.text,
      "senha": _senhaController.text,
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
       
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuario', _usuarioController.text);
        await prefs.setString('nomeusuario', _nomeController.text);
        await prefs.setString('telefone', _telefoneController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('login', _loginController.text);
        await prefs.setString('senha', _senhaController.text);

        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        final data = jsonDecode(response.body);
        _showDialog('Erro', data['message'] ?? 'Erro ao atualizar dados');
      }
    } catch (e) {
      _showDialog('Erro', 'Falha na conexão: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField(_usuarioController, 'Usuário'),
            _buildTextField(_nomeController, 'Nome do Usuário'),
            _buildTextField(_telefoneController, 'Telefone'),
            _buildTextField(_emailController, 'E-mail'),
            _buildTextField(_loginController, 'Login'),
            _buildTextField(_senhaController, 'Senha', obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _isLoading ? null : _updateUser,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
