const router = require("express").Router();

const vacuns = require('../controllers/vacunas.controller');

//===========================================
//Mostrar todas las vacunas
//===========================================
router.get("/vacunas", async(req, res) => {

    try {

        /**Se obtienen todas las vacunas registradas en la tabla
         * "vacunas" y se guarda el resultado de la consulta dentro
         * de la constante "vacunas"
         */
        const vacunas = await vacuns.obtenerTodas();

        /**Si la función retorna null, quiere decir
         * que no se encontraron mascotas registradas
         */
        if (vacunas === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay vacunas registradas`
            });

        } else {
            res.json({
                ok: true,
                vacunas
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

module.exports = { router };