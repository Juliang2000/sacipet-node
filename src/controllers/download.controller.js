exports.downloandFile = async(req, res) => {    
    
    try {        
        const fileName = req.params.name;    
        const directoryPath = __dirname + "/../uploads/";
        res.download(directoryPath + fileName, fileName, (err) => {
            if (err) {
              res.status(500).send({
                message: "Could not download the file. " + err,
              });
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({
            ok: false,
            error: err.message
        });
    }
};


