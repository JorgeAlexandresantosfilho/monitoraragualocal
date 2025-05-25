const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const db = require('../config/banco');
const secret = process.env.JWT_SECRET || 'chave'; 

async function login(req, res) {
  const { login, senha } = req.body;

  try {
    const [rows] = await db.query('SELECT * FROM usuarios WHERE login = ?', [login]);

    if (rows.length === 0) {
      return res.status(401).json({ mensagem: 'Usuário não encontrado' });
    }

    const usuario = rows[0];
    const senhaCorreta = await bcrypt.compare(senha, usuario.senha);

    if (!senhaCorreta) {
      return res.status(401).json({ mensagem: 'Senha incorreta' });
    }

    // gerando o token 
    const token = jwt.sign(
      { id: usuario.idusuario, login: usuario.login },
      secret,
      { expiresIn: '1h' } // tempo para o token expirar no caso 1 hora
    );

    res.status(200).json({
      mensagem: 'Login realizado com sucesso',
      usuario: {
        id: usuario.idusuario,
        nomeusuario: usuario.nomeusuario,
        login: usuario.login,
        email: usuario.email
      },
      token //aqui o token vai pro front (flutter)
    });
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao realizar login', erro: error.message });
  }
}
function logout(req, res) {
  res.status(200).json({ mensagem: 'deslogado com sucesso' });
}

module.exports = {
  login,
  logout
}