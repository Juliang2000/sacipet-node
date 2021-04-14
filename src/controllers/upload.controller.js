var fs = require('fs');
const fots = require('../controllers/fotos.controller');
const obtenerMascota = require('../controllers/mascotas.controller');
const user = require('../controllers/usuarioVet.controller');

exports.uploadFile = async(req,res)=>{

    try {     
        //Se captura el parámetro id_mascota de la entrada req
        const id_mascota = req.body.id_mascota;
        //Se captura el parámetro consecutivo de la entrada req
        const consecutivo = req.body.consecutivo;
        //Se valida que el consecutivo ingresado este dentro del rango de 1 y 5
        if(consecutivo<1 || consecutivo>5){
            return res.status(400).json({
                ok: false,
                msg: `El consecutivo ingresado debe estar dentro del rango de 1 y 5`
            });
        }
        /**Se verifica si el id_mascota se encuentra registrado*/
        const mascotaExiste = await obtenerMascota.obtenerMascotaPorId(id_mascota);
        /**Si la función devuelve un valor igual a null quiere decir que el id_mascota NO existe*/
        if (mascotaExiste === null) {
            return res.status(400).json({
                ok: false,
                msg: `El id_mascota ingresado: ${id_mascota} no existe`
            });
        };    

        const fotoExiste = await user.compararfotmasco(id_mascota,consecutivo);

        //Se define la ruta de guardado
        const rutaGuardado = __dirname + "/../uploads/";
        //Se obtiene el archivo a partir de la foto de entrada req
        const file = req.files.photo;
        //Se consulta las fotos que están asociadas a una mascota en particular
        const Fotos = await fots.fotosPorId(id_mascota);


        if (fotoExiste === null) {
        //Se adjuntan fotos solo si en la base de datos hay menos de 5 archivos relacionados
        if(Fotos.length<5 || Fotos===0){
            //Se crea el registro en base de datos con la información de la foto correspondiente
            const id = await fots.crear(rutaGuardado,req.files.photo.name,id_mascota,consecutivo);        
            // Crear drectorio uploads
            fs.mkdir(rutaGuardado,(error)=>{
                //if(error)throw error;
            });
            //Adjuntar archivo en el directorio
            file.mv(rutaGuardado+id+'.jpg', function(err, result){    //C:/uploads/
                if(err) throw err;
                res.send({
                    sucess:true,
                    message:'File Upload!'
                });
            });        
        }else{
            //Se informativo al usuario si ya se han subido las 5 fotos pertinentes
            return res.status(400).json({
                ok: false,
                msg: "No es posible adjuntar mas fotos, se puede subir máximo 5"
            });
        };    

    }else{
        


        const actualizafoto = await user.actualizarfotomascota(id_mascota,consecutivo, req.files.photo.name,rutaGuardado);
        // console.log(actualizafoto)
         
         fs.mkdir(rutaGuardado,(error)=>{
             //if(error)throw error;
         });
         //Adjuntar archivo en el directorio
         file.mv(rutaGuardado+actualizafoto +'.jpg', function(err, result){    //C:/uploads2/
             if(err) throw err;
             res.send({
                 sucess:true,
                 message:'File Upload!'
             });
         }); 

    }



    } catch (err) {
        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

}











exports.uploadFileUser = async(req,res)=>{

    try {     
        //Se captura el parámetro id_usuario de la entrada req
        const id_usuario = req.body.id_usuario;
        //Se captura el parámetro consecutivo de la entrada req
        const consecutivo = req.body.consecutivo;
        //Se valida que el consecutivo ingresado este dentro del rango de 1 y 5
        if(consecutivo<1 || consecutivo>2){
            return res.status(400).json({
                ok: false,
                msg: `El consecutivo ingresado debe estar dentro del rango de 1 y 2`
            });
        }
        /**Se verifica si el id_mascota se encuentra registrado*/
        const usuarioExiste = await user.obtenerPorId(id_usuario);
        /**Si la función devuelve un valor igual a null quiere decir que el id_mascota NO existe*/
        if (usuarioExiste === null) {
            return res.status(400).json({
                ok: false,
                msg: `El id_usuario ingresado: ${id_usuario} no existe`
            });
        };    

        const fotoExiste = await user.compararfotouser(id_usuario);
                //Se define la ruta de guardado
                const rutaGuardado = __dirname + "/../uploads2/";
                //Se obtiene el archivo a partir de la foto de entrada req
                const file = req.files.photo;
                //Se consulta las fotos que están asociadas a una mascota en particular
                const Fotos = await fots.fotosPorIdusuario(id_usuario);
       
        if (fotoExiste === null) {


        //Se adjuntan fotos solo si en la base de datos hay menos de 5 archivos relacionados
        if(Fotos.length<5 || Fotos===0){
            //Se crea el registro en base de datos con la información de la foto correspondiente
            const id = await fots.crearfusuario(rutaGuardado,req.files.photo.name,id_usuario,consecutivo);        
            // Crear drectorio uploads
            fs.mkdir(rutaGuardado,(error)=>{
                //if(error)throw error;
            });
            //Adjuntar archivo en el directorio
            file.mv(rutaGuardado+id+'.jpg', function(err, result){    //C:/uploads2/
                if(err) throw err;
                res.send({
                    sucess:true,
                    message:'File Upload!'
                });
            });        
        }else{
            //Se informativo al usuario si ya se han subido las 5 fotos pertinentes
            return res.status(400).json({
                ok: false,
                msg: "No es posible adjuntar mas fotos, se puede subir máximo 5"
            });
        }; 
        
        
    }else{
        
        const actualizafoto = await user.actualizarfotouser(id_usuario, req.files.photo.name,rutaGuardado);
       // console.log(actualizafoto)
        
        fs.mkdir(rutaGuardado,(error)=>{
            //if(error)throw error;
        });
        //Adjuntar archivo en el directorio
        file.mv(rutaGuardado+actualizafoto +'.jpg', function(err, result){    //C:/uploads2/
            if(err) throw err;
            res.send({
                sucess:true,
                message:'File Upload!'
            });
        }); 
    }


    } catch (err) {
        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

}