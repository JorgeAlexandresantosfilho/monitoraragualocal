# Monitorar Nível de Água

Este projeto tem como objetivo monitorar o nível de água utilizando um sensor ultrassônico conectado ao Arduino, que envia os dados via Bluetooth para um aplicativo mobile feito em Flutter. Os dados são armazenados em um banco MySQL e podem ser visualizados no app. É ideal para reservatórios ou caixas d’água.

## 📱 Aplicativo Mobile (Frontend)

- **Framework:** Flutter
- **Bibliotecas:** http, flutter_bluetooth_serial

### Funcionalidades
- Cadastro e login de usuários, recuperação de senha
- Conexão com Arduino via Bluetooth
- Visualização do nível de água
- Histórico de logs
- Edição de perfil
- Integração com Mysql e Backend

## 🧠 Backend (Node.js + MySQL)

- **Framework:** Express.js
- **Banco de Dados:** MySQL
- **Segurança:** Bcrypt para criptografia de senhas
- **Padrão:** MVC com separação de camadas (`controllers`, `models`, `routes`)

### Endpoints da API

#### 👤 Usuários

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/monitoapi/usuarios` | Cadastrar usuário |
| GET | `/monitoapi/usuarios` | Listar todos |
| GET | `/monitoapi/usuarios/:id` | Buscar por ID |
| PUT | `/monitoapi/usuarios/:id` | Atualizar usuário |
| DELETE | `/monitoapi/usuarios/:id` | Deletar usuário |
| POST | `/monitoapi/usuarios/recuperar-senha` | Atualizar senha do usuário |

#### 📝 Registros

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/monitoapi/registros` | Listar registros |
| PUT | `/monitoapi/registros/:id` | Atualizar |
| DELETE | `/monitoapi/registros` | Deletar todos |

#### 🔐 Autenticação

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/auth` | Login (JSON com login e senha) |

#### 🧾 Logs

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/api/logs` | Visualizar logs de ações do sistema |

## 🤖 Arduino

- **Componentes:**
  - Arduino UNO
  - Sensor Ultrassônico HC-SR04
  - Módulo Bluetooth HC-05
  - Jumpers, protoboard

### Funcionamento
1. O sensor HC-SR04 mede a distância da água até o sensor.
2. Os dados são enviados via Bluetooth para o app.
3. O app envia os dados para o backend.
4. O backend grava no MySQL e registra no log (via trigger).
5. Os dados podem ser visualizados no app.

### Esquema de Ligação (Resumo)
- HC-SR04: VCC → 5V, GND → GND, Trig → D9, Echo → D10
- HC-05: VCC → 5V, GND → GND, RX → TX, TX → RX (com divisor de tensão)

## ⚙️ Como rodar

### Backend
```bash
git clone <repo>
cd backend
npm install
npm run dev
```
- Configure o `.env` com:
  - DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
  - PORT

### Frontend (Flutter)
```bash
cd nivel_de_agua
flutter clean
flutter pub get
flutter run
```


## 🗄 Estrutura do Banco de Dados

### Tabela `usuarios`
- idusuario, usuario, nomeusuario, telefone, email, login, senha

### Tabela `registro`
- idregistro, nivelagua, data_hora

### Tabela `log`
- idlog, tpacao, loginusuario, datahora, idregistro, dsregold, dsregnew, tpacaoregold, tpacaoregold, nomeusuarioold, nomeusuarionew

Triggers cuidam de alimentar a tabela `log` automaticamente com base nas ações do usuário.

## ✅ Conclusão

Este sistema integra hardware (Arduino), mobile (Flutter) e backend (Node.js + MySQL) para uma solução de monitoramento completa. Pode ser expandido com notificações, alertas de nível crítico e automações.

---
