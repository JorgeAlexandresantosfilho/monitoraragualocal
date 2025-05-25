const usuarioModel = require('../models/usuariomodels');

// controller criar usuario
async function criarUsuario(req, res) {
  const { usuario, nomeusuario, telefone, email, login, senha } = req.body;
  if (!usuario || !nomeusuario || !telefone || !email || !login || !senha) {
    return res.status(400).json({ mensagem: 'Todos os campos são obrigatórios.' });
  }

  try {
    const resultado = await usuarioModel.inserirUsuario(usuario, nomeusuario, telefone, email, login, senha);
    res.status(201).json({ mensagem: 'Usuário criado com sucesso.', resultado });
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao criar usuário.', erro: error.message });
  }
}

// controller listar usuarios
async function listarUsuarios(req, res) {
  try {
    const usuarios = await usuarioModel.listarUsuarios();
    res.status(200).json(usuarios);
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao listar usuários.', erro: error.message });
  }
}
// controller de busca usuario
async function buscarUsuario(req, res) {
  const id = req.params.id;
  try {
    const usuario = await usuarioModel.buscarUsuarioPorId(id);
    if (!usuario) return res.status(404).json({ mensagem: 'Usuário não encontrado.' });
    res.status(200).json(usuario);
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao buscar usuário.', erro: error.message });
  }
}

// controller atualizar usuario
async function atualizarUsuario(req, res) {
  const id = req.params.id;
  const { usuario, nomeusuario, telefone, email, login, senha } = req.body;
  try {
    const resultado = await usuarioModel.atualizarUsuario(id, usuario, nomeusuario, telefone, email, login, senha);
    res.status(200).json({ mensagem: 'Usuário atualizado com sucesso.', resultado });
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao atualizar usuário.', erro: error.message });
  }
}
// controller deletar usuario
async function deletarUsuario(req, res) {
  const id = req.params.id;
  try {
    const resultado = await usuarioModel.deletarUsuario(id);
    res.status(200).json({ mensagem: 'Usuário deletado com sucesso.', resultado });
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao deletar usuário.', erro: error.message });
  }
}
// controller recuperacao de senha do  usuario
async function recuperarSenha(req, res) {
  const { login, novaSenha } = req.body;
  if (!login || !novaSenha) {
    return res.status(400).json({ mensagem: 'Login e nova senha são obrigatórios.' });
  }

  try {
    const resultado = await usuarioModel.recuperarSenha(login, novaSenha);
    res.status(200).json({ mensagem: 'Senha atualizada com sucesso.', resultado });
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao recuperar senha.', erro: error.message });
  }
}


module.exports = {
  criarUsuario,
  listarUsuarios,
  buscarUsuario,
  atualizarUsuario,
  deletarUsuario,
  recuperarSenha
};
