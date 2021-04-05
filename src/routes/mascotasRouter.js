const router = require("express").Router();

const { obtenerPorId } = require('../controllers/usuarioVet.controller');
const adops = require('../controllers/mascotas.controller');
const razas = require('../controllers/razas.controller');
const colores = require('../controllers/colores.controller');


//const {createvacunacion} = require('../controllers/mascotas.controller');
//router.post('/usersc/id_mascota', createvacunacion)
//===========================================
//Guarda registro en la tabla mascotas
//===========================================

router.post("/mascotas", async(req, res) => {

    try {
        /**Se toman solo los campos necesarios 
         * que vienen en el body de la petición
         * 
         * El campo "tamanio" es opcional, ya que
         * solo se aplica para perros
         * 
         * El campo "descripcion_mascota" también es opcional
         * y se aplica para cualquier tipo de animal
         */
        const {
            nombre_mascota,
            edad_mascota,
            escala_edad,
            esterilizado,
            genero_mascota,
            id_raza,
            id_tamanio,
            id_color,
            descripcion_mascota,
            id_usuario,
            tipo_tramite,
            id_codigo
    
        } = req.body;

        /**Se guardan dentro de un array,
         * solo los campos obligatorios recibidos en el body
         * de la petición 
         */
        const campos = [{
                nombre: 'nombre_mascota',
                campo: nombre_mascota
            },
            {
                nombre: 'edad_mascota',
                campo: edad_mascota
            },
            {
                nombre: 'escala_edad',
                campo: escala_edad
            },
            {
                nombre: 'esterilizado',
                campo: esterilizado
            },
            {
                nombre: 'id_raza',
                campo: id_raza
            },
            {
                nombre: 'genero_mascota',
                campo: genero_mascota
            },
            {
                nombre: 'id_color',
                campo: id_color
            },
            {
                nombre: 'descripcion_mascota',
                campo: descripcion_mascota
            },
            {
                nombre: 'id_usuario',
                campo: id_usuario
            },
            {
                nombre: 'tipo_tramite',
                campo: tipo_tramite
            },
            {
                nombre: 'id_codigo',
                campo: id_codigo
            }
        ];

        /**Se busca en el array si alguno de los campos obligatorios 
         * no fue recibido,
         * en caso de que se encuentre algún campo vacio se guarda el 
         * elemento encontrado dentro de la constante llamada "campoVacio"
         */
        const campoVacio = campos.find(x => !x.campo);

        /**Si alguno de los campos NO fue enviado en la petición
         * se le muestra al cliente el nombre del campo que falta
         */
        if (campoVacio) {

            return res.status(400).json({
                ok: false,
                msg: `No ha ingresado el campo ${campoVacio.nombre}`
            });
        }

        
        /**Se verifica si el id_raza
         * se encuentra registrado*/
        const razaExiste = await razas.obtenerPorIdRaza(id_raza);

        /**Si la función devuelve un valor igual a null
         * quiere decir que el id_raza NO existe*/
        if (razaExiste === null) {

            return res.status(400).json({
                ok: false,
                msg: `El id_raza ingresado: ${id_raza} no existe`
            });
        }

        /**Se verifica si el id_raza
         * se encuentra relacionado a el tipo de mascota Perro*/
        const esRazaTipoPerro = await razas.obtenerMascotaTipoPerro(id_raza);

        /**Si la función devuelve un valor diferente de null
         * quiere decir que el id_raza SI está relacionado
         * al tipo de mascota 'Perro'
         * 
         * Esta validación se hace porque cuando se registra 
         * la adopción de un "Perro" se debe especificar
         * el tamaño, para el resto de animales NO
         * es necesario especificar el tamaño
         * */
        if (esRazaTipoPerro !== null) {

            //Si el campo "id_tamanio" NO se envió
            if (!id_tamanio) {
                return res.status(400).json({
                    ok: false,
                    msg: `No ha ingresado el campo id_tamanio para perro`
                });
            }
        }


        const esRazaTipoGato = await razas.obtenerMascotaTipoGato(id_raza);

        if (esRazaTipoGato !== null) {

            //Si el campo "id_tamanio" NO se envió
            if (!id_tamanio) {
                return res.status(400).json({
                    ok: false,
                    msg: `No ha ingresado el campo id_tamanio para gato`
                });
            }
        }

        /**Se verifica si el id_color
         * se encuentra registrado*/
        const colorExiste = await colores.obtenerPorIdColor(id_color);

        /**Si la función devuelve un valor igual a null
         * quiere decir que el id_color NO existe*/
        if (colorExiste === null) {

            return res.status(400).json({
                ok: false,
                msg: `El id_color ingresado: ${id_color} no existe`
            });
        }


        /**Se verifica si el id_usuario
         * se encuentra registrado*/
        const usuarioExiste = await obtenerPorId(id_usuario);

        /**Si la función devuelve un valor igual a null
         * quiere decir que el id_usuario NO existe*/
        if (usuarioExiste === null) {

            return res.status(400).json({
                ok: false,
                msg: `El id_usuario ingresado: ${id_usuario} no existe`
            });
        }

        /**Se llama a la función que hace el registro y se obtiene la respuesta, 
         * ya sea el id que se acaba de registrar o 0,
         * y se guarda el número dentro de la constante "id_mascota"
         */
        const id_mascota = await adops.crear(req);

        /**Si la función retorna 0, quiere decir
         * que la mascota no se pudo crear
         */
        if (id_mascota === 0) {

            res.status(500).json({
                ok: false,
                msg: `Ocurrió un error al guardar la adopción`
            });
        }
        /**Sino quiere decir que la función retornó un
         * números distinto de 0 y se registro la adopción
         */
        else {

            /**Se busca la mascota que se acaba de crear
             * dado el id_mascota que se acaba de obtener
             */
            const mascota = await adops.obtenerPorId(id_mascota);

            res.json({
                ok: true,
                msg: `Mascota guardada exitosamente`,
                mascota
            });
        }

    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });

    }
});

