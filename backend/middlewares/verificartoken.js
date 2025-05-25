const jwt = require('jsonwebtoken');
const secret = process.env.JWT_SECRET || 'chave';

//verificar token
function verificarToken(req, res, next) {
  
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ mensagem: 'Token não fornecido' });
  }

  
  const tokenSemBearer = token.split(' ')[1]; 

  
  jwt.verify(tokenSemBearer, secret, (err, decoded) => {
    if (err) {
      return res.status(401).json({ mensagem: 'Token inválido' });
    }

    //salva as informacoes do token na requisicao
    req.usuarioId = decoded.id;
    next(); 
  });
}

module.exports = verificarToken;
