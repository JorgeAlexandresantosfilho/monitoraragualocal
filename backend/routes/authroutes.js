const express = require('express');
const router = express.Router();
const authController = require('../controllers/authcontrollers');
const verificarToken = require('../middlewares/verificartoken');

router.post('/login', authController.login);
router.post('/logout', verificarToken, authController.logout);


// Rota usando a verificacao (para teste)
router.get('/perfil', verificarToken, (req, res) => {
  res.status(200).json({ mensagem: 'Acesso autorizado', usuarioId: req.usuarioId });
});

module.exports = router;
