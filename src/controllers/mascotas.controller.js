const pool = require('../database/dbConection');
const { Router } = require('express');
const router = Router();

/**Esta función hace un INSERT dentro de la tabla, t_mascotas
 * dados los campos que vienen en el "req" de la petición
 * 
 * Retorna el id_mascota del registro que se acaba de insertar,
 * en caso de que se haya hecho el INSERT, o retorna
 * 0 en caso de que no se haya insertado
 */
const crear = async(req) => {

    try {

        let id_mascota = false;
        

        const {
            nombre_mascota,
            edad_mascota,
            escala_edad,
            esterilizado,
            genero_mascota,
            id_raza,
            id_tamanio,
            id_color,
            descripcion_mascota,
            id_usuario,
            tipo_tramite,
            //vacunas
            id_vacuna_Rabia ,
            id_vacuna_Rinotraqueítis,
            id_vacuna_Parvovirus,
            id_vacuna_Moquillo,
            //ubicacion geograficas
            id_codigo
        } = req.body;

        /**En caso de que los campos "id_tamanio" o "descripcion_mascota"
         * no vengan en la petición se les asigna null 
         */
        const respuesta =
            await pool.query(`INSERT INTO t_mascotas
                (nombre_mascota,
                edad_mascota,
                escala_edad,
                esterilizado,
                genero_mascota,
                id_raza,
                id_tamanio,
                id_color,
                descripcion_mascota,
                id_usuario,
                tipo_tramite,
                id_codigo) 
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11,$12) 
                RETURNING id_mascota`, [
                nombre_mascota,
                edad_mascota,
                escala_edad,
                esterilizado,
                genero_mascota,
                id_raza,
                id_tamanio || null,
                id_color,
                descripcion_mascota || null,
                id_usuario,
                tipo_tramite,
                id_codigo
            ]);

        /**Si rowCount es igual a 1 quiere decir que el INSERT
         * se ejecutó correctamente */
        if (respuesta.rowCount === 1) {
            /**Se obtiene el id_mascota del registro que se acaba
             * de insertar
             */
            id_mascota = respuesta.rows[0].id_mascota;


  

            //////////////////////////////////////////////////////
            let body = req.body
            if ( body.id_vacuna_Rabia === 'true'){
                const respuesta1 = await( pool.query(`INSERT INTO public.t_mascotas_vacunas( id_vacuna, id_mascota)VALUES ($1, $2);`, [1,id_mascota]));
            }else{
                console.log('no tiene vacuna contra la rabia')
            }



            if ( body.id_vacuna_Rinotraqueítis === 'true'){
                const respuesta2 = await( pool.query(`INSERT INTO public.t_mascotas_vacunas(id_vacuna, id_mascota)VALUES ($1, $2);`, [2,id_mascota]));
            }else{
               console.log('no tiene vacuna contra la Rinotraqueítis')
            }



            if ( body.id_vacuna_Parvovirus === 'true'){
                const respuesta3 = await( pool.query(`INSERT INTO public.t_mascotas_vacunas( id_vacuna, id_mascota)VALUES ($1, $2);`, [3,id_mascota]));
                
            }else{
                console.log('no tiene vacuna contra la Parvovirus')
            }


            if ( body.id_vacuna_Moquillo === 'true'){
                const respuesta2 = await( pool.query(`INSERT INTO public.t_mascotas_vacunas( id_vacuna, id_mascota)VALUES ($1, $2);`, [ 4,id_mascota]))
                
            }else{
                console.log('no tiene vacuna contra Moquillo')
               
            }


   
        }
        /**En caso contrario quiere decir que rowCount NO vale 1,
         * y el INSERT no se ejecutó
         */
        else {
            //Se le asigna 0 
            id_mascota = 0;
        }

        return id_mascota;

    } catch (err) {

        throw new Error(`Archivo mascotas.controller.js->crear()\n${err}`);

    }
}





/**Obtiene todos los campos de un registro en la tabla
 * adopcion, dado el id_mascota
 *
 * La función retorna un objeto con los valores de los campos
 * de la adopcion en caso de que ésta se haya encontrado, o
 * retorna null en caso de que la adopcion no exista
 */
