const router = require("express").Router();

const { obtenerTodos,getCarId } = require('../controllers/colores.controller');

//=========================================================
//Mostrar todos los colores registrados
//=========================================================
router.get("/colores", async(req, res) => {

    try {

        /**Se obtienen todos los colores registrados en la tabla
         * "colores" y se guarda el resultado de la consulta dentro
         * de la constante "colores"
         */
        const colores = await obtenerTodos();

        /**Si la función retorna null, quiere decir
         * que no se encontraron tamaños registrados
         */
        if (colores === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay colores registrados`
            });
        } else {
            res.json({
                ok: true,
                colores
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





router.get('/usersc/:id', getCarId);

module.exports = { router };