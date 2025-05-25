import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlterScreen extends StatefulWidget {
  const AlterScreen({super.key});

  @override
  State<AlterScreen> createState() => _AlterScreenState();
}

class _AlterScreenState extends State<AlterScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  Future<void> redefinirSenha() async {
    final login = loginController.text.trim();
    final senha = senhaController.text.trim();
    final confirmar = confirmarSenhaController.text.trim();

    if (senha != confirmar) {
      mostrarAlerta("Erro", "As senhas não coincidem.");
      return;
    }

    final url = Uri.parse(
      'http://192.168.0.105:3000/monitoapi/usuarios/recuperar-senha',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"login": login, "novaSenha": senha}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        mostrarAlerta("Sucesso", "Senha redefinida com sucesso!");

        
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        mostrarAlerta("Erro", data["mensagem"] ?? "Erro ao redefinir senha.");
      }
    } catch (e) {
      mostrarAlerta("Erro", "Erro de conexão: $e");
    }
  }

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(titulo, style: const TextStyle(color: Colors.white)),
        content: Text(mensagem, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Recupere sua senha",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: loginController,
              style: const TextStyle(color: Colors.white),
              decoration: buildInputDecoration("Digite seu login"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: buildInputDecoration("Nova senha"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmarSenhaController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: buildInputDecoration("Confirmar nova senha"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: redefinirSenha,
              child: const Text("Redefinir senha"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Voltar para login",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
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
    );
  }
}
