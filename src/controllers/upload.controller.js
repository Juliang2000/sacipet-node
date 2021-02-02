var fs = require('fs');
const fots = require('../controllers/fotos.controller');
const obtenerMascota = require('../controllers/mascotas.controller');

exports.uploadFile = async(req,res)=>{

    //Se captura el parámetro id_mascota de la entrada req
    const id_mascota = req.body.id_mascota;
    /**Se verifica si el id_mascota se encuentra registrado*/
    const mascotaExiste = await obtenerMascota.obtenerMascotaPorId(id_mascota);
    /**Si la función devuelve un valor igual a null quiere decir que el id_mascota NO existe*/
    if (mascotaExiste === null) {
        return res.status(400).json({
            ok: false,
            msg: `El id_mascota ingresado: ${id_mascota} no existe`
        });
    };    
    //Se define la ruta de guardado
    const rutaGuardado = __dirname + "/../uploads/";
    //Se obtiene el archivo a partir de la foto de entrada req
    const file = req.files.photo;
    //Se consulta las fotos que están asociadas a una mascota en particular
    const Fotos = await fots.fotosPorId(id_mascota);
    //Se adjuntan fotos solo si en la base de datos hay menos de 5 archivos relacionados
    if(Fotos.length<5 || Fotos===0){
        //Crear drectorio uploads
        // fs.mkdir(rutaGuardado,(error)=>{
        //     //if(error)throw error;
        // });
        //Adjuntar archivo en el directorio
        file.mv(rutaGuardado+file.name, function(err, result){    //C:/uploads/
            if(err) throw err;
            //Se renombra el archivo agregando el id_mascota y el consecutivo antes del nombre original
            fs.rename(rutaGuardado+file.name,rutaGuardado+id_mascota+consecutivo+file.name,(err)=>{
                if(err) throw err;
            });
            res.send({
                sucess:true,
                message:'File Upload!'
            });

        });
        //Se define el consecutivo correspondiente
        if(Fotos===0){
            var consecutivo=1;     
        }else{
            var consecutivo=Fotos.length+1;     
        };    
        
        //Se crea el registro en base de datos con la información de la foto correspondiente
        const id = await fots.crear(rutaGuardado,id_mascota+consecutivo+'_'+req.files.photo.name,id_mascota);        
    }else{
        //Se informativo al usuario si ya se han subido las 5 fotos pertinentes
        return res.status(400).json({
            ok: false,
            msg: "No es posible adjuntar mas fotos, se puede subir máximo 5"
        });
    };

}