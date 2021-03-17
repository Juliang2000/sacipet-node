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
const LlenarFormulario = async(req) => {

    try {

        let id_formulario = false;
        

        const {
            
            //informacion adpotante
            nombre_adoptante,
            direccion_adoptante,
            id_codigo,
            localidad,
            telefono,
            email,
            ocupacion,
            estado_civil,


            //sobre las mascotas

            //porque deseea adoptar una mascota
            pregunta_mascota_1,
            //actualmente tiene mas animales  ¿cuales?
            pregunta_mascota_2,
            //anteriormente ha tenido animales ¿cuales?
            pregunta_mascota_3,
            //esta de acuerdo con que se haga visita para ver como se encuentra el animal
            pregunta_mascota_4,
            
            //sobre familia

            //cuantas personas viven en su casa?
            pregunta_familia_1,
            //estan todos de aduerdo en adoptar?
            pregunta_familia_2,
            //alguien que viva con usted es alergico a los animales?
            pregunta_familia_3,
            //hay niños en la casa
            pregunta_familia_4,
            //en caso de alquiler ¿sus arrendadores permiten mascotas en el departamento?
            pregunta_familia_5,
            //si tuviera que cambiar de domicilio que pasaria con la mascota?
            pregunta_familia_6,
            //en caso de ruptura familiar(divorcio, fallecimiento) o la llegada de un nuevo familiar cuales serian los tratos hacie el animal adoptado?
            pregunta_familia_7,

            //sobre la adopcion 
            //que tamaño de mascota prefiere?(pequeño,mediano grande)
            pregunta_adpcion_1,
            //cuantos años cree que vive un perro o gato en promedio
            pregunta_adpcion_2,
            //como se ve con su mascota adoptada en 5 años
            pregunta_adpcion_3,
            //tiene espacio suficiente para que el animal se sienta comodo
            pregunta_adpcion_4,
            //donde dormira el animal adoptado?
            pregunta_adpcion_5,
            //cuantas horas al dia  pasara solo el animal adoptado
            pregunta_adpcion_6,
            //si el comportamiento del animal no es el deseado que medidas tomaria
            pregunta_adpcion_7,
            //que energia debe tener el animal
            pregunta_adpcion_8,
            //quien sera el responsable y se hara cargo de cubrir los gastos del adoptado
            pregunta_adpcion_9,
            //esta dispuesto a vacunar a su mascota
            pregunta_adpcion_10,
            //esta dispuesto a llevar periodicamente a su mascota al veterinario
            pregunta_adpcion_11,
            //alimentacion solo con croquetas?
            pregunta_adpcion_12,
            //desparacitacion
            pregunta_adpcion_13,
            //cepillado de pelo?
            pregunta_adpcion_14,
            //baños?
            pregunta_adpcion_15,
            //cuenta con los recursos sufucientes para cubrir los gastos de veterinaria
            pregunta_adpcion_16,
            //para que quiere adoptar una mascota
            pregunta_adpcion_17,
            //tiene donde dejar la mascota cuando sale de vaciones'
            pregunta_adpcion_18,

            //acepta terminos y condiciones del contartao
            terminos,
            //id usuario
            id

          
        } = req.body;

        /**En caso de que los campos "id_tamanio" o "descripcion_mascota"
         * no vengan en la petición se les asigna null 
         */
        const respuesta =
            await pool.query(`INSERT INTO t_formulario
                (nombre_adoptante, 
                direccion_adoptante, 
                id_codigo, 
                localidad, 
                telefono, 
                email, 
                ocupacion, 
                estado_civil, 
                pregunta_mascota_1, 
                pregunta_mascota_2, 
                pregunta_mascota_3, 
                pregunta_mascota_4, 
                pregunta_familia_1, 
                pregunta_familia_2, 
                pregunta_familia_3, 
                pregunta_familia_4, 
                pregunta_familia_5, 
                pregunta_familia_6, 
                pregunta_familia_7, 
                pregunta_adpcion_1, 
                pregunta_adpcion_2, 
                pregunta_adpcion_3, 
                pregunta_adpcion_4, 
                pregunta_adpcion_5, 
                pregunta_adpcion_6, 
                pregunta_adpcion_7, 
                pregunta_adpcion_8, 
                pregunta_adpcion_9, 
                pregunta_adpcion_10, 
                pregunta_adpcion_11, 
                pregunta_adpcion_12, 
                pregunta_adpcion_13, 
                pregunta_adpcion_14, 
                pregunta_adpcion_15, 
                pregunta_adpcion_16, 
                pregunta_adpcion_17, 
                pregunta_adpcion_18, 
                terminos,
                id) 
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13 ,$14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39) 
                RETURNING id_formulario`, [nombre_adoptante,
            direccion_adoptante,
            id_codigo,
            localidad,
            telefono,
            email,
            ocupacion,
            estado_civil,
            pregunta_mascota_1,
            pregunta_mascota_2,
            pregunta_mascota_3,
            pregunta_mascota_4,
            pregunta_familia_1,
            pregunta_familia_2,
            pregunta_familia_3,
            pregunta_familia_4,
            pregunta_familia_5,
            pregunta_familia_6,
            pregunta_familia_7,
            pregunta_adpcion_1,
            pregunta_adpcion_2,
            pregunta_adpcion_3,
            pregunta_adpcion_4,
            pregunta_adpcion_5,
            pregunta_adpcion_6,
            pregunta_adpcion_7,
            pregunta_adpcion_8,
            pregunta_adpcion_9,
            pregunta_adpcion_10,
            pregunta_adpcion_11,
            pregunta_adpcion_12,
            pregunta_adpcion_13,
            pregunta_adpcion_14,
            pregunta_adpcion_15,
            pregunta_adpcion_16,
            pregunta_adpcion_17,
            pregunta_adpcion_18,
            terminos,
            id
            ]);

        /**Si rowCount es igual a 1 quiere decir que el INSERT
         * se ejecutó correctamente */
        if (respuesta.rowCount === 1) {
            /**Se obtiene el id_mascota del registro que se acaba
             * de insertar
             */
            id_formulario = respuesta.rows[0].id_formulario;

   
        }
        /**En caso contrario quiere decir que rowCount NO vale 1,
         * y el INSERT no se ejecutó
         */
        else {
            //Se le asigna 0 
            id_formulario = 0;
        }

        return id_formulario;

    } catch (err) {

        throw new Error(`Archivo formulario.controller.js->crear()\n${err}`);

    }
}