//===========================================
//Mostrar todas las mascotas registradas
//===========================================

router.get("/mascotas", async(req, res) => {

    try {

        const {
            id_mascota,
            consecutivo
    
        } = req.body;

        /**Se obtienen todas las mascotas registradas en la tabla
         * "mascotas" y se guarda el resultado de la consulta dentro
         * de la constante "mascotas"
         */
        
        const mascotas = await adops.obtenerTodas();
        
        
       // const mascotas2 = await route.downloadController.downloandFile(1,2);
        /**Si la función retorna null, quiere decir
         * que no se encontraron mascotas registradas
         */
        if (mascotas === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay mascotas registradas`
            });

        } else {
            res.json({
                ok: true,
                mascotas,
              //  mascotas2
            })
        }


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});

//===========================================
/**Mostrar las mascotas fitrándolas por: 
 * tipo de mascota, tamaño, color*/
//===========================================
router.get("/buscarmascotas", async(req, res) => {

    try {
        /**Se toman solo los parámetros necesarios 
         * que vienen en la URL de la petición*/
        const {
            tipo_mascota,
            tamanio,
            color
        } = req.query;

        let mascotas;

        /**Se verifica que el parámetro "tipo_mascota" SI se
         * haya recibido, y que "tamanio" y "color"
         * NO se hayan recibido*/
        if (tipo_mascota && !tamanio && !color) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte solamente 
             * por el parámetro: 
             * 
             * -"tipo_mascota", de la tabla "tipo_mascotas"
             */
            mascotas = await adops.obtenerPorTipoMascota(tipo_mascota);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el 
             * tipo de mascota indicado
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay mascotas del tipo número ${tipo_mascota} disponibles en adopción`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban al parámetro de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }
        /**Se verifica que el parámetro "tamanio" SI se
         * haya recibido, y que "tipo_mascota" y "color"
         * NO se hayan recibido*/
        else if (tamanio && !tipo_mascota && !color) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte solamente 
             * por el parámetro: 
             * 
             * -"tamanio", de la tabla "tamanios"
             */
            mascotas = await adops.obtenerPorTananio(tamanio);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el 
             * tamaño indicado
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay mascotas de tamaño ${tamanio} en adopción`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban al parámetro de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }
        /**Se verifica que el parámetro "color" SI se
         * haya recibido, y que "tipo_mascota" y "tamanio"
         * NO se hayan recibido*/
        else if (color && !tipo_mascota && !tamanio) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte solamente 
             * por el campo: 
             * 
             * -"color", de la tabla "t_colores"
             */
            mascotas = await adops.obtenerPorColor(color);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el color 
             * indicado
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay mascotas en adopción registrados con el color: ${color}`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban al parámetro de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }

        /**Se verifica que los parámetros "tipo_mascota" y "tamanio" SI se
         * hayan recibido, y que "color" NO se haya recibido*/
        else if (tipo_mascota && tamanio && !color) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte solamente 
             * por los parámetros:
             *  
             * -"tipo_mascota" de la tabla "tipos_mascotas"
             * 
             * -"tamanio" de la tabla "tamanios"
             */
            mascotas = await adops.obtenerPorTipoMascotaYTamanio(tipo_mascota, tamanio);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el  
             * tipo de mascota y tamaño indicados
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay: ${tipo_mascota} de tamaño: ${tamanio} en adopción`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban a todos los parámetros de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }
        /**Se verifica que los parámetros "tamanio" y "color" SI se
         * hayan recibido, y que "tipo_mascota" NO se haya recibido*/
        if (tamanio && color && !tipo_mascota) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte solamente 
             * por los parámetros:
             *  
             * -"tamanio" de la tabla "tamanios"
             * 
             * -"color" de la tabla t_colores
             */
            mascotas = await adops.obtenerPorTamanioYColor(tamanio, color);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el  
             * tamaño y color indicados
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay mascotas de tamaño: ${tamanio} y en color: ${color} en adopción`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban a todos los parámetros de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }
        /**Se verifica que los parámetros "tipo_mascota" y "color" SI se
         * hayan recibido, y que "tamanio" NO se haya recibido*/
        else if (tipo_mascota && color && !tamanio) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte solamente 
             * por los parámetros:
             *  
             * -"tipo_mascota" de la tabla "tipos_mascotas"
             * 
             * -"color" de ña tabla t_colores
             */
            mascotas = await adops.obtenerPorTipoMascotaYColor(tipo_mascota, color);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el  
             * tipo de mascota y color indicados
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay ${tipo_mascota} y en color: ${color} en adopción`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban a todos los parámetros de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }
        /**Se verifica que TODOS los parámetros se hayan recibido 
         * ("tipo_mascota", "tamanio" y "color")*/
        else if (tipo_mascota && tamanio && color) {

            /**Se llama a la función para que se haga la búsqueda
             * de los datos de las mascotas disponibles,
             * y filte por los parámetros:
             *  
             * -"tipo_mascota" de la tabla "tipos_mascotas"
             * 
             * -"tamanio" de la tabla "tamanios"
             * 
             * -"color" de ña tabla t_colores
             */
            mascotas =
                await adops.obtenerPorTipoMascotaTamanioYColor(tipo_mascota, tamanio, color);

            /**Si la función retorna null, quiere decir
             * que no se encontraron mascotas registradas con el  
             * tipo de mascota, tamaño y color indicados
             */
            if (mascotas === null) {

                res.status(400).json({
                    ok: false,
                    msg: `Aún no hay ${tipo_mascota}, en tamaño: ${tamanio} y en color: ${color} en adopción`
                });

            }
            /**Sino quiere decir que se encontró 1 o más registros
             * que se ajustaban a todos los parámetros de búsqueda
             */
            else {
                res.json({
                    ok: true,
                    mascotas
                });
            }
        }
        /**En caso de que no se haya recibido ninguno de los 
         * parámetros ("tipo_mascota", "tamanio" y "color")
         * */
        else if (!tipo_mascota && !tamanio && !color) {

            /**Se muestra un mensaje indicándole al usuario
             * que debe colocar por lo menos 1 de los 3 parámetros
             * para hacer la búsqueda con filtro
             */
            res.status(400).json({
                ok: false,
                msg: `Debe especificar por lo menos 1 parámetro para hacer la búsqueda con filtro`
            });
        }

    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});





router.post("/PublicacionMascota", async(req, res) => {

    try {

        const {
            publicado,
            id_mascota,
            id_usuario
    
        } = req.body;

       
        
        const mascotas = await adops.PublicacionMascota( publicado,id_mascota,id_usuario);
        
        
    
        
            res.json({
                ok: true,
                message:'mascota eliminada exitosamente'
              
            })
        


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});












router.post("/MascotasDesactivadas", async(req, res) => {

    try {

        const {
            id_usuario
    
        } = req.body;

      
        
        const mascotas = await adops.MascotasDesactivadas(id_usuario);
        
        
       // const mascotas2 = await route.downloadController.downloandFile(1,2);
        /**Si la función retorna null, quiere decir
         * que no se encontraron mascotas registradas
         */
        if (mascotas === null) {

            res.status(400).json({
                ok: false,
                msg: `Aún no hay mascotas registradas`
            });

        } else {
            res.json({
                ok: true,
                mascotas,
              //  mascotas2
            })
        }


    } catch (err) {
        console.log(err);

        res.status(500).json({
            ok: false,
            error: err.message
        });
    }

});

module.exports = { router };