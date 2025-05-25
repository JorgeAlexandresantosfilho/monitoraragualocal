const express = require('express');
const router = express.Router();
const usuarioController = require('../controllers/usuariocontrollers');

//rotas pro usuario
router.post('/usuarios', usuarioController.criarUsuario);
router.get('/usuarios', usuarioController.listarUsuarios);
router.get('/usuarios/:id', usuarioController.buscarUsuario);
router.put('/usuarios/:id', usuarioController.atualizarUsuario);
router.delete('/usuarios/:id', usuarioController.deletarUsuario);
//rota pra recuperacao de senha
router.post('/usuarios/recuperar-senha', usuarioController.recuperarSenha);

module.exports = router;
