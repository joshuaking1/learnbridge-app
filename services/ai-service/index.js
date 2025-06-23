// services/ai-service/index.js
require('dotenv').config();
const express = require('express');

const app = express();
const PORT = process.env.PORT || 8000;

app.get('/', (req, res) => {
  res.send('LearnBridge AI Service is running!');
});

app.listen(PORT, () => {
  console.log(`AI Service listening on port ${PORT}`);
});