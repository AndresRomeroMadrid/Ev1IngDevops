const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8085;

// Servir archivos estáticos desde la carpeta 'public'
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

// Ruta explícita para la raíz por si express.static falla por alguna razón
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Servidor Node.js corriendo en http://localhost:${PORT}`);
});
