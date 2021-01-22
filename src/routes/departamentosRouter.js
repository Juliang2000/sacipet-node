const router = require("express").Router();

const { obtenerTodos } = require('../controllers/departamentos.controller');

//=========================================================
//Mostrar todos los departamentos registrados
//=========================================================
router.get("/departamentos", async(req, res) => {

    try {

        /**Se obtienen todos los departementos de Colombia registrados en la tabla
         * "departamentos" y se guarda el resultado de la consulta dentro
         * de la constante "departamentos"
         */
        const departamentos = await obtenerTodos();

        /**Si la función retorna null, quiere decir
         * que no se encontraron departamentos registrados
         */
        if (departamentos === null) {

            res.status(400).json({
                ok: false,
                msg: `No hay departamentos registrados en base de datos`
            });
        } else {
            res.json({
                ok: true,
                departamentos
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