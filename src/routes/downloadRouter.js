const router = require("express").Router();
const downloadController = require('../controllers/download.controller');




//=========================================================
// Descarga archivos de un directorio
//=========================================================

router.post("/files", downloadController.downloandFile)

module.exports = { router };