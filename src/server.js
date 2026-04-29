const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.static('../'));

// Rutas
const authRoutes = require('./routes/auth.routes');
app.use('/auth', authRoutes);

// Ruta por defecto
app.get('/', (req, res) => {
    res.sendFile('index.html', { root: '../' });
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});