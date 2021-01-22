const pool = require('../database/dbConection');
const jwt = require("jsonwebtoken");

const bcrypt = require('bcrypt');
const { OAuth2Client } = require('google-auth-library'); // autenticacion google
const client = new OAuth2Client(process.env.CLIENT_ID); // autenticacion google

/**
 * Decodifica  el token dado y  retorna un objeto con los
 * datos del usuario
 * @param {string} token  el token de google
 * @return {object} usuario
 */
async function decodificarToken(token) { // decodifica y google valida el token
    try {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: process.env.CLIENT_ID,

        });
        const payload = ticket.getPayload(); // carga los datos 
        return payload   //retorna la carga de los datos

    } catch (error) {
        console.error(error)
    }
}



/**
 * llama a jwt para crear el token y devuelve un objeto
 * @param {object} usuarioDb 
 */
async function generarToken(usuarioDb) {
    const tokenGenerado = jwt.sign({

        nombre: usuarioDb.nombres,
        apellidos: usuarioDb.apellidos,
        correo: usuarioDb.correo,
        id: usuarioDb.id,
        rol: usuarioDb.rol,
        origen_cuenta: usuarioDb.origen_cuenta

    }, process.env.SEED, { expiresIn: process.env.CADUCIDAD_TOKEN });// firma el token genera_
    return tokenGenerado
}


module.exports = {
    decodificarToken,
    generarToken

}