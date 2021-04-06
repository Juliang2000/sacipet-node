const pool = require('../database/dbConection');

/**Esta función hace un INSERT dentro de la tabla, fotos
 * dados los campos que vienen en el "req" de la petición
 * 
 * Retorna el id del registro que se acaba de insertar,
 * en caso de que se haya hecho el INSERT, o retorna
 * 0 en caso de que no se haya insertado
 */
const crear = async(ruta_guardado,nombre_imagen,id_mascota,consecutivo) => {

    try {

        let id = false;

        const respuesta =
            await pool.query(`INSERT INTO t_fotos
                (ruta_guardado,
                nombre_imagen, 
                id_mascota,
                consecutivo) 
                VALUES ($1, $2, $3, $4)
                RETURNING id`, [ruta_guardado,nombre_imagen,
                id_mascota,consecutivo
            ]);

        /**Si rowCount es igual a 1 quiere decir que el INSERT
         * se ejecutó correctamente */
        if (respuesta.rowCount === 1) {

            /**Se obtiene el id del registro que se acaba
             * de insertar
             */
            id = respuesta.rows[0].id;
        }
        /**En caso contrario quiere decir que rowCount NO vale 1,
         * y el INSERT no se ejecutó
         */
        else {
            //Se le asigna 0 
            id = 0;
        }

        return id;

    } catch (err) {

        throw new Error(`Archivo fotos.controller.js -> crear()\n${err}`);

    }
}

/**Obtiene el campo "ruta_guardado" de la tabla "fotos"
 *
 * La función retorna un objeto con los valores de los campos
 * de la adopcion en caso de que ésta se haya encontrado, o
 * retorna null en caso de que la adopcion no exista
 */
const obtenerFoto = async(id) => {

    try {

        let respuesta =
            await pool.query(`SELECT * FROM t_fotos 
                WHERE id = $1`, [id]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna al response el valor del atributo ruta_guardado
         * que está en la primera posición del array */
        else {
            respuesta = respuesta.rows[0].ruta_guardado;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo fotos.controller.js -> obtenerFoto()\n${err}`);
    }
}

const fotosPorId = async(id) => {

    try {
        let respuesta =
            await pool.query(`SELECT * FROM t_fotos 
                WHERE id_mascota = $1`, [id]);

        /**Se verifica si la respuesta es vacio
         */
        if (JSON.stringify(respuesta.rows) === '[]') {
            //Se le asigna null a la respuesta
            respuesta = 0;
        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * se retorna el array */
        else {
            respuesta = respuesta.rows
        }
        return respuesta;

    } catch (err) {
        throw new Error(`Contar fotos fotos.controller.js -> obtenerFoto()\n${err}`);
    }
}

const obtenerIdFoto = async(id,consecutivo) => {

    try {

        let respuesta =
            await pool.query(`SELECT id FROM t_fotos 
                WHERE id_mascota = $1 AND consecutivo=$2`, [id,consecutivo]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna al response el valor del atributo ruta_guardado
         * que está en la primera posición del array */
        else {            
            respuesta = respuesta.rows[0].id;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo fotos.controller.js -> obtenerNombreFoto()\n${err}`);
    }
}




//////////////////////////////////////////////////////////////////
////////usuario foto//////////////////////////////////


const crearfusuario = async(ruta_guardado,nombre_imagen,id_usuario,consecutivo) => {

    try {

        let id = false;

        const respuesta =
            await pool.query(`INSERT INTO t_fotos_user
                (ruta_guardado,
                nombre_imagen, 
                id_usuario,
                consecutivo) 
                VALUES ($1, $2, $3, $4)
                RETURNING id`, [ruta_guardado,nombre_imagen,
                    id_usuario,consecutivo
            ]);

        /**Si rowCount es igual a 1 quiere decir que el INSERT
         * se ejecutó correctamente */
        if (respuesta.rowCount === 1) {

            /**Se obtiene el id del registro que se acaba
             * de insertar
             */
            id = respuesta.rows[0].id;
        }
        /**En caso contrario quiere decir que rowCount NO vale 1,
         * y el INSERT no se ejecutó
         */
        else {
            //Se le asigna 0 
            id = 0;
        }

        return id;

    } catch (err) {

        throw new Error(`Archivo fotos.controller.js -> crearfusuario()\n${err}`);

    }
}



const obtenerFotousuario = async(id) => {

    try {

        let respuesta =
            await pool.query(`SELECT * FROM t_fotos_user
                WHERE id = $1`, [id]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna al response el valor del atributo ruta_guardado
         * que está en la primera posición del array */
        else {
            respuesta = respuesta.rows[0].ruta_guardado;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo fotos.controller.js -> obtenerFotousuario()\n${err}`);
    }
}


const fotosPorIdusuario = async(id) => {

    try {
        let respuesta =
            await pool.query(`SELECT * FROM t_fotos_user
                WHERE id_usuario = $1`, [id]);

        /**Se verifica si la respuesta es vacio
         */
        if (JSON.stringify(respuesta.rows) === '[]') {
            //Se le asigna null a la respuesta
            respuesta = 0;
        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * se retorna el array */
        else {
            respuesta = respuesta.rows
        }
        return respuesta;

    } catch (err) {
        throw new Error(`Contar fotos fotos.controller.js -> fotosPorIdusuario()\n${err}`);
    }
}

const obtenerIdFotoUsuario = async(id,consecutivo) => {

    try {

        let respuesta =
            await pool.query(`SELECT id FROM t_fotos_user
                WHERE id_mascota = $1 AND consecutivo=$2`, [id,consecutivo]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna al response el valor del atributo ruta_guardado
         * que está en la primera posición del array */
        else {            
            respuesta = respuesta.rows[0].id;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo fotos.controller.js -> obtenerIdFotoUsuario()\n${err}`);
    }
}


module.exports = {
    crear,
    obtenerFoto,
    fotosPorId,
    obtenerIdFoto,
    ///fotos usuario
    crearfusuario,
    obtenerFotousuario,
    fotosPorIdusuario,
    obtenerIdFotoUsuario


}