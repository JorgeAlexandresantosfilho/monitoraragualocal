const express = require('express');
const router = express.Router();
const logController = require('../controllers/logcontrollers');

// Rota para listar  os logs
router.get('/logs', logController.listarLogs);

module.exports = router;
