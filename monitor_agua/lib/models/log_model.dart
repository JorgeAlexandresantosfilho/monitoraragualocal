class LogModel {
  final String tpacao;
  final String loginusuario;
  final String datacao; 
  final String? idregistro;
  final String? dsregold;
  final String? dsregnew;
  final String? tpacaoregold;
  final String? tpacaoregnew;
  final String? nomeusuarioold;
  final String? nomeusuarionew;

  LogModel({
    required this.tpacao,
    required this.loginusuario,
    required this.datacao,
    this.idregistro,
    this.dsregold,
    this.dsregnew,
    this.tpacaoregold,
    this.tpacaoregnew,
    this.nomeusuarioold,
    this.nomeusuarionew,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      tpacao: json['tpacao'] ?? '',
      loginusuario: json['login_usuario'] ?? '',
      datacao: json['dataacao'] ?? '',
      idregistro: json['id_registro']?.toString(),
      dsregold: json['dsregold'],
      dsregnew: json['dsregnew'],
      tpacaoregold: json['tpacaogold'], 
      tpacaoregnew: json['tpacaornew'],  
      nomeusuarioold: json['nomeusuarioold'],
      nomeusuarionew: json['nomeusuarionew'],
    );
  }
}
