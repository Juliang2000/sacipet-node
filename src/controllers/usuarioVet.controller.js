const pool = require('../database/dbConection');

const bcrypt = require('bcrypt');


/**
 * Esta función hace un INSERT dentro de la tabla, usuario 
 * dados los campos que vienen en el "req" de la petición
 * @param {object} req 
 * @returns retorna true en caso de que se  haya hecjo el INSERT
 */
const crear = async (req) => {

    try {

        let usuarioCreado = false;

        // const { nombres, password, correo, apellidos, documento, telefono } = req.body;
        const { nombres, password, correo, telefono } = req.body;

        /**Se encripta la clave que viene en el body con la función .hash() */
        const passwordHash = await hashPassword(password)

        const respuesta =
            // await pool.query(`INSERT INTO usuario
            //              (nombres, password, correo, apellidos, documento, telefono) 
            //              VALUES ($1, $2, $3, $4, $5, $6) RETURNING id`, [
            //     nombres, passwordHash, correo, apellidos, documento, telefono
            // ]);
            await pool.query(`INSERT INTO t_usuario
                         (nombres, password, correo, telefono) 
                         VALUES ($1, $2, $3, $4) RETURNING id`, [
                nombres, passwordHash, correo, telefono
            ]);

        if (respuesta.rowCount === 1) {
            usuarioCreado = true;
        }

        const { id } = respuesta.rows[0];

        return id

    } catch (err) {
        console.error(err)
        throw new Error(`Archivo usuarioVet.controller.js->crear()\n${err}`);

    }
}

/**Esta función hace un DELETE dentro de la tabla, usuario
 * dados el correo
 * 
 * Retorna true en caso de que se haya hecho el DELETE o retorna
 * false en caso de que no se haya insertado
 */
const eliminarPorCorreo = async (correo) => {

    try {

        let borrado = false;

        const response =
            await pool.query(`DELETE FROM applicants WHERE correo = $1`, [correo]);

        //.rowCount devuelve 1 si la operación se realizó
        borrado = response.rowCount === 1;

        return borrado;

    } catch (err) {

        throw new Error(`Archivo usuarioVet.controller.js -> eliminarPorCorreo()\n${err}`);

    }
}


/**
 * Trae todos los datos del usuario registrado con el correo
 * @param {string} correo
 * @returns {Object} devuelve un objeto con todos los datos del usuario, si no encuentra retorna null
 */

const consultarUsuario = async (correo) => {


    const sql = 'select  t_usuario.id, t_usuario.password, t_rol.nombre as rol , nombres, apellidos, correo, origen_cuenta, telefono ' +
        'FROM t_usuario left join t_rol_usuario rru on t_usuario.id = rru.id_usuario ' +
        'left join t_rol on rru.id_rol = t_rol.id ' +
        'WHERE correo = $1'
    const { rows } = await pool.query(sql, [correo])

    // retorna null, en caso de que no exista el usuario creado con ese correo
    if (rows.length == 0) {
        return null
    }

    //retorna el objeto con los datos del usuario      
    return rows[0];

}


/**
 * Crea un usuario en la base de datos, inserta en las tablas usuario, usuario_rol y en la
 * tabla veterinario o cliente de acuerdo al valor del rol.
 * @param {object} nombres 
 * @param {string} apellidos El rol con el cual se creará el usuario
 * @returns {object} la información del usuario creado 
 */

async function crearUsuarioRedesSociales(nombres, apellidos, email, origen_cuenta, password) {
    try {

        const sql = 'INSERT INTO t_usuario (nombres, apellidos, correo, password, origen_cuenta)' +
            ' VALUES ($1, $2, $3, $4, $5) returning id, nombres, apellidos, correo, origen_cuenta '
        const { rows } = await pool.query(sql, [nombres,
            apellidos, email, password, origen_cuenta
        ]);




        return rows[0]

    } catch (error) {
        throw new Error(`Archivo usuarioVet.controller.js->crearUsuarioRedesSociales()\n${error}`);
    }

}



/**
 * utiliza la libreria bcryp para realizar un hash del password y no guardarlo el texto plano en base de datos
 * @param {string} password 
 * @returns {string} password con el hash
 */
async function hashPassword(password) {
    const passwordHash = await bcrypt.hash(password, process.env.PASSWORD_SALT);
    return passwordHash
}


