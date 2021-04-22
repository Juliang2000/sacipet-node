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
        const form2 = await chat.ObtenerMensaje(primer_usuario)
        res.json({
            ok: true,
            msg: `formulario encontrado exitosamente`,
            form2
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

////////////////////preguntas




router.post("/pregunta", async (req, res) => {

    try {

        const {

            primer_usuario, 
            segundo_usuario, 
     
            mensaje,
            id_mascota

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
            {
                nombre: 'id_mascota',
                campo: id_mascota
            }
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

        const date = new Date();
        let fecha = date.toLocaleDateString()

       
        visto=0

        
        const form = await chat.EnviarPregunta(primer_usuario,segundo_usuario,fecha,mensaje,id_mascota);
       // const form2 = await chat.ObtenerMensaje(primer_usuario)
        res.json({
            ok: true,
            msg: `pregunta enviada exitosamente  `,
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





router.post("/respuesta", async (req, res) => {

    try {

        const {

            respuesta,
            primer_usuario,
            segundo_usuario, 
            id_mascota

        } = req.body;

        const campos = [
            {
                nombre: 'respuesta',
                campo: respuesta
            },
            {
                nombre: 'primer_usuario',
                campo: primer_usuario
            },
            {
                nombre: 'segundo_usuario',
                campo: segundo_usuario
            },
         
            {
                nombre: 'id_mascota',
                campo: id_mascota
            }
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }


        
        const form = await chat.EnviarRespuesta( respuesta,primer_usuario,segundo_usuario, id_mascota);
       // const form2 = await chat.ObtenerMensaje(primer_usuario)
        res.json({
            ok: true,
            msg: `respuesta enviada exitosamente  `,
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






router.post("/ObtenerPreguntaRespuesta", async (req, res) => {

    try {

        const {

            primer_usuario,
            id_mascota

        } = req.body;

        const campos = [

            {
                nombre: 'primer_usuario',
                campo: primer_usuario
            },
            {
                nombre: 'id_mascota',
                campo: id_mascota
            }
        ];

    
        const campoVacio = campos.find(x => !x.campo);


        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }


        
        const form = await chat.ObtenerPreguntasRespuestas( primer_usuario, id_mascota);
       // const form2 = await chat.ObtenerMensaje(primer_usuario)
        res.json({
            ok: true,
            msg: `respuesta enviada exitosamente  `,
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