const router = require("express").Router();

//const { obtenerPorId } = require('../controllers/usuarioVet.controller');
const adops = require('../controllers/formulario.controller');
const adops2 = require('../controllers/mascotas.controller');




router.post("/formulario", async (req, res) => {

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
         * 
         
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
            const form = await adops.obtenerPorIdFormulario(id);

            res.json({
                ok: true,
                msg: `formulario guardada exitosamente`,
                form
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



router.post("/formulariomascota", async (req, res) => {

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
        if (id_formul === 0) {

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


router.post("/formulariopeticion", async (req, res) => {

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
        if (id_formul === 0) {

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



router.post("/filtro", async (req, res) => {

    try {

        let {
            id_tipo_mascota,
            id_raza,
            id_tamanio,
            genero_mascota,
            edad_mascota,
            escala_edad,

        } = req.body;


        const campos = [
            {
                nombre: 'id_tipo_mascota',
                campo: id_tipo_mascota
            }
        ];


        //filtro si todos estan completos
        if (genero_mascota != undefined && id_raza != undefined && id_tipo_mascota != undefined && id_tamanio != undefined && edad_mascota != undefined && escala_edad != undefined) {

            const mascotas = await adops.Filtro2(req);
            return res.status(400).json({
                mascotas
            });
        }

        //filtro id_tamanio        genero_mascota    edad_mascota     escala_edad
        if (id_tamanio != undefined && genero_mascota != undefined && edad_mascota != undefined && escala_edad != undefined && id_raza === undefined && id_tipo_mascota === undefined) {

            const mascotas = await adops.Filtro3(id_tamanio, genero_mascota, edad_mascota, escala_edad);
            return res.status(400).json({
                mascotas
            });
        }



        //id_raza           id_tamanio        genero_mascota   edad_mascota
        if (id_tamanio != undefined && genero_mascota != undefined && edad_mascota != undefined && id_raza != undefined && escala_edad === undefined && id_tipo_mascota === undefined) {

            const mascotas = await adops.Filtro4(id_raza, id_tamanio, genero_mascota, edad_mascota);
            return res.status(400).json({
                mascotas
            });
        }



        //edad_mascota      escala_edad       id_tipo_mascota   id_raza
        if (edad_mascota != undefined && escala_edad != undefined && id_tipo_mascota != undefined && id_raza != undefined && id_tamanio === undefined && genero_mascota === undefined) {

            const mascotas = await adops.Filtro5(edad_mascota, escala_edad, id_tipo_mascota, id_raza);
            return res.status(400).json({
                mascotas
            });
        }



        //id_tipo_mascota   id_raza           id_tamanio       genero_mascota   escala_edad 
        if (id_tipo_mascota != undefined && id_raza != undefined && id_tamanio != undefined && genero_mascota != undefined && escala_edad != undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro6(id_tipo_mascota, id_raza, id_tamanio, genero_mascota, escala_edad);
            return res.status(400).json({
                mascotas
            });
        }

        //id_tipo_mascota   id_raza           id_tamanio       genero_mascota   edad_mascota 
        if (id_tipo_mascota != undefined && id_raza != undefined && id_tamanio != undefined && genero_mascota != undefined && edad_mascota != undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro7(id_tipo_mascota, id_raza, id_tamanio, genero_mascota, edad_mascota);
            return res.status(400).json({
                mascotas
            });
        }




        //mostrar todos si no se puso ningun filtro
        if (genero_mascota === undefined && id_raza === undefined && id_tamanio === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops2.obtenerTodas();
            return res.status(400).json({
                mascotas
            });
        }

        //mostrar genero_mascota id_raza id_tamanio
        if (genero_mascota != undefined && id_raza != undefined && id_tamanio != undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_raza_genero_tamanio(id_raza, genero_mascota, id_tamanio);
            return res.status(400).json({
                mascotas
            });
        }

        //mostrar id_raza  genero_mascota id_tipo_mascota
        if (genero_mascota != undefined && id_raza != undefined && id_tipo_mascota != undefined && id_tamanio === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_raza_genero_tipo(id_raza, genero_mascota, id_tipo_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        //mostrar id_raza id_tamanio id_tipo_mascota
        if (id_raza != undefined && id_tamanio != undefined && id_tipo_mascota != undefined && genero_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_raza_tamanio_tipo(id_raza, id_tamanio, id_tipo_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        //mostrar id_tamanio genero_mascota id_tipo_mascota
        if (id_tamanio != undefined && genero_mascota != undefined && id_tipo_mascota != undefined && id_raza === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_tamanio_genero_tipo(id_tamanio, genero_mascota, id_tipo_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        //edad_mascota  escala_edad  genero_mascota 
        if (edad_mascota != undefined && escala_edad != undefined && genero_mascota != undefined && id_tamanio === undefined && id_tipo_mascota === undefined && id_raza === undefined) {

            const mascotas = await adops.Filtro_edad_escala_genero(edad_mascota, escala_edad, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        //edad_mascota    escala_edad    id_tamanio   
        if (edad_mascota != undefined && escala_edad != undefined && id_tamanio != undefined && genero_mascota === undefined && id_tipo_mascota === undefined && id_raza === undefined) {

            const mascotas = await adops.Filtro_edad_escala_tamanio(edad_mascota, escala_edad, id_tamanio);
            return res.status(400).json({
                mascotas
            });
        }

        //edad_mascota    escala_edad    id_raza   
        if (edad_mascota != undefined && escala_edad != undefined && id_raza != undefined && id_tamanio === undefined && genero_mascota === undefined && id_tipo_mascota === undefined) {

            const mascotas = await adops.Filtro_edad_escala_raza(edad_mascota, escala_edad, id_raza);
            return res.status(400).json({
                mascotas
            });
        }
        //edad_mascota    escala_edad    id_tipo_mascota   
        if (edad_mascota != undefined && escala_edad != undefined && id_tipo_mascota != undefined && id_tamanio === undefined && genero_mascota === undefined && id_raza === undefined) {

            const mascotas = await adops.Filtro_edad_escala_tipo(edad_mascota, escala_edad, id_tipo_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        //edad_mascota    id_raza   id_tipo_mascota   
        if (edad_mascota != undefined && id_raza != undefined && id_tipo_mascota != undefined && id_tamanio === undefined && genero_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_edad_raza_tipo(edad_mascota, id_raza, id_tipo_mascota);
            return res.status(400).json({
                mascotas
            });
        }


        //edad_mascota    id_raza   id_tamanio   
        if (edad_mascota != undefined && id_raza != undefined && id_tamanio != undefined && id_tipo_mascota === undefined && genero_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_edad_raza_tamanio(edad_mascota, id_raza, id_tamanio);
            return res.status(400).json({
                mascotas
            });
        }


        //edad_mascota    id_raza   genero_mascota
        if (edad_mascota != undefined && id_raza != undefined && genero_mascota != undefined && id_tipo_mascota === undefined && id_tamanio === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_edad_raza_genero(edad_mascota, id_raza, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        ///edad_mascota    id_tipo_mascota   id_tamanio
        if (edad_mascota != undefined && id_tipo_mascota != undefined && id_tamanio != undefined && id_raza === undefined && genero_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_edad_tipo_tamanio(edad_mascota, id_tipo_mascota, id_tamanio);
            return res.status(400).json({
                mascotas
            });
        }


        ///edad_mascota    id_tipo_mascota   genero_mascota
        if (edad_mascota != undefined && id_tipo_mascota != undefined && genero_mascota != undefined && id_raza === undefined && id_tamanio === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_edad_tipo_genero(edad_mascota, id_tipo_mascota, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        ///edad_mascota    id_tamanio   genero_mascota
        if (edad_mascota != undefined && id_tamanio != undefined && genero_mascota != undefined && id_raza === undefined && id_tipo_mascota === undefined && escala_edad === undefined) {

            const mascotas = await adops.Filtro_edad_tamanio_genero(edad_mascota, id_tamanio, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        ///escala_edad    id_raza   id_tipo_mascota 
        if (escala_edad != undefined && id_raza != undefined && id_tipo_mascota != undefined && id_tamanio === undefined && genero_mascota === undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro_escalaedad_raza_tipo(escala_edad, id_raza, id_tipo_mascota);
            return res.status(400).json({
                mascotas
            });
        }

        ///escala_edad    id_raza   id_tamanio
        if (escala_edad != undefined && id_raza != undefined && id_tamanio != undefined && id_tipo_mascota === undefined && genero_mascota === undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro_escalaedad_raza_tamanio(escala_edad, id_raza, id_tamanio);
            return res.status(400).json({
                mascotas
            });
        }

        ///escala_edad    id_raza   genero_mascota
        if (escala_edad != undefined && id_raza != undefined && genero_mascota != undefined && id_tipo_mascota === undefined && id_tamanio === undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro_escalaedad_raza_genero(escala_edad, id_raza, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }




        ///escala_edad    id_tipo_mascota   id_tamanio
        if (escala_edad != undefined && id_tipo_mascota != undefined && id_tamanio != undefined && id_raza === undefined && genero_mascota === undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro_escalaedad_tipo_tamanio(escala_edad, id_tipo_mascota, id_tamanio);
            return res.status(400).json({
                mascotas
            });
        }

        ///escala_edad    id_tipo_mascota   genero_mascota
        if (escala_edad != undefined && id_tipo_mascota != undefined && genero_mascota != undefined && id_raza === undefined && id_tamanio === undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro_escalaedad_tipo_genero(escala_edad, id_tipo_mascota, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }



        ///escala_edad    id_tamanio   genero_mascota
        if (escala_edad != undefined && id_tamanio != undefined && genero_mascota != undefined && id_raza === undefined && id_tipo_mascota === undefined && edad_mascota === undefined) {

            const mascotas = await adops.Filtro_escalaedad_tamanio_genero(escala_edad, id_tamanio, genero_mascota);
            return res.status(400).json({
                mascotas
            });
        }



        //mostrar solo edad_mascota  
        if (edad_mascota != undefined && id_raza === undefined && genero_mascota === undefined && id_tamanio === undefined && id_tipo_mascota === undefined && escala_edad === undefined) {

            const mascotas2 = await adops.FiltroEdad(edad_mascota);
            return res.status(400).json({
                mascotas2
            });
        }


        //mostrar solo escala_edad 
        if (escala_edad != undefined && edad_mascota === undefined && id_raza === undefined && genero_mascota === undefined && id_tamanio === undefined && id_tipo_mascota === undefined) {

            const mascotas2 = await adops.FiltroEscalaedad(escala_edad);
            return res.status(400).json({
                mascotas2
            });
        }



        //mostrar solo id_raza  
        if (id_raza != undefined && genero_mascota === undefined && id_tamanio === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas2 = await adops.FiltroRaza(id_raza);
            return res.status(400).json({
                mascotas2
            });
        }

        //mostrar solo id_raza y tipo mascota
        if (id_raza != undefined && id_tipo_mascota != undefined && genero_mascota === undefined && id_tamanio === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas2 = await adops.Filtro_raza_tipomascota(id_tipo_mascota, id_raza);
            return res.status(400).json({
                mascotas2
            });
        }

        //mostrar solo id_raza  Y tamanio
        if (id_raza != undefined && id_tamanio != undefined && genero_mascota === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas2 = await adops.Filtro_raza_tamanio(id_tamanio, id_raza);
            return res.status(400).json({
                mascotas2
            });
        }

        //mostrar solo id_raza  y  genero_mascota
        if (id_raza != undefined && genero_mascota != undefined && id_tamanio === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_raza_genero(genero_mascota, id_raza);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar solo genero mascota
        if (genero_mascota != undefined && id_raza === undefined && id_tamanio === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.FiltroGenero(genero_mascota);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar genero mascota y tamaño
        if (genero_mascota != undefined && id_tamanio != undefined && id_raza === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_Genero_tamanio(genero_mascota, id_tamanio);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar  genero mascota y id_tipo_mascota
        if (genero_mascota != undefined && id_tipo_mascota != undefined && id_raza === undefined && id_tamanio === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_Genero_tipomascota(genero_mascota, id_tipo_mascota);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar edad_mascota id_tipo_mascota
        if (edad_mascota != undefined && id_tipo_mascota != undefined && id_raza === undefined && id_tamanio === undefined && genero_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_edad_tipomascota(edad_mascota, id_tipo_mascota);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar edad_mascota id_raza
        if (edad_mascota != undefined && id_raza != undefined && id_tipo_mascota === undefined && id_tamanio === undefined && genero_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_edad_raza(edad_mascota, id_raza);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar edad_mascota id_tamanio
        if (edad_mascota != undefined && id_tamanio != undefined && id_tipo_mascota === undefined && id_raza === undefined && genero_mascota === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_edad_tamanio(edad_mascota, id_tamanio);
            return res.status(400).json({
                mascotas3
            });
        }



        //mostrar edad_mascota genero_mascota
        if (edad_mascota != undefined && genero_mascota != undefined && id_tipo_mascota === undefined && id_raza === undefined && id_tamanio === undefined && escala_edad === undefined) {

            const mascotas3 = await adops.Filtro_edad_genero(edad_mascota, genero_mascota);
            return res.status(400).json({
                mascotas3
            });
        }




        //mostrar edad_mascota escala_edad
        if (edad_mascota != undefined && escala_edad != undefined && id_tipo_mascota === undefined && id_raza === undefined && id_tamanio === undefined && genero_mascota === undefined) {

            const mascotas3 = await adops.Filtro_edad_escala(edad_mascota, escala_edad);
            return res.status(400).json({
                mascotas3
            });
        }



        //mostrar escala_edad id_tipo_mascota
        if (escala_edad != undefined && id_tipo_mascota != undefined && edad_mascota === undefined && id_raza === undefined && id_tamanio === undefined && genero_mascota === undefined) {

            const mascotas3 = await adops.Filtro_escala_tipo(escala_edad, id_tipo_mascota);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar escala_edad id_raza
        if (escala_edad != undefined && id_raza != undefined && edad_mascota === undefined && id_tipo_mascota === undefined && id_tamanio === undefined && genero_mascota === undefined) {

            const mascotas3 = await adops.Filtro_escala_raza(escala_edad, id_raza);
            return res.status(400).json({
                mascotas3
            });
        }

        //mostrar escala_edad id_tamanio
        if (escala_edad != undefined && id_tamanio != undefined && edad_mascota === undefined && id_tipo_mascota === undefined && id_raza === undefined && genero_mascota === undefined) {

            const mascotas3 = await adops.Filtro_escala_tamanio(escala_edad, id_tamanio);
            return res.status(400).json({
                mascotas3
            });
        }



        //mostrar escala_edad genero_mascota
        if (escala_edad != undefined && genero_mascota != undefined && edad_mascota === undefined && id_tipo_mascota === undefined && id_raza === undefined && id_tamanio === undefined) {

            const mascotas3 = await adops.Filtro_escala_genero(escala_edad, genero_mascota);
            return res.status(400).json({
                mascotas3
            });
        }






        //mostrar solo tamaño
        if (id_tamanio != undefined && id_raza === undefined && genero_mascota === undefined && id_tipo_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas4 = await adops.FiltroTamaño(id_tamanio);
            return res.status(400).json({
                mascotas4
            });
        }

        //mostrar  tamaño tipo mascota
        if (id_tamanio != undefined && id_tipo_mascota != undefined && id_raza === undefined && genero_mascota === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas4 = await adops.FiltroTamaño_tipomascota(id_tamanio, id_tipo_mascota);
            return res.status(400).json({
                mascotas4
            });
        }
        //mostrar solo tipo mascota

        if (id_tipo_mascota != undefined && genero_mascota === undefined && id_raza === undefined && id_tamanio === undefined && edad_mascota === undefined && escala_edad === undefined) {

            const mascotas5 = await adops.Filtrotipomascota(id_tipo_mascota);
            return res.status(400).json({
                mascotas5
            });
        }




        const id_formul = await adops.Filtro(req);

        if (id_formul === null) {

            res.status(500).json({
                ok: false,
                msg: `Ocurrió un error al guardar la adopción`
            });
        }

        else {

            res.json({
                ok: true,
                msg: ` respuesta exitosa`,
                id_formul

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



////////////////////////////////////////////////////DFDFFFFFFFFFFFFFFFFFFFFFF

router.get("/obtenerformulario", async (req, res) => {

    try {

        const {
            id_formulario,


        } = req.body;

        /**Se obtienen todas las mascotas registradas en la tabla
         * "mascotas" y se guarda el resultado de la consulta dentro
         * de la constante "mascotas"
         */

        const mascotas = await adops.EncontrarFormulario(id_formulario);


        // const mascotas2 = await route.downloadController.downloandFile(1,2);
        /**Si la función retorna null, quiere decir
         * que no se encontraron mascotas registradas
         */
        if (mascotas === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay mascotas registradas`
            });

        } else {


            res.json({
                ok: true,
                mascotas,
                //  mascotas2
            })
        }


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});


/////////////////////////////////////actualizar c

router.post("/actualizarformulario", async (req, res) => {

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
            id_formulario

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
            nombre: 'id_formulario',
            campo: id_formulario
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
         * 
         
         */

        const mascotas = await adops.EncontrarFormulario(id_formulario);

        if (mascotas === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay formulario registradas`
            });

        } else {


            const id_formulario = await adops.ActualizarFormulario(req);

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
                    mascotas,
                    msg: `formulario guardada exitosamente`,

                    // form
                });
            }



        }



        ///////////////////



    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});






router.post("/obtenerformulario", async (req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         */
        const {

            id

        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [
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




        const form = await adops.obtenerPorIdFormulario(id);

        res.json({
            ok: true,
            msg: `formulario encontrado exitosamente`,
            form
        });
    }

    catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});




router.post("/obtenermascotaformulario", async (req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         */
        const {

            id_usuario

        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [
            {
                nombre: 'id_usuario',
                campo: id_usuario
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




        const form = await adops.obtenermascotasform(id_usuario);

        res.json({
            ok: true,
            msg: `formulario encontrado exitosamente`,
            form
        });
    }

    catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});

router.post("/obtenermascotasporusuario", async (req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         */
        const {

            id_usuario

        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [
            {
                nombre: 'id_usuario',
                campo: id_usuario
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




        const form = await adops.obtenermascotasporusuario(id_usuario);

        res.json({
            ok: true,
            msg: `formulario encontrado exitosamente`,
            form
        });
    }

    catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});









router.post("/MacotasRegistradas", async (req, res) => {

    try {

        const {

            id_usuario

        } = req.body;

        const campos = [
            {
                nombre: 'id_usuario',
                campo: id_usuario
            },
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }




        const form = await adops.MacotasRegistradas(id_usuario);

        res.json({
            ok: true,
            msg: `formulario encontrado exitosamente`,
            form
        });
    }

    catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});







router.post("/MacotasRegistradasEspecifica", async (req, res) => {

    try {

        const {

            id_usuario,
            id_formulario,
            id_mascota


        } = req.body;

        const campos = [
            {
                nombre: 'id_usuario',
                campo: id_usuario
            },
            {
                nombre: 'id_formulario',
                campo: id_formulario
            },
            {
                nombre: 'id_mascota',
                campo: id_mascota
            }
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }




        const form = await adops.MacotasRegistradasespecifica(id_usuario,id_formulario,id_mascota);

        res.json({
            ok: true,
            msg: `formulario encontrado exitosamente`,
            form
        });
    }

    catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});
module.exports = { router };