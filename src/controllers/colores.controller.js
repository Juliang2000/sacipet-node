const pool = require('../database/dbConection');

/**Obtiene todos los colores registrados
 * dentro de la tabla "colores"
 */

const obtenerTodos = async() => {
    try {
        let respuesta =
            await pool.query('SELECT * FROM t_colores');

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
        throw new Error(`Archivo colores.controller.js -> obtenerTodos()\n${err}`);
    }
}

/**Obtiene todos los campos de un color, dado el id_color*/
const obtenerPorIdColor = async(id_color) => {
    try {
        let respuesta =
            await pool.query('SELECT * FROM t_colores WHERE id_color = $1', [id_color]);

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
        throw new Error(`Archivo colores.controller.js -> obtenerPorIdColor()\n${err}`);
    }
}

module.exports = {
    obtenerTodos,
    obtenerPorIdColor
}