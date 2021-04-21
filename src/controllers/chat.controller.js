const pool = require('../database/dbConection');
const { Router } = require('express');
const router = Router();

const EnviarMensajes = async (primer_usuario, segundo_usuario, fecha_envio, visto, mensaje) => {
    try {
        let respuesta =
            await pool.query("INSERT INTO public.chat(primer_usuario, segundo_usuario, fecha_envio, visto, mensaje) VALUES ($1, $2, $3, $4, $5);", [primer_usuario, segundo_usuario, fecha_envio, visto, mensaje]);


        if (JSON.stringify(respuesta.rows) === '[]') {


            respuesta = null;

        }

        else {
            respuesta = respuesta.rows;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`${err}`);
    }
}



const ObtenerMensaje = async (primer_usuario, segundo_usuario) => {
    try {
        let respuesta =
            await pool.query("SELECT * FROM chat where primer_usuario = $1 OR segundo_usuario = $2 order by fecha_envio;", [primer_usuario, segundo_usuario]);


        if (JSON.stringify(respuesta.rows) === '[]') {


            respuesta = null;

        }

        else {
            respuesta = respuesta.rows;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`${err}`);
    }
}




module.exports = {
    EnviarMensajes,
    ObtenerMensaje
}