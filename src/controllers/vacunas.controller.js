const pool = require('../database/dbConection');

/**Obtiene todos datos de las vacunas registradas */
const obtenerTodas = async() => {
    try {
        let respuesta =
            await pool.query('SELECT * FROM t_vacunas');

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 o varios registros
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * de todos los registros encontrados*/
        else {
            respuesta = respuesta.rows;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo vacunas.controller.js -> obtenerTodas()\n${err}`);
    }
}

/**Obtiene todos los campos de un registro en la tabla "vacunas" 
 * dado su "id_vacuna".
 *  
 * La función retorna un objeto con los valores de los campos
 * del usuario en caso de que éste se haya encontrado, o
 * retorna null en caso de que el usuario no exista
 */
const obtenerPorId = async(id) => {

    try {
        let respuesta = await pool.query('SELECT * FROM t_vacunas WHERE id = $1', [id]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * del registro encontrado que está en la primera posición del array */
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo vacunas.controller.js->obtenerPorId()\n${err}`);
    }
}

module.exports = {
    obtenerTodas,
    obtenerPorId
}