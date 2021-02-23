const pool = require('../database/dbConection');

/**Obtiene todos datos de los tipos de mascotas registradas */
const obtenerTodos = async() => {
    try {
        let respuesta =
            await pool.query("SELECT id_codigo,descripcion FROM t_ubicaciones_geograficas WHERE t_ubicaciones_geograficas.id_unde=1 AND t_ubicaciones_geograficas.vigente='true'");

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
        throw new Error(`Archivo departamentos.controller.js -> obtenerTodos()\n${err}`);
    }
}

module.exports = { obtenerTodos }