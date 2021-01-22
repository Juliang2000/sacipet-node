const pool = require('../database/dbConection');

/**Obtiene todos los tamaños registrados
 * dentro de la tabla "tamanios"
 */
const obtenerTodos = async() => {
    try {
        let respuesta =
            await pool.query('SELECT id_tamanio, tamanio FROM t_tamanios');

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
        throw new Error(`Archivo tamanios.controller.js -> obtenerTodos()\n${err}`);
    }
}

module.exports = {
    obtenerTodos
}