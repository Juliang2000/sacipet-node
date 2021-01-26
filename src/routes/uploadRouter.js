const router = require("express").Router();

//=========================================================
// Sube archivos a un directorio
//=========================================================

const express = require('express');
var fileupload = require('express-fileupload');
const fots = require('../controllers/fotos.controller');

router.post("/upload", async(req,res,next) =>{
    //Se captura el parámetro id_mascota de la entrada
    const id_mascota = req.body.id_mascota;
    //Se define la ruta de guardado
    const rutaGuardado ="/Desarrollo SACI/Proyectos/Ejercicios/Node JS Rest API FileUpload/uploads/"
    //Se obtiene el archivo a partir de la foto de entrada req
    const file = req.files.photo;
    //Se consulta las fotos que están asociadas a una mascota en particular
    const Fotos = await fots.fotosPorId(id_mascota);
    //Se adjuntan fotos solo si en la base de datos hay menos de 5 archivos relacionados
    if(Fotos.length<5 || Fotos===0){
        file.mv(rutaGuardado+file.name, function(err, result){    //C:/uploads/
            if(err)
                throw err;
            res.send({
                sucess:true,
                message:'File Upload!'
            });
        });
        //Se llama el método para crear el registro en base de datos de los datos de la foto correspondiente
        const id = await fots.crear(rutaGuardado,req.files.photo.name,id_mascota);        
    }else{
        //Se retorna mensaje informativo al usuario
        return res.status(400).json({
            ok: false,
            msg: "No es posible adjuntar mas fotos, se puede subir máximo 5"
        });
    }   
})

module.exports = { router };
//app.listen(5000, () => console.log('Server started on port 5000'));
