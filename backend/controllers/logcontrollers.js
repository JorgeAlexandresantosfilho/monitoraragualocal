const logModel = require('../models/logmodels');

async function listarLogs(req, res) {
  try {
    const logs = await logModel.listarLogs();
    res.status(200).json(logs);
  } catch (error) {
    res.status(500).json({ mensagem: 'Erro ao listar logs.', erro: error.message });
  }
}

module.exports = {
  listarLogs
};
