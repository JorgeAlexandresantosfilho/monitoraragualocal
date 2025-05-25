import 'package:flutter/material.dart';
import '../models/log_model.dart';
import '../services/log_service.dart';

class LogReportScreen extends StatefulWidget {
  const LogReportScreen({super.key});

  @override
  State<LogReportScreen> createState() => _LogReportScreenState();
}

class _LogReportScreenState extends State<LogReportScreen> {
  List<LogModel> logs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    try {
      final fetchedLogs = await LogService.getLogs();
      setState(() {
        logs = fetchedLogs;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      _showError('Erro ao buscar logs: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
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

  String formatarData(String? data) {
    if (data == null || data.isEmpty) return 'Sem data';
    try {
      final dateTime = DateTime.parse(data).toLocal();
      return '${dateTime.day.toString().padLeft(2,'0')}/'
          '${dateTime.month.toString().padLeft(2,'0')}/'
          '${dateTime.year} '
          '${dateTime.hour.toString().padLeft(2,'0')}:'
          '${dateTime.minute.toString().padLeft(2,'0')}';
    } catch (e) {
      return 'Sem data';
    }
  }

  Widget _buildLogItem(LogModel log) {
    return Card(
      color: Colors.deepPurple.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        title: Text('Ação: ${log.tpacao}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login Usuário: ${log.loginusuario}'),
            Text('Data: ${formatarData(log.datacao)}'),
            Text('ID Registro: ${log.idregistro ?? "N/A"}'),
            Text('Descrição antiga: ${log.dsregold ?? "N/A"}'),
            Text('Descrição nova: ${log.dsregnew ?? "N/A"}'),
            Text('Tipo Ação antiga: ${log.tpacaoregold ?? "N/A"}'),
            Text('Tipo Ação nova: ${log.tpacaoregnew ?? "N/A"}'),
            Text('Nome usuário antigo: ${log.nomeusuarioold ?? "N/A"}'),
            Text('Nome usuário novo: ${log.nomeusuarionew ?? "N/A"}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Relatório de Logs'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum log encontrado.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (_, index) {
                    return _buildLogItem(logs[index]);
                  },
                ),
    );
  }
}