const obtenerPorId = async(id_mascota) => {

    try {

        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              CASE 
                              WHEN(t_tamanios.tamanio IS NULL) THEN 'N/A'
                              ELSE t_tamanios.tamanio
                              END AS tamaño,  
                              t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota, 
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              LEFT JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_mascotas.id_mascota = $1`, [id_mascota]);

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
        throw new Error(`Archivo mascotas.controller.js->obtenerPorId()\n${err}`);
    }
}

/**Obtiene todos datos de las t_mascotas registradas */
const obtenerTodas = async() => {
    try {
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              CASE 
                              WHEN(t_tamanios.tamanio IS NULL) THEN 'N/A'
                              ELSE t_tamanios.tamanio
                              END AS tamaño, 
                              t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota, 
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              LEFT JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota`);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerTodas()\n${err}`);
    }
}


/**Obtiene todos los nombres de las vacunas agregadas
 * a un determinado registro dentro de la tabla "t_mascotas"
 * 
 * La función retorna un objeto con los valores de los campos
 * especificados en el SELECT en caso de que ésta se haya encontrado, o
 * retorna null en caso de que la adopcion no exista
 */
const obtenerVacunasPorid_mascota = async(id_mascota) => {

    try {

        let respuesta =
            await pool.query(`SELECT t_vacunas.nombre "Nombre"
                              FROM t_mascotas_vacunas INNER JOIN t_vacunas ON
                              t_mascotas_vacunas.id_vacuna = t_vacunas.id 
                              INNER JOIN t_mascotas ON 
                              t_mascotas_vacunas.id_mascota = t_mascotas.id_mascota
                              WHERE t_mascotas.id_mascota = $1
                              GROUP BY t_vacunas.nombre`, [id_mascota]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerVacunasPorid_mascota()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que sean de un determinado tipo de mascota*/
const obtenerPorTipoMascota = async(nombre_tipo) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "nombre_tipo" que se recibe como parámetro
         * 
         * Se hace un LEFT JOIN a la tabla "tamanios" para que se muestren
         * todos los datos de la consulta aunque no tenga registros asociados
         * en la tabla "tamanios"
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              CASE 
                              WHEN(t_tamanios.tamanio IS NULL) THEN 'N/A'
                              ELSE t_tamanios.tamanio
                              END AS tamaño, 
                              t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota, 
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              LEFT JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tipos_mascotas.nombre_tipo ILIKE $1`, [nombre_tipo]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerPorTipoMascota()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que tengan un determinado tamaño*/
const obtenerPorTananio = async(tamanio) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "tamanio" que se recibe como parámetro
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              t_tamanios.tamanio, t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota,  
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              INNER JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tamanios.tamanio ILIKE $1`, [tamanio]);

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
        throw new Error(`Archivo t_mascotas.controller.js -> obtenerPorTananio()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que tengan un determinado color*/
const obtenerPorColor = async(nombre_color) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "nombre_color" que se recibe como parámetro
         * 
         * Se hace un LEFT JOIN a la tabla "tamanios" para que se muestren
         * todos los datos de la consulta aunque no tenga registros asociados
         * en la tabla "tamanios"
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              CASE 
                              WHEN(t_tamanios.tamanio IS NULL) THEN 'N/A'
                              ELSE t_tamanios.tamanio
                              END AS tamaño,
                              t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota,
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              LEFT JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_colores.nombre_color ILIKE $1`, [nombre_color]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerPorColor()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que tengan un determinado tipo de mascota y tamaño*/
const obtenerPorTipoMascotaYTamanio = async(nombre_tipo, tamanio) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "nombre_tipo" y "tamanio" que se reciben como parámetro
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              t_tamanios.tamanio, t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota, 
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              INNER JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tipos_mascotas.nombre_tipo ILIKE $1 AND 
                              t_tamanios.tamanio ILIKE $2`, [nombre_tipo, tamanio]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerPorTipoMascotaYTamanio()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que tengan un determinado tamaño y color*/
const obtenerPorTamanioYColor = async(tamanio, nombre_color) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "tamanio" y "nombre_color" que se reciben como parámetro
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              t_tamanios.tamanio, t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota,  
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              INNER JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tamanios.tamanio ILIKE $1 
                              AND t_colores.nombre_color ILIKE $2`, [tamanio, nombre_color]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerPorTamanioYColor()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que tengan un determinado tipo de mascota y color*/
const obtenerPorTipoMascotaYColor = async(nombre_tipo, nombre_color) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "nombre_tipo" y "nombre_color" que se reciben como parámetro
         * 
         * Se hace un LEFT JOIN a la tabla "tamanios" para que se muestren
         * todos los datos de la consulta aunque no tenga registros asociados
         * en la tabla "tamanios"
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              CASE 
                              WHEN(t_tamanios.tamanio IS NULL) THEN 'N/A'
                              ELSE t_tamanios.tamanio
                              END AS tamaño, 
                              t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota,  
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              LEFT JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tipos_mascotas.nombre_tipo ILIKE $1 AND 
                              t_colores.nombre_color ILIKE $2`, [nombre_tipo, nombre_color]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerPorTipoMascotaYColor()\n${err}`);
    }
}

/**Obtiene todas las t_mascotas registradas 
 * que tengan un determinado tipo de mascota, tamanio y color*/
const obtenerPorTipoMascotaTamanioYColor = async(nombre_tipo, tamanio, nombre_color) => {

    try {

        /**Se utiliza ILIKE para que ignore las mayúsculas y minusculas 
         * en el "nombre_tipo", "tamanio" 
         * y "nombre_color" que se reciben como parámetro
         *
         */
        let respuesta =
            await pool.query(`SELECT t_mascotas.id_mascota, t_tipos_mascotas.nombre_tipo AS "tipo_mascota",
                              t_mascotas.nombre_mascota, t_mascotas.edad_mascota, 
                              t_mascotas.genero_mascota, t_razas.nombre_raza, 
                              CASE 
                              WHEN(t_tamanios.tamanio IS NULL) THEN 'N/A'
                              ELSE t_tamanios.tamanio
                              END AS tamaño, 
                              t_colores.nombre_color,
                              CASE
                              WHEN(t_mascotas.descripcion_mascota IS NULL) THEN 'N/A'
                              ELSE t_mascotas.descripcion_mascota
                              END AS descripcion_mascota,  
                              t_usuario.nombres || ' ' || t_usuario.apellidos AS "propietario"  
                              FROM t_mascotas INNER JOIN t_colores ON
                              t_mascotas.id_color = t_colores.id_color
                              INNER JOIN t_razas ON
                              t_mascotas.id_raza = t_razas.id_raza
                              INNER JOIN t_tamanios ON
                              t_mascotas.id_tamanio = t_tamanios.id_tamanio
                              INNER JOIN t_usuario ON
                              t_mascotas.id_usuario = t_usuario.id
                              INNER JOIN t_tipos_mascotas ON
                              t_razas.id_tipo_mascota = t_tipos_mascotas.id_tipo_mascota
                              WHERE t_tipos_mascotas.nombre_tipo ILIKE $1 AND 
                              t_tamanios.tamanio ILIKE $2
                              AND t_colores.nombre_color ILIKE $3`, [
                nombre_tipo,
                tamanio,
                nombre_color
            ]);

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
        throw new Error(`Archivo mascotas.controller.js -> obtenerPorTipoMascotaTamanioYColor()\n${err}`);
    }
}

const obtenerMascotaPorId = async (id) => {

    try {
        let respuesta = await pool.query('SELECT * FROM t_mascotas WHERE id_mascota = $1', [id]);

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
        throw new Error(`Archivo mascotas.controller.js->obtenerMascotaPorId()\n${err}`);
    }
}

module.exports = {
    crear,
    obtenerPorId,
    obtenerTodas,
    obtenerVacunasPorid_mascota,
    obtenerPorTipoMascota,
    obtenerPorTananio,
    obtenerPorColor,
    obtenerPorTipoMascotaYTamanio,
    obtenerPorTamanioYColor,
    obtenerPorTipoMascotaYColor,
    obtenerPorTipoMascotaTamanioYColor,
    obtenerMascotaPorId
}