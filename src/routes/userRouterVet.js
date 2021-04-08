const router = require("express").Router();

/**Se importa la librería donde están las funciones que hacen las 
 * operaciones dml de base de datos a la tabla "usuario"
 */
const usuariocontroladorVet = require('../controllers/usuarioVet.controller');

/**Se importa la librería donde están las funciones que hacen las 
 * operaciones dml de base de datos a la tabla "r_rol_usuario"
 */
const rolControlador = require('../controllers/rol.controllerVet');

//===========================================
//Registro Normal
//===========================================
router.post("/registro", async(req, res) => {

    try {

        //Se toman solo los campos necesarios que vienen en el body de la petición
        
        // let { nombres, apellidos, password, passwordCheck, correo, documento, telefono, id_rol } = req.body;
        let { nombres, password, passwordCheck, correo, telefono, id_rol } = req.body;

        /**Se guardan todos los campos recibidos en el body
         * de la petición dentro de un array
         */
        const campos = [{
                nombre: 'nombres',
                campo: nombres
            },
            {
                nombre: 'password',
                campo: password
            },
            {
                nombre: 'passwordCheck',
                campo: passwordCheck
            },
            {
                nombre: 'correo',
                campo: correo
            },
            // {
            //     nombre: 'apellidos',
            //     campo: apellidos
            // },
            // {
            //     nombre: 'documento',
            //     campo: documento
            // },
            {
                nombre: 'telefono',
                campo: telefono
            },
            {
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
        
        //Si la constraseña que se recibió tiene menos de 5 caracteres
        if (password.length < 5) {
            return res.status(400).json({
                ok: false,
                msg: "La contraseña debe tener al menos 5 caracteres."
            });
        }

        //Si las 2 contraseñas que se recibieron no coindicen
        if (password !== passwordCheck) {
            return res.status(400).json({
                ok: false,
                msg: "Ingrese la misma contraseña dos veces para verificación."
            });
        }

        /**Llama a la función obtenerPorCorreo() que verifica si el usuario
         * ya existe, dado el correo que se recibió en la petición
         */
        
        let usuarioExiste = await usuariocontroladorVet.consultarUsuario(correo);
        
        /**Si la función retorna un valor diferente de null quiere decir
         * que ya existe un usuario registrado con ese correo
         */
        if (usuarioExiste !== null) {

            return res.status(403).json({
                ok: false,
                msg: `Ya existe una cuenta asociada a ese correo: ${correo}`
            });
        }
        
        /**Se llama a la función que hace el registro y se obtiene el id del usuario creado"
         */
        let id = await usuariocontroladorVet.crear(req);
        console.log(id)
            /**Si la función retorna un valor diferente de true quiere decir
             * que el usuario no se pudo crear
             */
        if (!id) {
            return res.status(400).json({
                ok: false,
                msg: `Ocurrió un error al guardar al usuario`
            });
        }


        ///////////////////////////////////////

        /**Se crea un registro dentro de la tabla t_rol_usuario,
         * se le pasa el id del usuario que se acaba de registrar
         * dentro de la tabla usuarios y el rol que viene en el req.
        //  */
        let Rol = await rolControlador.asociarUsuarioRol(id, id_rol);

        //Si no se le pudo asignar un rol a ese usuario
        if (!Rol) {

            /**Se borra el registro en la tabla "usuario" que se acaba de insertar,
             * porque el usuario NO puede quedar registrado sin algún rol
             */
            await usuariocontroladorVet.eliminarPorCorreo(correo);

            return res.status(400).json({
                ok: false,
                msg: `Ocurrió un error al asignarle un rol al usuario`
            });
        }
        const mensaje = 'usuario registrado exitosamente'
        console.log(mensaje)
        res.json({
            ok: true,
            msg: mensaje,
            id
        });

    } catch (err) {
        console.log(err);
        res.status(500).json({
            ok: false,
            err
        })
    }
});




router.post("/Mostarusuario", async(req, res) => {

    try {

        const {
            id_usuario
    
        } = req.body;

      
        
        const user = await usuariocontroladorVet.obtenerPorId(id_usuario);
        
    
        if (user === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay user registrados`
            });

        } else {
            res.json({
                ok: true,
                user,
            
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




router.post("/CambiarNombre", async(req, res) => {

    try {

        const {
            nombres,
            id
    
        } = req.body;

      
        
        const name = await usuariocontroladorVet.cambiarNombreUsuario(nombres,id);
        
      
            res.json({
                ok: true,
                message:"nombre actualizado exitosamente",
              
            })
        


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
           
        });
    }

});



router.post("/CambiarTelefono", async(req, res) => {

    try {

        const {
            telefono,
            id
    
        } = req.body;

      
        
        const name = await usuariocontroladorVet.cambiarTelefonoUsuario(telefono,id);
        
        res.json({
            ok: true,
            message:"telefono actualizado exitosamente",
          
        })
        
        


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});





router.post("/CambiarEmail", async(req, res) => {

    try {

        const {
            correo,
            id
    
        } = req.body;

      
        
        const name = await usuariocontroladorVet.cambiarEmailUsuario(correo,id);
        
        res.json({
            ok: true,
            message:"email actualizado exitosamente",
          
        })
        
        


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});




router.post("/CambiarContrasena", async(req, res) => {

    try {

        const {
            password,
            id
    
        } = req.body;



        
if (password != null) { // se compara el hash

 
  
    const hashLogin = await usuariocontroladorVet.hashPassword(password)
    
        // compara el password
    

    

        const name = await usuariocontroladorVet.cambiarContrasenaUsuario(hashLogin,id);
    
   
        /**Si la función retorna null, quiere decir
         * que no se encontraron vuelos registrados
         */
        if (name === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay usuarios en esre mometo`
            });

        } else {
            res.json({
                ok: true,
                name
              
            })
        }
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