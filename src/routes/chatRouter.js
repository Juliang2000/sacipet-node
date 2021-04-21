const router = require("express").Router();
const chat = require('../controllers/chat.controller');










router.post("/mensaje", async (req, res) => {

    try {

        const {

            primer_usuario, 
            segundo_usuario, 
     
            mensaje

        } = req.body;

        const campos = [
            {
                nombre: 'primer_usuario',
                campo: primer_usuario
            },
            {
                nombre: 'segundo_usuario',
                campo: segundo_usuario
            },
         
            {
                nombre: 'mensaje',
                campo: mensaje
            },
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

        const date = new Date();
        let horas = date.getHours();
        let minutos = date.getMinutes()
        let segundos = date.getSeconds();

        horatotal = horas + ":" + minutos+ ":" +segundos
        visto=0


        const form = await chat.EnviarMensajes(primer_usuario,segundo_usuario,horatotal,visto,mensaje);

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






router.post("/obtenerchat", async (req, res) => {

    try {

        const {usuario} = req.body;

        const campos = [
            {
                nombre: 'usuario',
                campo: usuario
            }
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

       


        const form = await chat.ObtenerMensaje( usuario, usuario);

        res.json({
            ok: true,
            msg: `chat encontrado exitosamente`,
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