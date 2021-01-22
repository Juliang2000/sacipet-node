const router = require("express").Router();
const rav = require('../controllers/mascotas_vacunas.controller');
const vacuns = require('../controllers/vacunas.controller');
const adops = require('../controllers/mascotas.controller');

//===========================================
//Guarda registro en la tabla r_mascotas_vacunas
//===========================================
router.post("/mascotas-vacunas", async(req, res) => {

    try {

        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         */
        const {
            id_vacuna,
            id_mascota
        } = req.body;

        /**Se guardan todos los campos recibidos en el body
         * de la petición dentro de un array
         */
        const campos = [{
                nombre: 'id_vacuna',
                campo: id_vacuna
            },
            {
                nombre: 'id_mascota',
                campo: id_mascota
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

        /**Se verifica si el id_vacuna
         * se encuentra registrado*/
        const vacunaExiste = await vacuns.obtenerPorId(id_vacuna);

        /**Si la función devuelve un valor igual a null
         * quiere decir que el id_vacuna NO existe*/
        if (vacunaExiste === null) {

            return res.status(400).json({
                ok: false,
                msg: `El id_vacuna ingresado: ${id_vacuna} no existe`
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
        const id = await rav.crear(req);

        /**Si la función retorna 0, quiere decir
         * que la adopcion no se pudo crear
         */
        if (id === 0) {
            res.status(500).json({
                ok: false,
                msg: `Ocurrió un error al agregar la vacuna a la adopcion`
            });
        } else {


            const vacunas = await adops.obtenerVacunasPorid_mascota(id_mascota);

            res.json({
                ok: true,
                msg: `Vacunas agregadas exitosamente`,
                vacunas
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