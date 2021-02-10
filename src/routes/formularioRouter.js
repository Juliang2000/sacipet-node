const router = require("express").Router();

//const { obtenerPorId } = require('../controllers/usuarioVet.controller');
const adops = require('../controllers/formulario.controller');





router.post("/formulario", async(req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         */
        const {
            nombre_adoptante,
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
    
        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [{
                nombre: 'nombre_adoptante',
                campo: nombre_adoptante
            },
            {
                nombre: 'direccion_adoptante',
                campo: direccion_adoptante
            },
            {
                nombre: 'id_codigo',
                campo: id_codigo
            },
            {
                nombre: 'localidad',
                campo: localidad
            },
            {
                nombre: 'telefono',
                campo: telefono
            },
            {
                nombre: 'email',
                campo: email
            },
            {
                nombre: 'ocupacion',
                campo: ocupacion
            },
            {
                nombre: 'estado_civil',
                campo: estado_civil
            },
            {
                nombre: 'pregunta_mascota_1',
                campo: pregunta_mascota_1
            },
            {
                nombre: 'pregunta_mascota_2',
                campo: pregunta_mascota_2
            },
            {
                nombre: 'pregunta_mascota_3',
                campo: pregunta_mascota_3
            },
            {
                nombre: 'pregunta_mascota_4',
                campo: pregunta_mascota_4
            },
            {
                nombre: 'pregunta_familia_1',
                campo: pregunta_familia_1
            },
            {
                nombre: 'pregunta_familia_2',
                campo: pregunta_familia_2
            },
            {
                nombre: 'pregunta_familia_3',
                campo: pregunta_familia_3
            },
            {
                nombre: 'pregunta_familia_4',
                campo: pregunta_familia_4
            },
            {
                nombre: 'pregunta_familia_5',
                campo: pregunta_familia_5
            },
            {
                nombre: 'pregunta_familia_6',
                campo: pregunta_familia_6
            },
            {
                nombre: 'pregunta_familia_7',
                campo: pregunta_familia_7
            },
            {
                nombre: 'pregunta_adpcion_1',
                campo: pregunta_adpcion_1
            },
            {
                nombre: 'pregunta_adpcion_2',
                campo: pregunta_adpcion_2
            },
            {
                nombre: 'pregunta_adpcion_3',
                campo: pregunta_adpcion_3
            },
            {
                nombre: 'pregunta_adpcion_4',
                campo: pregunta_adpcion_4
            },
            {
                nombre: 'pregunta_adpcion_5',
                campo: pregunta_adpcion_5
            },
            {
                nombre: 'pregunta_adpcion_6',
                campo: pregunta_adpcion_6
            },
            {
                nombre: 'pregunta_adpcion_7',
                campo: pregunta_adpcion_7
            },
            {
                nombre: 'pregunta_adpcion_8',
                campo: pregunta_adpcion_8
            },
            {
                nombre: 'pregunta_adpcion_9',
                campo: pregunta_adpcion_9
            },
            {
                nombre: 'pregunta_adpcion_10',
                campo: pregunta_adpcion_10
            },
            {
                nombre: 'pregunta_adpcion_11',
                campo: pregunta_adpcion_11
            },
            {
                nombre: 'pregunta_adpcion_12',
                campo: pregunta_adpcion_12
            },
            {
                nombre: 'pregunta_adpcion_13',
                campo: pregunta_adpcion_13
            },
            {
                nombre: 'pregunta_adpcion_14',
                campo: pregunta_adpcion_14
            },
            {
                nombre: 'pregunta_adpcion_15',
                campo: pregunta_adpcion_15
            },
            {
                nombre: 'pregunta_adpcion_16',
                campo: pregunta_adpcion_16
            },
            {
                nombre: 'pregunta_adpcion_17',
                campo: pregunta_adpcion_17
            },
            {
                nombre: 'pregunta_adpcion_18',
                campo: pregunta_adpcion_18
            },
            {
                nombre: 'terminos',
                campo: terminos
            },
            {
                nombre: 'id',
                campo: id
            },
        ];

        /**Se busca en el array si alguno de los campos obligatorios 
         * no fue recibido,
         * en caso de que se encuentre algún campo vacio se guarda el 
         * elemento encontrado dentro de la constante llamada "campoVacio"
         */
        const campoVacio = campos.find(x => !x.campo);

        /**Si alguno de los campos NO fue enviado en la petición
         * se le muestra al cliente el nombre del campo que falta
         */
        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

        


       


        /**Se llama a la función que hace el registro y se obtiene la respuesta, 
         * ya sea el id que se acaba de registrar o 0,
         * y se guarda el número dentro de la constante "id_formulario"
         */
        const id_formulario = await adops.LlenarFormulario(req);

        /**Si la función retorna 0, quiere decir
         * que la mascota no se pudo crear
         */
        if (id_formulario === 0) {

            res.status(500).json({
                ok: false,
                msg: `Ocurrió un error al guardar el formulario`
            });
        }
        
        /**Sino quiere decir que la función retornó un
         * números distinto de 0 y se registro la adopción
         */
        else {

            /**Se busca la mascota que se acaba de crear
             * dado el id_formulario que se acaba de obtener
             */
           // const form = await adops.obtenerPorId(id_formulario);

            res.json({
                ok: true,
                msg: `formulario guardada exitosamente`,
               // form
            });
        }

    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});



router.post("/formulariomascota", async(req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         */
        const {
            id_mascota, 
            id_formulario
    
        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [{
                nombre: 'id_mascota',
                campo: id_mascota
            },
            {
                nombre: 'id_formulario',
                campo: id_formulario
            }
        ];

        /**Se busca en el array si alguno de los campos obligatorios 
         * no fue recibido,
         * en caso de que se encuentre algún campo vacio se guarda el 
         * elemento encontrado dentro de la constante llamada "campoVacio"
         */
        const campoVacio = campos.find(x => !x.campo);

        /**Si alguno de los campos NO fue enviado en la petición
         * se le muestra al cliente el nombre del campo que falta
         */
        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

        /**Se llama a la función que hace el registro y se obtiene la respuesta, 
         * ya sea el id que se acaba de registrar o 0,
         * y se guarda el número dentro de la constante "id_formul"
         */
        const id_formul = await adops.SolicitudAdopcion(req);

        /**Si la función retorna 0, quiere decir
         * que la mascota no se pudo crear
         */
        if (id_formul=== 0) {

            res.status(500).json({
                ok: false,
                msg: `Ocurrió un error al guardar el formulario`
            });
        }
        /**Sino quiere decir que la función retornó un
         * números distinto de 0 y se registro la adopción
         */
        else {

            /**Se busca la mascota que se acaba de crear
             * dado el id_formulario que se acaba de obtener
             */
         //  const form = await adops.obtenerPorId(id_formul);

            res.json({
                ok: true,
                msg: `formulario guardada exitosamente`,
               // form
            });
        }

    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});

 
router.post("/formulariopeticion", async(req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         */
        const {
            solicitud_adopcion, 
            id_mascota,
            id_formulario
    
        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [
            {
                nombre: 'solicitud_adopcion',
                campo: solicitud_adopcion
            },
            {
                nombre: 'id_mascota',
                campo: id_mascota
            },
            {
                nombre: 'id_formulario',
                campo: id_formulario
            }
        ];

        /**Se busca en el array si alguno de los campos obligatorios 
         * no fue recibido,
         * en caso de que se encuentre algún campo vacio se guarda el 
         * elemento encontrado dentro de la constante llamada "campoVacio"
         */
        const campoVacio = campos.find(x => !x.campo);

        /**Si alguno de los campos NO fue enviado en la petición
         * se le muestra al cliente el nombre del campo que falta
         */
        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

        /**Se llama a la función que hace el registro y se obtiene la respuesta, 
         * ya sea el id que se acaba de registrar o 0,
         * y se guarda el número dentro de la constante "id_formul"
         */
        const id_formul = await adops.obtenerformularios(req);

        /**Si la función retorna 0, quiere decir
         * que la mascota no se pudo crear
         */
        if (id_formul=== 0) {

            res.status(500).json({
                ok: false,
                msg: `Ocurrió un error al vincular el formulario`
            });
        }
        /**Sino quiere decir que la función retornó un
         * números distinto de 0 y se registro la adopción
         */

        
        else {
            

            /**Se busca la mascota que se acaba de crear
             * dado el id_formulario que se acaba de obtener
             */
         // const form = await adops.mostarformularios(id_formulario);
         // console.log(form)

            res.json({
                ok: true,
                msg: ` respuesta exitosa`,
                
               //form
            });
        }

    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});



module.exports = { router };