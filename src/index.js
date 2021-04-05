const express = require('express');
const app = express();

require('../src/config/configVet');
const path = require('path');

///////////////////////////

const optionsCors = {
    origin: 'http://localhost:5000'
}
const cors = require('cors');

app.use(cors(optionsCors));
//require("dotenv").config();
///////////////////////////

// middlewares
/*
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
*/

const bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());

/**Se importa el archivo routes, 
 * donde están todas las rutas del proyecto
 * */
app.use(require('./routes/routes'));
///poner las imagenes de manera publica
app.use(express.static('src/uploads'));

//Habilitar la carpeta public que es en donde se encuentra la página Web
//Se usa la función .resolve() del paquete path para resolver la ruta
const publicPath = path.resolve(__dirname, './public');
app.use(express.static(publicPath));


app.listen(process.env.PORT, () => {
    console.log(`The server has started on port: ${process.env.PORT}`)
});
