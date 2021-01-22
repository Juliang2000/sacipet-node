const pool = require('../database/dbConection');

/**Esta función hace un INSERT dentro de la tabla, t_mascotas_vacunas
 * dados los campos que vienen en el "req" de la petición
 * 
 * Retorna true en caso de que se haya hecho el INSERT o retorna
 * false en caso de que no se haya insertado
 */
const crear = async(req) => {

    try {

        let id;

        const {
            id_vacuna,
            id_mascota
        } = req.body;

        const respuesta =
            await pool.query(`INSERT INTO t_mascotas_vacunas
                (id_vacuna, 
                id_mascota) 
                VALUES ($1, $2)
                RETURNING id`, [id_vacuna,
                id_mascota
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

        throw new Error(`Archivo mascotas_vacunas.controller.js->crear()\n${err}`);

    }
}



module.exports = {
    crear
}