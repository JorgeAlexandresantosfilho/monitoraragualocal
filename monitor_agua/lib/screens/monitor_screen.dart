import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MonitoramentoScreen extends StatefulWidget {
  const MonitoramentoScreen({Key? key}) : super(key: key);

  @override
  State<MonitoramentoScreen> createState() => _MonitoramentoScreenState();
}

class _MonitoramentoScreenState extends State<MonitoramentoScreen> {
  BluetoothConnection? connection;
  bool isConnected = false;
  String nivelAgua = "N/A";

  Future<void> conectarDispositivo() async {
    try {
      BluetoothDevice? hc05 = (await FlutterBluetoothSerial.instance.getBondedDevices())
          .firstWhere((device) => device.name == "Wl_hc_05", orElse: () => throw Exception("HC-05 não pareado"));

      await BluetoothConnection.toAddress(hc05.address).then((_connection) {
        connection = _connection;
        setState(() => isConnected = true);
        print("Conectado ao HC-05!");

        connection!.input!.listen((data) {
          String recebidos = utf8.decode(data).trim();
          print("Dado recebido: $recebidos");

          if (recebidos.contains(RegExp(r'[0-9]'))) {
            double? valor = double.tryParse(recebidos);
            if (valor != null) {
              setState(() {
                nivelAgua = "$valor cm";
              });
              enviarParaBackend(valor);
            }
          }
        });
      });
    } catch (e) {
      print("Erro ao conectar: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
  }

  void desconectar() {
    connection?.dispose();
    setState(() {
      isConnected = false;
      nivelAgua = "N/A";
    });
  }

  Future<void> enviarParaBackend(double nivel) async {
    final url = Uri.parse("http://192.168.0.105:3000/monitoapi/registros");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nivel_agua": nivel}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Registro enviado com sucesso!");
    } else {
      print("Erro ao enviar para backend: ${response.statusCode} - ${response.body}");
    }
  }

  @override
  void dispose() {
    if (isConnected) connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monitoramento de Nível de Água")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Nível atual da água:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(nivelAgua, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isConnected ? null : conectarDispositivo,
              child: Text("Iniciar Monitoramento"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isConnected ? desconectar : null,
              child: Text("Parar Monitoramento"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
