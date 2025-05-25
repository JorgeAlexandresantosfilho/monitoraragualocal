const express = require('express');
const router = express.Router();
const registroController = require('../controllers/registrocontrollers');

// Rota novo registro
router.post('/registros', registroController.criarRegistro);

// Rota pget para listar registros 
router.get('/registros', registroController.listarRegistros);

// Rota de atualizar registro
router.put('/registros/:id', registroController.atualizarRegistro);

// Rota para deletar registro
router.delete('/registros/:id', registroController.deletarRegistro);

module.exports = router;
