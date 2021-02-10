const router = require("express").Router();

const { obtenerPorIdTipoMascotaYTamanio } = require('../controllers/razasPorTipoYTamano.controller');

//=========================================================
//Mostrar todos las razas dependiendo del tipo de mascota
//=========================================================
router.post("/razasTipoTamano", async(req, res) => {

    try {

        //Se toman solo los campos necesarios que vienen en el body de la petición
        const {
            id_tipo_mascota,
            id_tamanio
        } = req.body;

        /**Se guardan todos los campos recibidos en el body
         * de la petición dentro de un array
         */
        const campos = [
            {
                nombre: 'id_tipo_mascota',
                campo: id_tipo_mascota
            },
            {
                nombre: 'id_tamanio',
                campo: id_tamanio
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

        /**Se obtienen todas las razas registradas en la tabla
         * "razas", que correspondan al "id_tipo_mascota" recibido,
         *  y se guarda el resultado de la consulta dentro
         * de la constante "razas"
         */
        const razas = await obtenerPorIdTipoMascotaYTamanio(id_tipo_mascota,id_tamanio);

        /**Si la función retorna null, quiere decir
         * que no se encontraron razas que correspondan al
         * "id_tipo_mascota" recibido
         */
        if (razas === null) {

            res.status(400).json({
                ok: false,
                msg: `No se encontraron razas relacionadas al id_tipo_mascota ingresado`
            });

        } else {
            res.json({
                ok: true,
                razas
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