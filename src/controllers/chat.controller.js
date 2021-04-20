const pool = require('../database/dbConection');
const { Router } = require('express');
const router = Router();

const EnviarMensajes = async (id_usuario) => {
    try {
        let respuesta =
            await pool.query("SELECT id_mascota, nombre_mascota, edad_mascota, escala_edad, esterilizado, id_raza, id_tamanio, id_color, descripcion_mascota, id_usuario, tipo_tramite, id_codigo, genero_mascota, publicado, id_formulario, solicitud_adopcion, id, nombres, telefono, correo FROM public.v_formulario where id_usuario = $1", [id_usuario]);


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
    
}