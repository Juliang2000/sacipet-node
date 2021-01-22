const router = require("express").Router();

const { obtenerTodos } = require('../controllers/tamanios.controller');

//=========================================================
//Mostrar todos los tamanios registrados
//=========================================================
router.get("/tamanios", async(req, res) => {

    try {

        /**Se obtienen todos los tamaños registrados en la tabla
         * "tamanios" y se guarda el resultado de la consulta dentro
         * de la constante "tamanios"
         */
        const tamanios = await obtenerTodos();

        /**Si la función retorna null, quiere decir
         * que no se encontraron tamaños registrados
         */
        if (tamanios === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay tamanios registrados`
            });
        } else {
            res.json({
                ok: true,
                tamanios
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