const db = require('../config/banco');
//hamada do banco
async function inserirRegistro(nivel_agua) {
  const [result] = await db.execute('CALL insert_registro(?)', [nivel_agua]);
  return result;
}

async function listarRegistros() {
  const [rows] = await db.query('SELECT * FROM registro');
  return rows;
}

async function atualizarRegistro(id, nivel_agua) {
  const [result] = await db.execute('CALL update_registro(?, ?)', [id, nivel_agua]);
  return result;
}

async function deletarRegistro(id) {
  const [result] = await db.execute('CALL delete_registro(?)', [id]);
  return result;
}

module.exports = {
  inserirRegistro,
  listarRegistros,
  atualizarRegistro,
  deletarRegistro
};
