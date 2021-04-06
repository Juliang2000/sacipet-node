const router = require("express").Router();
const adops = require('../controllers/mascotas.controller');
const fots = require('../controllers/fotos.controller');
const user = require('../controllers/usuarioVet.controller');

//===========================================
//Guarda registro en la tabla fotos
//===========================================
router.post("/fotos", async(req, res) => {

    try {

        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         */
        const {
            ruta_guardado,
            nombre_imagen,
            id_mascota
        } = req.body;

        /**Se guardan todos los campos recibidos en el body
         * de la petición dentro de un array
         */
        const campos = [{
                nombre: 'ruta_guardado',
                campo: ruta_guardado
            },
            {
                nombre: 'id_mascota',
                campo: id_mascota
            },
            {
                nombre: 'nombre_imagen',
                campo: nombre_imagen
            }
        ];

        /**Se busca en el array si alguno de los campos no fue enviado,
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

        /**Se verifica si el id_mascota
         * se encuentra registrado*/
        const adopcionExiste = await adops.obtenerPorId(id_mascota);

        /**Si la función devuelve un valor igual a null
         * quiere decir que el id_mascota NO existe*/
        if (adopcionExiste === null) {

            return res.status(400).json({
                ok: false,
                msg: `El id_mascota ingresado: ${id_mascota} no existe`
            });
        }

        /**Se llama a la función que hace el registro y se obtiene la respuesta, 
         * ya sea el id que se acaba de registrar o 0,
         * y se guarda dentro de la constante "id"
         */
        const id = await fots.crear(ruta_guardado,id_mascota);

        /**Si la función retorna 0, quiere decir
         * que la foto no se pudo guardar
         */
        if (id === 0) {
            res.status(500).json({
                ok: false,
                msg: `Ocurrión un error al agregar la foto a la adopcion`
            });
        } else {


            const foto = await fots.obtenerFoto(id);

            res.json({
                ok: true,
                msg: `Foto agregada exitosamente`,
                foto
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






//fotos usuarios




router.post("/fotosUsuario", async(req, res) => {

    try {

        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         */
        const {
            ruta_guardado,
            nombre_imagen,
            id_usuario
        } = req.body;

        /**Se guardan todos los campos recibidos en el body
         * de la petición dentro de un array
         */
        const campos = [{
                nombre: 'ruta_guardado',
                campo: ruta_guardado
            },
            {
                nombre: 'id_usuario',
                campo: id_usuario
            },
            {
                nombre: 'nombre_imagen',
                campo: nombre_imagen
            }
        ];

        /**Se busca en el array si alguno de los campos no fue enviado,
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

        /**Se verifica si el id_mascota
         * se encuentra registrado*/
        const adopcionExiste = await user.obtenerPorId(id_usuario);

        /**Si la función devuelve un valor igual a null
         * quiere decir que el id_mascota NO existe*/
        if (adopcionExiste === null) {

            return res.status(400).json({
                ok: false,
                msg: `El id_usuario ingresado: ${id_usuario} no existe`
            });
        }

        /**Se llama a la función que hace el registro y se obtiene la respuesta, 
         * ya sea el id que se acaba de registrar o 0,
         * y se guarda dentro de la constante "id"
         */
        const id = await fots.crearfusuario(ruta_guardado,id_usuario);

        /**Si la función retorna 0, quiere decir
         * que la foto no se pudo guardar
         */
        if (id === 0) {
            res.status(500).json({
                ok: false,
                msg: `Ocurrión un error al agregar la foto a la adopcion`
            });
        } else {


            const foto = await fots.obtenerFotousuario(id);

            res.json({
                ok: true,
                msg: `Foto agregada exitosamente`,
                foto
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

module.exports = { router }