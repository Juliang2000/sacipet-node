const pool = require('../database/dbConection');


/**
 * Esta función hace un INSERT dentro de la tabla, r_rol_usuario
 * dado el id del usuario y el id_rol que ingresan
 * @param {number} id_usuario
 * @param {number} id_rol 
 * @returns {number} retorna el id de creacion de la tabla
 */
const asociarUsuarioRol = async (id_usuario, id_rol) => {

    try {

        let rolUsuarioCreado = false;

        const respuesta =
            await pool.query(`INSERT INTO t_rol_usuario
                         (id_rol, id_usuario) 
                         VALUES ($1, $2)`, [id_rol, id_usuario]);

        if (respuesta.rowCount === 1) {
            rolUsuarioCreado = true;
        }

        return rolUsuarioCreado;

    } catch (err) {

        throw new Error(`Archivo rol.controller.js -> asociarUsuarioRol()\n${err}`);

    }
};

module.exports = {
    asociarUsuarioRol
}