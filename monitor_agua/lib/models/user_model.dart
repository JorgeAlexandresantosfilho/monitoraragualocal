//guardando as informacoes
class UserModel {
  final String usuario;
  final String nomeusuario;
  final String telefone;
  final String email;
  final String login;

  UserModel({
    required this.usuario,
    required this.nomeusuario,
    required this.telefone,
    required this.email,
    required this.login,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      usuario: json['usuario'],
      nomeusuario: json['nomeusuario'],
      telefone: json['telefone'],
      email: json['email'],
      login: json['login'],
    );
  }
}
