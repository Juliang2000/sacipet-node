const obtenerMascota = require('../controllers/mascotas.controller');
const obtenerNombreFoto= require('./fotos.controller')

exports.downloandFile = async(req, res) => {    
    
    try {     
        //Se captura el parámetro id_mascota de la entrada req
        const id_mascota = req.body.id_mascota;
        //Se captura el parámetro consecutivo de la entrada req
        const consecutivo = req.body.consecutivo;
        //Se consulta el nombre de la foto a partir del id_mascota
        const nombreFoto = await obtenerNombreFoto.obtenerNombreFoto(id_mascota,consecutivo);
        //Se verifica si el id_mascota se encuentra registrado*/
        const mascotaExiste = await obtenerMascota.obtenerMascotaPorId(id_mascota);
        /**Si la función devuelve un valor igual a null quiere decir que el id_mascota NO existe*/
        if (mascotaExiste === null) {
            return res.status(400).json({
                ok: false,
                msg: `El id_mascota ingresado: ${id_mascota} no existe`
            });
        };
        //Se captura el nombre del adjunto, a partir del link de entrada y se concatena con el id_mascota y el consecutivo
        const fileName = id_mascota+consecutivo+nombreFoto;  
        //Se define la ruta de guardado
        const directoryPath = __dirname + "/../uploads/";
        //Se descarga la foto correspondiente
        res.download(directoryPath + fileName, fileName, (err) => {
            if (err) {
              res.status(500).send({
                message: "Could not download the file. " + err,
              });
            }
        });
    } catch (err) {
        //console.log(err);
        res.status(500).json({
            ok: false,
            error: err.message
        });
    }
};


