const express = require('express');
const app = express();
const fileUpload = require('express-fileupload'); // libreria para cargar archivos dentro de una aplicacion

// transforma lo que viene y lo deja en req.files  utilizado para subir los archivos
app.use(fileUpload());

//importamos el objeto router, es necesario especificar el objeto

app.use(require('./userRouterVet').router);
app.use(require('./loginRouterVet').router);

app.use(require('./mascotasRouter').router);
app.use(require('./vacunasRouter').router);
app.use(require('./mascotas_vacunasRouter').router);
app.use(require('./fotosRouter').router);
app.use(require('./tipos_mascotasRouter').router);
app.use(require('./razasRouter').router);
app.use(require('./razasPorTipoYTamanoRouter').router);
app.use(require('./tamaniosRouter').router);
app.use(require('./coloresRouter').router);
app.use(require('./departamentosRouter').router);
app.use(require('./municipiosRouter').router);
app.use(require('./uploadRouter').router);
app.use(require('./downloadRouter').router);
app.use(require('./formularioRouter').router);
app.use(require('./chatRouter').router);
//Se exporta app que tiene configurados los métodos HTTP
module.exports = app;