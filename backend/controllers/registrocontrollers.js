const registroModel = require('../models/registromodels');
//post
async function criarRegistro(req, res) {
  const { nivel_agua } = req.body;

  try {
    const result = await registroModel.inserirRegistro(nivel_agua);
    res.status(201).json({ mensagem: 'Registro de nível de água inserido', result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensagem: 'Erro ao criar registro de nível de água', erro: error.message });
  }
}
//get
async function listarRegistros(req, res) {
  try {
    const registros = await registroModel.listarRegistros();
    res.status(200).json(registros);
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensagem: 'Erro ao listar registros', erro: error.message });
  }
}
//put
async function atualizarRegistro(req, res) {
  const { id } = req.params;
  const { nivel_agua } = req.body;

  try {
    const result = await registroModel.atualizarRegistro(id, nivel_agua);
    res.status(200).json({ mensagem: 'Registro de nível de água atualizado com sucesso', result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensagem: 'Erro ao atualizar registro de nível de água', erro: error.message });
  }
}
//delete
async function deletarRegistro(req, res) {
  const { id } = req.params;

  try {
    const result = await registroModel.deletarRegistro(id);
    res.status(200).json({ mensagem: 'Registro de nível de água deletado com sucesso', result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensagem: 'Erro ao deletar registro de nível de água', erro: error.message });
  }
}

module.exports = {
  criarRegistro,
  listarRegistros,
  atualizarRegistro,
  deletarRegistro
};
