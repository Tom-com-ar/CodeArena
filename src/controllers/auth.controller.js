const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { usuarios } = require('../data/usuarios');

const register = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Verificar si el usuario ya existe
        const existingUser = usuarios.find(user => user.email === email);
        if (existingUser) {
            return res.status(400).json({ message: 'El email ya está registrado' });
        }

        // Hash de la contraseña
        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(password, salt);

        // Crear nuevo usuario
        const newUser = {
            id: usuarios.length + 1,
            nombre: name,
            email,
            password_hash: passwordHash,
            rol: 'usuario',
            fecha_registro: new Date()
        };

        usuarios.push(newUser);

        res.status(201).json({ message: 'Usuario registrado exitosamente' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error en el servidor' });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Buscar usuario
        const user = usuarios.find(user => user.email === email);
        if (!user) {
            return res.status(401).json({ message: 'Credenciales inválidas' });
        }

        // Verificar contraseña
        const isValidPassword = await bcrypt.compare(password, user.password_hash);
        if (!isValidPassword) {
            return res.status(401).json({ message: 'Credenciales inválidas' });
        }

        // Generar token JWT
        const token = jwt.sign(
            { id: user.id, email: user.email, rol: user.rol },
            process.env.JWT_SECRET || 'secret_key',
            { expiresIn: '24h' }
        );

        // Actualizar último login
        user.ultimo_login = new Date();

        res.json({ token, message: 'Inicio de sesión exitoso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error en el servidor' });
    }
};

module.exports = {
    register,
    login
};