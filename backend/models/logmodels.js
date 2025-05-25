const db = require('../config/banco');

async function listarLogs() {
  const [rows] = await db.query('SELECT * FROM log');
  return rows;
}

module.exports = {
  listarLogs
};
