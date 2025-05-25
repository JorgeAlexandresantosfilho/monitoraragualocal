import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetooth_terminal_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothDiscoveryScreen extends StatefulWidget {
  @override
  _BluetoothDiscoveryScreenState createState() => _BluetoothDiscoveryScreenState();
}

class _BluetoothDiscoveryScreenState extends State<BluetoothDiscoveryScreen> {
  List<BluetoothDevice> devices = [];
//aqui pedimos a permissao do bluetooth e tambem trazemos os resultados
  @override
  void initState() {
    super.initState();
    _askPermissions(); 
    _getBondedDevices(); 
  }

  Future<void> _askPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();
  }

  void _getBondedDevices() async {
    List<BluetoothDevice> bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      devices = bondedDevices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos Bluetooth')),
      body: devices.isEmpty
          ? const Center(child: Text('Nenhum dispositivo pareado encontrado.'))
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Sem nome'),
                  subtitle: Text(device.address),
                  trailing: const Icon(Icons.bluetooth),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BluetoothTerminalScreen(device: device),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
