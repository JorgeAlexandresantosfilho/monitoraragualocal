import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class BluetoothTerminalScreen extends StatefulWidget {
  final BluetoothDevice device;

  const BluetoothTerminalScreen({Key? key, required this.device}) : super(key: key);

  @override
  _BluetoothTerminalScreenState createState() => _BluetoothTerminalScreenState();
}

class _BluetoothTerminalScreenState extends State<BluetoothTerminalScreen> {
  BluetoothConnection? connection;
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    try {
      connection = await BluetoothConnection.toAddress(widget.device.address);
      setState(() => isConnected = true);

      connection!.input!.listen((data) {
        final message = String.fromCharCodes(data).trim();
        setState(() => messages.add('Arduino: $message'));
      });
    } catch (e) {
      setState(() => messages.add('Erro ao conectar: $e'));
    }
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty && connection != null && isConnected) {
      connection!.output.add(Uint8List.fromList(text.codeUnits));
      setState(() => messages.add('Você: $text'));
      messageController.clear();
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminal - ${widget.device.name}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: messages
                  .map((msg) => Text(msg, style: const TextStyle(color: Colors.white)))
                  .toList(),
            ),
          ),
          Container(
            color: Colors.deepPurple.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
