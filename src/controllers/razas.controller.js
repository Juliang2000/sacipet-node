const pool = require('../database/dbConection');

/**Obtiene el id_raza y el nombre_raza de las t_razas dado el id_tipo_mascota*/
const obtenerPorIdTipoMascota = async(id_tipo_mascota) => {

    try {
        let respuesta =
            await pool.query('SELECT id_raza, nombre_raza FROM t_razas WHERE id_tipo_mascota = $1', [id_tipo_mascota]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 o varios registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * de todos los registros encontrados*/
        else {
            respuesta = respuesta.rows;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo razas.controller.js -> obtenerPorIdTipoMascota()\n${err}`);
    }
}

/**Obtiene todos los campos de un registro en la tabla "t_razas", dado el id_raza*/
const obtenerPorIdRaza = async(id_raza) => {
    try {
        let respuesta =
            await pool.query('SELECT * FROM t_razas WHERE id_raza = $1', [id_raza]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 o varios registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * de todos los registros encontrados*/
        else {
            respuesta = respuesta.rows;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo razas.controller.js -> obtenerPorIdRaza()\n${err}`);
    }
}


/**Obtiene el campo "nombre_tipo" de la tabla "tipos_mascotas" 
 * y campo "nombre_raza" de la tabla "t_razas",
 * siempre y cuando el "id_raza" que se recibe por parámetro, 
 * esté asociado a un registro en la tabla "tipos_mascotas"
 * que tenga por nombre 'Perro'
 */
const obtenerMascotaTipoPerro = async(id_raza) => {
    try {
        let respuesta =
            await pool.query(`SELECT t_tipos_mascotas.nombre_tipo, t_razas.nombre_raza
                              FROM t_razas INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tipos_mascotas.nombre_tipo = 'Perro' 
                              AND t_razas.id_raza = $1`, [id_raza]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 o varios registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * de todos los registros encontrados*/
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo razas.controller.js -> obtenerMascotaTipoPerro()\n${err}`);
    }
}


const obtenerMascotaTipoGato = async(id_raza) => {
    try {
        let respuesta =
            await pool.query(`SELECT t_tipos_mascotas.nombre_tipo, t_razas.nombre_raza
            FROM t_razas INNER JOIN t_tipos_mascotas ON
            t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
            WHERE t_tipos_mascotas.nombre_tipo = 'Gato' 
            AND t_razas.id_raza = $1`, [id_raza]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 o varios registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * de todos los registros encontrados*/
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo razas.controller.js -> obtenerMascotaTipoGato()\n${err}`);
    }
}

module.exports = {
    obtenerPorIdTipoMascota,
    obtenerPorIdRaza,
    obtenerMascotaTipoPerro,
    obtenerMascotaTipoGato
}