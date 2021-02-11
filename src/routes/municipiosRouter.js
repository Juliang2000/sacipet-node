const router = require("express").Router();

const { obtenerPorIdUndeMunicipio } = require('../controllers/municipios.controller');

//=========================================================
//Mostrar todos las municipios dependiendo del tipo de departamento
//=========================================================
router.post("/municipios", async(req, res) => {

    try {

        //Se toman solo los campos necesarios que vienen en el body de la petición
        const {
            id_unde
        } = req.body;

        /**Se guardan todos los campos recibidos en el body
         * de la petición dentro de un array
         */
        const campos = [{
            nombre: 'id_unde',
            campo: id_unde
        }];

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

        /**Se obtienen todos los municipios registradas en la tabla
         * "ubicaciones_geograficas", que correspondan al "id_unde" recibido,
         *  y se guarda el resultado de la consulta dentro
         * de la constante "municipios"
         */
        const municipios = await obtenerPorIdUndeMunicipio(id_unde);

        /**Si la función retorna null, quiere decir
         * que no se encontraron municipios que correspondan al
         * "id_unde" recibido
         */
        if (municipios === null) {

            res.status(400).json({
                ok: false,
                msg: `No se encontraron municipios relacionadas al id_unde ingresado`
            });

        } else {
            res.json({
                ok: true,
                municipios
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