const SolicitudAdopcion = async (req) => {

    try {
        const {
            id_mascota, 
            id_formulario
        } = req.body;

        let respuesta =
            await pool.query(`INSERT INTO t_mascotas_formulario
                (id_mascota, 
                id_formulario) 
                VALUES ($1, $2) `, [
                id_mascota, 
                id_formulario
            ]);


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
        throw new Error(`Archivo mascotas.controller.js->SolicitudAdopcion()\n${err}`);
    }
}






const obtenerformularios = async(req) => {

    try {

        const {
            solicitud_adopcion, 
            id_mascota,
            id_formulario
        } = req.body;

        let respuesta =
            await pool.query(`		
            UPDATE t_mascotas_formulario SET solicitud_adopcion = $1 WHERE id_mascota = $2 AND id_formulario = $3;`, [solicitud_adopcion, id_mascota,id_formulario]);
           

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

////Filtro



const Filtro = async(req) => {

    try {
        let respuesta2

        const {
            id_tipo_mascota, 
            id_raza,
            id_tamanio ,
            genero_mascota 
        } = req.body;
        let  respuesta =
            await pool.query(`		
            SELECT 
            id_mascota, nombre_mascota, edad_mascota, escala_edad, descripcion_mascota,
          tipo_tramite, esterilizado, id_codigo, id_municipio, municipio, id_departamento, 
          departameto, id_pais, pais, id_color, color, id_raza, raza, id_tipo_mascota, 
          id_tamanio, tamanio, genero_mascota, tipo, id_usuario, nombres, id_mascotaa, STRING_AGG(distinct id_foto, ',') fotos,  
		  STRING_AGG(distinct nombre_vac, ',') vacunas
          FROM v_mascotas_vac2 where id_tipo_mascota= $1 AND id_raza=$2 AND id_tamanio=$3 AND
          genero_mascota=$4
          GROUP BY id_mascota, nombre_mascota, edad_mascota, escala_edad, descripcion_mascota,
          tipo_tramite, esterilizado, id_codigo, id_municipio, municipio, id_departamento, 
          departameto, id_pais, pais, id_color, color, id_raza, raza, id_tipo_mascota, 
          id_tamanio, tamanio, genero_mascota, tipo, id_usuario, nombres, id_mascotaa;;`, [ 


		   
               id_tipo_mascota, 
               id_raza ,
               id_tamanio,
               genero_mascota]);
           

           if (respuesta.rowCount === 1) {
           id_mascota = respuesta.rows[0]}

          
                    

 



        /**Si rowCount es igual a 1 quiere decir que el INSERT
         * se ejecutó correctamente */
      
      
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



///consuktar respuest


const EncontrarFormulario = async(id_formulario) => {

    try {

        let respuesta =
            await pool.query(`SELECT * FROM t_formulario where id_formulario = $1`, [id_formulario]);

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



///////////////////////////actualizar formulario






const ActualizarFormulario = async(req) => {

    try {

       
        

        const {
            
            //informacion adpotante
            nombre_adoptante,
            direccion_adoptante,
            id_codigo,
            localidad,
            telefono,
            email,
            ocupacion,
            estado_civil,


            //sobre las mascotas

            //porque deseea adoptar una mascota
            pregunta_mascota_1,
            //actualmente tiene mas animales  ¿cuales?
            pregunta_mascota_2,
            //anteriormente ha tenido animales ¿cuales?
            pregunta_mascota_3,
            //esta de acuerdo con que se haga visita para ver como se encuentra el animal
            pregunta_mascota_4,
            
            //sobre familia

            //cuantas personas viven en su casa?
            pregunta_familia_1,
            //estan todos de aduerdo en adoptar?
            pregunta_familia_2,
            //alguien que viva con usted es alergico a los animales?
            pregunta_familia_3,
            //hay niños en la casa
            pregunta_familia_4,
            //en caso de alquiler ¿sus arrendadores permiten mascotas en el departamento?
            pregunta_familia_5,
            //si tuviera que cambiar de domicilio que pasaria con la mascota?
            pregunta_familia_6,
            //en caso de ruptura familiar(divorcio, fallecimiento) o la llegada de un nuevo familiar cuales serian los tratos hacie el animal adoptado?
            pregunta_familia_7,

            //sobre la adopcion 
            //que tamaño de mascota prefiere?(pequeño,mediano grande)
            pregunta_adpcion_1,
            //cuantos años cree que vive un perro o gato en promedio
            pregunta_adpcion_2,
            //como se ve con su mascota adoptada en 5 años
            pregunta_adpcion_3,
            //tiene espacio suficiente para que el animal se sienta comodo
            pregunta_adpcion_4,
            //donde dormira el animal adoptado?
            pregunta_adpcion_5,
            //cuantas horas al dia  pasara solo el animal adoptado
            pregunta_adpcion_6,
            //si el comportamiento del animal no es el deseado que medidas tomaria
            pregunta_adpcion_7,
            //que energia debe tener el animal
            pregunta_adpcion_8,
            //quien sera el responsable y se hara cargo de cubrir los gastos del adoptado
            pregunta_adpcion_9,
            //esta dispuesto a vacunar a su mascota
            pregunta_adpcion_10,
            //esta dispuesto a llevar periodicamente a su mascota al veterinario
            pregunta_adpcion_11,
            //alimentacion solo con croquetas?
            pregunta_adpcion_12,
            //desparacitacion
            pregunta_adpcion_13,
            //cepillado de pelo?
            pregunta_adpcion_14,
            //baños?
            pregunta_adpcion_15,
            //cuenta con los recursos sufucientes para cubrir los gastos de veterinaria
            pregunta_adpcion_16,
            //para que quiere adoptar una mascota
            pregunta_adpcion_17,
            //tiene donde dejar la mascota cuando sale de vaciones'
            pregunta_adpcion_18,

            //acepta terminos y condiciones del contartao
            terminos,
            //id usuario
            id,


            id_formulario

          
        } = req.body;

        /**En caso de que los campos "id_tamanio" o "descripcion_mascota"
         * no vengan en la petición se les asigna null 
         */
        const respuesta =
            await pool.query(`
            update t_formulario set 
            nombre_adoptante = $1, 
            direccion_adoptante = $2,
            id_codigo = $3,
            localidad = $4,
            telefono = $5,
            email = $6, 
            ocupacion = $7, 
            estado_civil = $8, 
            pregunta_mascota_1 = $9, 
            pregunta_mascota_2 = $10, 
            pregunta_mascota_3 = $11, 
            pregunta_mascota_4 = $12, 
            pregunta_familia_1 = $13, 
            pregunta_familia_2 = $14, 
            pregunta_familia_3 = $15, 
            pregunta_familia_4 = $16, 
            pregunta_familia_5 = $17, 
            pregunta_familia_6 = $18, 
            pregunta_familia_7 = $19, 
            pregunta_adpcion_1 = $20, 
            pregunta_adpcion_2 = $21, 
            pregunta_adpcion_3 = $22, 
            pregunta_adpcion_4 = $23, 
            pregunta_adpcion_5 = $24, 
            pregunta_adpcion_6 = $25, 
            pregunta_adpcion_7 = $26, 
            pregunta_adpcion_8 = $27, 
            pregunta_adpcion_9 = $28, 
            pregunta_adpcion_10 = $29, 
            pregunta_adpcion_11 = $30, 
            pregunta_adpcion_12 = $31, 
            pregunta_adpcion_13 = $32, 
            pregunta_adpcion_14 = $33, 
            pregunta_adpcion_15 = $34, 
            pregunta_adpcion_16 = $35, 
            pregunta_adpcion_17 = $36, 
            pregunta_adpcion_18 = $37, 
            terminos = $38,
            id = $39 
            where id_formulario = $40
            RETURNING id_formulario`, [nombre_adoptante,
            direccion_adoptante,
            id_codigo,
            localidad,
            telefono,
            email,
            ocupacion,
            estado_civil,
            pregunta_mascota_1,
            pregunta_mascota_2,
            pregunta_mascota_3,
            pregunta_mascota_4,
            pregunta_familia_1,
            pregunta_familia_2,
            pregunta_familia_3,
            pregunta_familia_4,
            pregunta_familia_5,
            pregunta_familia_6,
            pregunta_familia_7,
            pregunta_adpcion_1,
            pregunta_adpcion_2,
            pregunta_adpcion_3,
            pregunta_adpcion_4,
            pregunta_adpcion_5,
            pregunta_adpcion_6,
            pregunta_adpcion_7,
            pregunta_adpcion_8,
            pregunta_adpcion_9,
            pregunta_adpcion_10,
            pregunta_adpcion_11,
            pregunta_adpcion_12,
            pregunta_adpcion_13,
            pregunta_adpcion_14,
            pregunta_adpcion_15,
            pregunta_adpcion_16,
            pregunta_adpcion_17,
            pregunta_adpcion_18,
            terminos,
            id,
            id_formulario
            ]);

        /**Si rowCount es igual a 1 quiere decir que el INSERT
         * se ejecutó correctamente */
        if (respuesta.rowCount === 1) {
            /**Se obtiene el id_mascota del registro que se acaba
             * de insertar
             */
            id_formularios = respuesta.rows[0].id_formulario;

   
        }
        /**En caso contrario quiere decir que rowCount NO vale 1,
         * y el INSERT no se ejecutó
         */
        else {
            //Se le asigna 0 
            id_formularios = 0;
        }

        return id_formularios;

    } catch (err) {

        throw new Error(`Archivo formulario.controller.js->crear()\n${err}`);

    }
}


module.exports = {
    LlenarFormulario,
    SolicitudAdopcion,
    obtenerformularios,
   //mostarformularios
   Filtro,
   EncontrarFormulario,
   ActualizarFormulario
}