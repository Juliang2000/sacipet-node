const router = require("express").Router();

//=========================================================
// Sube archivos a un directorio
//=========================================================
const uploadController = require('../controllers/upload.controller');

router.post("/upload", uploadController.uploadFile)
router.post("/upload2", uploadController.uploadFileUser)
module.exports = { router };
//app.listen(5000, () => console.log('Server started on port 5000'));
