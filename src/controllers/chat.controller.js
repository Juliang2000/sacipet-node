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
            await pool.query("SELECT fecha_envio, visto, mensaje FROM chat where primer_usuario = $1 OR segundo_usuario = $2 order by fecha_envio,id;", [primer_usuario, segundo_usuario]);


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





const EnviarPregunta = async (primer_usuario, segundo_usuario, fecha_envio, mensaje,id_mascota) => {
    try {
        let respuesta =
            await pool.query("INSERT INTO public.t_preguntas(primer_usuario, segundo_usuario, fecha_envio, mensaje,id_mascota) VALUES ($1, $2, $3, $4,$5) RETURNING id;", [primer_usuario, segundo_usuario, fecha_envio, mensaje,id_mascota]);


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



const EnviarRespuesta = async (respuesta,id) => {
    try {
        let respuestaS =
            await pool.query("UPDATE public.t_preguntas SET respuesta=$1 WHERE id=$2;", [respuesta,id]);


        if (JSON.stringify(respuestaS.rows) === '[]') {


            respuestaS = null;

        }

        else {
            respuestaS = respuesta.rows;
        }

        return respuestaS;

    } catch (err) {
        throw new Error(`${err}`);
    }
}




const ObtenerPreguntasRespuestas = async (primer_usuario, id_mascota) => {
    try {
        let respuestaS = 
            await pool.query("SELECT id, fecha_envio, mensaje, respuesta,primer_usuario,segundo_usuario FROM public.t_preguntas where primer_usuario = $1 AND id_mascota=$2 ORDER BY fecha_envio,id;", [primer_usuario, id_mascota]);


        if (JSON.stringify(respuestaS.rows) === '[]') {


            respuestaS = null;

        }

        else {
            respuestaS = respuestaS.rows;
        }

        return respuestaS;

    } catch (err) {
        throw new Error(`${err}`);
    }
}

module.exports = {
    EnviarMensajes,
    ObtenerMensaje,
    EnviarPregunta,
    EnviarRespuesta,
    ObtenerPreguntasRespuestas
}