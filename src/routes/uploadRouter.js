const router = require("express").Router();

//=========================================================
// Sube archivos a un directorio
//=========================================================

const express = require('express');
var fileupload = require('express-fileupload');
const fots = require('../controllers/fotos.controller');

router.post("/upload", async(req,res,next) =>{
    //console.log(req.files); //Información del adjunto
    const rutaGuardado ="/Desarrollo SACI/Proyectos/Ejercicios/Node JS Rest API FileUpload/uploads/"
    const id = await fots.crear(rutaGuardado,req.files.photo.name,1);
    const file = req.files.photo;
    file.mv(rutaGuardado+file.name, function(err, result){    //C:/uploads/
        if(err)
            throw err;
        res.send({
            sucess:true,
            message:'File Upload!'
        });
    });    
})

module.exports = { router };
//app.listen(5000, () => console.log('Server started on port 5000'));
