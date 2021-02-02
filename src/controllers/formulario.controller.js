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
                terminos) 
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13 ,$14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38) 
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
            terminos
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



module.exports = {
    LlenarFormulario
   
}