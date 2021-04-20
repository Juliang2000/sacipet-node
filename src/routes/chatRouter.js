const router = require("express").Router();
const adops = require('../controllers/chat.controller');










router.post("/crearchat", async (req, res) => {

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
module.exports = { router };