const router = require("express").Router();

const { obtenerTodos } = require('../controllers/tipos_mascotas.controller');

//===========================================
//Mostrar todas los tipos de mascotas
//===========================================
router.get("/tipos-mascotas", async(req, res) => {

    try {

        /**Se obtienen todos los tipos de mascotas registrados en la tabla
         * "tipos_mascotas" y se guarda el resultado de la consulta dentro
         * de la constante "tipos_mascotas"
         */
        const tipos_mascotas = await obtenerTodos();

        /**Si la función retorna null, quiere decir
         * que no se encontraron tipos de mascotas registrados
         */
        if (tipos_mascotas === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay tipos de mascotas registrados`
            });

        } else {
            res.json({
                ok: true,
                tipos_mascotas
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