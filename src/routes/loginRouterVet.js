const router = require("express").Router();
const axios = require('axios').default; // libreria peticion get para traer datos de facebook



const userController = require('../controllers/usuarioVet.controller'); // controladores usuario
const tokenController = require('../controllers/token.controllerVet'); // controladores token
const rolController = require('../controllers/rol.controllerVet'); // controladores tabla rol



router.post("/login", async(req, res) => {

    try {


        //Se toman solo los campos necesarios que vienen en el body de la petición
        let { correo, password, token, origen_cuenta, userID, id_rol } = req.body;
        // se valida que venga este campo ya que es con el que se se realiza el switch
        if (!origen_cuenta) {
            let mensaje = 'No ha ingresado el campo origen_cuenta: tres opciones validas: Registro_Normal, google, facebook'
            console.error(mensaje)
            return res.status(400).json({
                ok: false,
                msg: mensaje
            });
        }

        let dbUser = null
        switch (origen_cuenta.toLowerCase()) { // comparamos la variable y la enviamos toda a minuscula
            case "registro_normal":
                // se debe asegurar que vengan en el body los campos que se requieren
                await validarCampos(correo, password, origen_cuenta)

                dbUser = await userController.consultarUsuario(correo); // consultamos si el usuario ya existe
                if (dbUser == null) {

                    return res.status(400).json({

                        ok: false,
                        msg: `correo: ${correo} no registrado`
                    });

                }


                if (dbUser.password != null) { // se compara el hash
                    const hashLogin = await userController.hashPassword(password)
                    console.log(hashLogin)
                        // compara el password
                    let comparacion = hashLogin === dbUser.password
                    if (!comparacion) return res.status(400).json({ mensaje: "Password incorrecto" });

                    console.log(dbUser)
                }

                break;
            case "google":
                if (!token || !id_rol) {
                    let mensaje = 'No viene el token o el id_rol'
                    console.error(mensaje)
                    return res.status(400).json({
                        ok: false,
                        msg: mensaje
                    });

                }
                const usuarioToken = await tokenController.decodificarToken(token) // retorna el payloy con todos los datos de google

                dbUser = await userController.consultarUsuario(usuarioToken.email);

                if (dbUser != null && dbUser.origen_cuenta != "google") {
                    //La cuenta fue creada usando usuario y contraseña

                    console.log({
                        status: 400,
                        msg: `usuario ya registrado autenticar con ${dbUser.origen_cuenta}`
                    })
                    return res.status(400).json({ mensaje: `usuario ya registrado autenticar con ${dbUser.origen_cuenta}` })
                }

                // si el usuario es nulo se debe crear en la base de datos.
                if (dbUser == null) {
                    //El usuario no existe 
                    //Crear usuario

                    dbUser = await userController.crearUsuarioRedesSociales(usuarioToken.given_name, usuarioToken.family_name, usuarioToken.email, origen_cuenta, 'passwordConstante')
                    console.log(dbUser.id)
                        // inserta en la tabla rol
                    let rol = await rolController.asociarUsuarioRol(dbUser.id, id_rol);

                    //Si no se le pudo asignar un rol a ese usuario
                    if (!rol) {

                        /**Se borra el registro en la tabla "usuario" que se acaba de insertar,
                         * porque el usuario NO puede quedar registrado sin algún rol
                         */
                        await userController.eliminarPorCorreo(usuarioToken.email);
                        let mensaje = "ocurrio un error al asignarle un rol al usuario"
                        console.log(mensaje)
                        return res.status(400).json({
                            ok: false,
                            msg: mensaje
                        });
                    }

                }
                break;
            case "facebook":
                await validarCamposFacebook(token, userID, id_rol)

                //petición http para obtener datos 
                const url = `https://graph.facebook.com/${userID}?fields=id,first_name,last_name,email&access_token=${token}`

                const datosFacebook = await axios.get(url) // se hace una peticion a facebook, para traer todos los datos, ya que el fron solo genera el userID accesstoken
                    //console.log(datosFacebook)
                    //consulta si existe en la DB
                dbUser = await userController.consultarUsuario(datosFacebook.data.email)

                if (dbUser != null && dbUser.origen_cuenta != "facebook") {

                    console.log({
                        status: 400,
                        msg: `usuario ya registrado autenticar con ${dbUser.origen_cuenta}`
                    })
                    return res.status(400).json({ mensaje: `usuario ya registrado autenticar con ${dbUser.origen_cuenta}` })
                }
                if (dbUser == null) {
                    // si el null se debe de crear el usuario
                    dbUser = await userController.crearUsuarioRedesSociales(datosFacebook.data.first_name,
                        datosFacebook.data.last_name, datosFacebook.data.email, origen_cuenta, 'passwordConstante')
                    console.log(dbUser.id)
                        // insertar rol 
                    let rol = await rolController.asociarUsuarioRol(dbUser.id, id_rol);

                    //Si no se le pudo asignar un rol a ese usuario
                    if (!rol) {

                        /**Se borra el registro en la tabla "usuario" que se acaba de insertar,
                         * porque el usuario NO puede quedar registrado sin algún rol
                         */
                        await userController.eliminarPorCorreo(datosFacebook.data.email);
                        let mensaje = "ocurrio un error al asignarle un rol al usuario"
                        console.log(mensaje)
                        return res.status(400).json({
                            ok: false,
                            msg: mensaje
                        });
                    }


                }

                break;
            default:

                break;
        }

        // despues de pasar por los casos, se genera el token de la aplicacion

        const tokenGenerado = await tokenController.generarToken(dbUser)


        console.log(`token generado: ${tokenGenerado}`)
        console.log(`Ingreso_exitoso con: ${origen_cuenta}`)
        return res.status(200).json({

            ok: true,
            msg: `¡Autenticación exitosa!`,
            user: dbUser,
            tokenGenerado
        });


    } catch (err) {
        console.log(err);
        res.status(500).json({
            error: err.message
        });
    }
});


async function validarCamposFacebook(token, userID, id_rol) {
    !token || !userID || id_rol

    /**Se guardan todos los campos recibidos en el body
     * de la petición dentro de un array
     */
    const campos = [{
            nombre: 'token',
            campo: token
        },
        {
            nombre: 'userID',
            campo: userID
        }, {
            nombre: 'id_rol',
            campo: id_rol
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
}

async function validarCampos(correo, password, origen_cuenta) {

    /**Se guardan todos los campos recibidos en el body
     * de la petición dentro de un array
     */
    const campos = [{
            nombre: 'correo',
            campo: correo
        },
        {
            nombre: 'password',
            campo: password
        }, {
            nombre: 'origen_cuenta',
            campo: origen_cuenta
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
}


module.exports = { router };