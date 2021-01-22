// puerto

process.env.PORT = process.env.PORT || 3000;

// hash

process.env.PASSWORD_SALT = process.env.PASSWORD_SALT || "$2a$10$9sXM3igY5wQC9A0saqBVtO"

// token

process.env.JWT_SECRET = `cualquiercosa`

// google client ID

process.env.CLIENT_ID = process.env.CLIENT_ID || '455409927963-pjq50ke82as4i9mv4163pimvcj5889r6.apps.googleusercontent.com'

//facebook
process.env.FACEBOOK_CLIENT_ID = process.env.FACEBOOK_CLIENT_ID || '398513521394376'
process.env.FACEBOOK_CLIENT_SECRET = process.env.FACEBOOK_CLIENT_SECRET || 'd4dfac9a3063c1079a44010e89d7f6f5'
process.env.URL_FACEBOOK = process.env.URL_FACEBOOK || 'http://localhost.com'
    //'http://localhostx.test:3000/url_facebook'


//==============================
// SEED (Semilla de autenticación)
//==============================
process.env.SEED = process.env.SEED || 'este-es-el-seed-desarrollo';

//==============================
// Vencimiento del token
//==============================
//60 segundos
//60 minutos
//24 horas
//30 días
process.env.CADUCIDAD_TOKEN = 60 * 60 * 24 * 30;