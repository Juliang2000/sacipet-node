const router = require("express").Router();
const downloadController = require('../controllers/download.controller');

//=========================================================
// Descarga archivos de un directorio
//=========================================================

router.get("/files/:name", downloadController.downloandFile)

module.exports = { router };