/**Obtiene todos los campos de un usuario dado su "id" 
 * La función retorna un objeto con los valores de los campos
 * del usuario en caso de que éste se haya encontrado, o
 * retorna null en caso de que el usuario no exista
 */
const obtenerPorId = async (id) => {

    try {
        let respuesta = await pool.query('SELECT * FROM t_usuario WHERE id = $1', [id]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * del registro encontrado que está en la primera posición del array */
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}









const cambiarNombreUsuario = async (nombres,id_usuario) => {

    try { 
        let respuesta = await pool.query('UPDATE t_usuario SET nombres = $1 WHERE id = $2;', [nombres,id_usuario]);

       
        if (JSON.stringify(respuesta.rows) === '[]') {

            respuesta = null;

        }
      
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}




const cambiarTelefonoUsuario = async (telefono,id_usuario) => {

    try { 
        let respuesta = await pool.query('UPDATE t_usuario SET telefono = $1 WHERE id = $2;', [telefono,id_usuario]);

       
        if (JSON.stringify(respuesta.rows) === '[]') {

            respuesta = null;

        }
      
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}






const cambiarEmailUsuario = async (email,id_usuario) => {

    try { 
        let respuesta = await pool.query('UPDATE t_usuario SET correo = $1 WHERE id = $2;', [email,id_usuario]);

       
        if (JSON.stringify(respuesta.rows) === '[]') {

            respuesta = null;

        }
      
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}



const cambiarContrasenaUsuario = async (password,id_usuario) => {

    try { 
        let respuesta = await pool.query('UPDATE t_usuario SET password = $1 WHERE id = $2;', [password,id_usuario]);

       
        if (JSON.stringify(respuesta.rows) === '[]') {

            respuesta = null;

        }
      
        else {
            respuesta = respuesta.rows[0];
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}


const obtenerPorId2 = async (id) => {

    try {
        let respuesta = await pool.query('SELECT * FROM t_usuario WHERE id = $1', [id]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * del registro encontrado que está en la primera posición del array */
        else {
            respuesta = respuesta.rows[0].password;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}



const compararContraseña = async (id,password) => {

    try {

        const passwordHash = await hashPassword(password)
        let respuesta = await pool.query('SELECT * FROM t_usuario WHERE id = $1', [id]);

        /**Para verificar que el resultado de la consulta no arroja ningún registro
         * se convierte la respuesta en un JSONArray y se compara con []
         */
        if (JSON.stringify(respuesta.rows) === '[]') {

            //Se le asigna null a la respuesta
            respuesta = null;

        }
        /**En caso contrario quiere decir que si arrojó 1 registro
         * por lo tanto se le asigna a la respuesta los valores de los atributos
         * del registro encontrado que está en la primera posición del array */
        else {

            if(passwordHash === respuesta.rows[0].password ){

                respuesta = respuesta.rows[0].password;
            }else{
                respuesta = null;
            }



            
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->obtenerPorId()\n${err}`);
    }
}






const compararfotouser = async (id_usuario) => {

    try {
        let respuesta = await pool.query('SELECT * FROM public.t_fotos_user where id_usuario = $1', [id_usuario]);

    
        if (JSON.stringify(respuesta.rows) === '[]') {

     
            respuesta = null;

        }
       
        else {
            respuesta = respuesta.rows;
        }

        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->compararfotouser()\n${err}`);
    }
}





const actualizarfotouser = async (id_usuario, nombre_imagen,ruta_guardado) => {

    try {
        let respuesta = await pool.query('UPDATE public.t_fotos_user SET  nombre_imagen= $2,consecutivo=1,ruta_guardado=$3 WHERE id_usuario= $1   RETURNING id;', [id_usuario, nombre_imagen,ruta_guardado]);

    
        if (JSON.stringify(respuesta.rows) === '[]') {

     
            respuesta = null;

        }
       
        else {
            
            respuesta = respuesta.rows[0].id;
        }
        console.log(respuesta)
        return respuesta;

    } catch (err) {
        throw new Error(`Archivo usuarioVet.controller.js->compararfotouser()\n${err}`);
    }
}



module.exports = {

    crear,
    eliminarPorCorreo,
    consultarUsuario,
    crearUsuarioRedesSociales,
    hashPassword,
    obtenerPorId,
    cambiarNombreUsuario,
    cambiarTelefonoUsuario,
    cambiarEmailUsuario,
    cambiarContrasenaUsuario,
    obtenerPorId2,
    compararContraseña,
    compararfotouser,
    actualizarfotouser
}