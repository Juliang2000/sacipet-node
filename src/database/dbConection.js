const { Pool } = require('pg');


/// esto es una prueba

const envalid = require('envalid') // libreria envalid se encarga de validar las variables de entorno, si  no encuentra esta variable indica en lugar y muestra el error
const { str, host, port } = envalid
 
const env = envalid.cleanEnv(process.env, {

    DB_USER:            str({desc: 'usuario de conexion a la base de datos'}),
    DB_HOST:            host({desc: 'Host de base de datos' }),
    DB_PASSWORD:        str({desc: 'Password del usuario de basde de datos' }),
    DB_PORT:            port({desc: 'Puerto de la base de datos'}),
    DB_DATABASE:        str({desc: 'nombre de la base de datos'})
})


const pool = new Pool({
    user: env.DB_USER,
    host: env.DB_HOST,
    password: env.DB_PASSWORD,
    database: env.DB_DATABASE,
    port: env.DB_PORT
});

module.exports = pool;