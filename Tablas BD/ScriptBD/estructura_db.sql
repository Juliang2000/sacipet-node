-- public.t_usuario definition

-- Drop table

-- DROP TABLE public.t_usuario;

CREATE SEQUENCE id_usuario;

CREATE TABLE public.t_usuario (
	id int NOT NULL,
	nombres varchar(100) NULL,
	apellidos varchar(100) NULL,
	"password" varchar(100) NULL,
	correo varchar(50) NOT NULL,
	origen_cuenta varchar(16) NOT NULL DEFAULT 'Registro Normal'::character varying,
	estado bool NULL DEFAULT true,	
	telefono varchar(12) NULL,
	CONSTRAINT t_usuario_pkey PRIMARY KEY (id)
);

ALTER TABLE t_usuario ALTER COLUMN id SET DEFAULT nextval('id_usuario'::regclass);




CREATE TABLE public.t_rol (
    id integer NOT null unique,
    nombre character varying(50) NOT NULL
);

-- public.t_rol_usuario definition

-- Drop table

-- DROP TABLE public.t_rol_usuario;

CREATE TABLE public.t_rol_usuario (
	id_rol int4 NOT NULL,
	id_usuario int4 NOT NULL
);


-- public.t_rol_usuario foreign keys

ALTER TABLE public.t_rol_usuario ADD CONSTRAINT t_rol_usuario_fk FOREIGN KEY (id_rol) REFERENCES t_rol(id);
ALTER TABLE public.t_rol_usuario ADD CONSTRAINT t_rol_usuario_fk_1 FOREIGN KEY (id_usuario) REFERENCES t_usuario(id);
	
INSERT INTO public.t_rol
(id, nombre)
VALUES(1, 'niveluno'),(2, 'niveldos'),(3, 'niveltres');

ALTER TABLE ONLY t_usuario ALTER COLUMN origen_cuenta SET DEFAULT 'Registro Normal';



-- public.t_tipo_documento definition

-- Drop table

-- DROP TABLE public.t_tipo_documento;

CREATE TABLE public.t_tipo_documento (
	id serial NOT NULL,
	nombre varchar(100) NULL,
	CONSTRAINT t_tipo_documento_pk PRIMARY KEY (id)
);
		

-- public.t_departamento definition

-- Drop table

-- DROP TABLE public.t_departamento;

CREATE TABLE public.t_departamento (
	id int4 NOT NULL,
	nombre varchar(100) NULL,
	CONSTRAINT t_departamento_pk PRIMARY KEY (id)
);



-- public.t_municipios definition

-- Drop table

-- DROP TABLE public.t_municipios;

CREATE TABLE public.t_municipios (
	id_t_municipios serial NOT NULL,
	id_t_departamento int4 NULL,
	id varchar(3) NULL,
	nombre varchar(100) NULL,
	CONSTRAINT t_municipios_pkey PRIMARY KEY (id_t_municipios)
);



-- public.t_departamento foreign keys

ALTER TABLE public.t_departamento ADD CONSTRAINT t_departamento_fk FOREIGN KEY (id) REFERENCES t_municipios(id_t_municipios);

--Tablas para el calendario

CREATE TABLE public.t_paises
(
    id_pais integer NOT NULL,
    codigo character varying,
    nombre character varying,
    CONSTRAINT t_paises_pkey PRIMARY KEY (id_pais)
);

CREATE SEQUENCE t_paises_id_pais_seq;
ALTER TABLE t_paises ALTER COLUMN id_pais SET DEFAULT nextval('t_paises_id_pais_seq'::regclass);

--Se crea un pais

INSERT INTO public.t_paises(codigo, nombre)
	VALUES ('CO', 'Colombia');


--Se le agrega el campo id_pais a la tabla t_municipios

ALTER TABLE t_municipios 
ADD COLUMN id_pais integer;

--Se le asigna a todos los t_municipios (ciudades) que hay hasta ahora el pais Colombia

UPDATE t_municipios
SET id_pais = 1;

--Se le coloca la restricción de la llave foránea del campo id_pais, que viene 
--de la tabla t_paises a la tabla t_municipios 

ALTER TABLE t_municipios ADD CONSTRAINT t_municipios_id_pais_fk FOREIGN KEY (id_pais) REFERENCES t_paises(id_pais);


--Tabla t_vacunas

CREATE TABLE public.t_vacunas
(
    id integer NOT NULL,
    nombre character varying,
    CONSTRAINT t_vacunas_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE t_vacunas_id_seq;
ALTER TABLE t_vacunas ALTER COLUMN id SET DEFAULT nextval('t_vacunas_id_seq'::regclass);

--t_vacunas disponibles

INSERT INTO public.t_vacunas(nombre)
	VALUES ('Rabia');
		
INSERT INTO public.t_vacunas(nombre)
VALUES ('Rinotraqueítis');

INSERT INTO public.t_vacunas(nombre)
VALUES ('Parvovirus');

INSERT INTO public.t_vacunas(nombre)
VALUES ('Moquillo');

--Tabla t_tipos_mascotas
CREATE TABLE public.t_tipos_mascotas
(
    id_tipo_mascota integer NOT NULL,
    nombre_tipo character varying,
    CONSTRAINT t_tipos_mascotas_pkey PRIMARY KEY (id_tipo_mascota)
);

CREATE SEQUENCE t_tipos_mascotas_id_tipo_mascota;
ALTER TABLE t_tipos_mascotas ALTER COLUMN id_tipo_mascota SET DEFAULT nextval('t_tipos_mascotas_id_tipo_mascota'::regclass);

INSERT INTO public.t_tipos_mascotas(nombre_tipo)
VALUES ('Gato');

INSERT INTO public.t_tipos_mascotas(nombre_tipo)
VALUES ('Perro');

INSERT INTO public.t_tipos_mascotas(nombre_tipo)
VALUES ('Hámster');

--Tabla t_tamanios
CREATE TABLE public.t_tamanios
(
    id_tamanio integer NOT NULL,
    tamanio character varying,
	id_tipo_mascota int4 NOT NULL,
    CONSTRAINT t_tamanios_pkey PRIMARY KEY (id_tamanio)
);
--Se le coloca la restricción de la llave foránea del campo id_tipo_mascota, que viene 
--de la tabla t_tipos_mascotas a la tabla t_tamanios
ALTER TABLE t_tamanios ADD CONSTRAINT t_tamanios_id_tipo_mascota_fk FOREIGN KEY (id_tipo_mascota) REFERENCES t_tipos_mascotas(id_tipo_mascota);

CREATE SEQUENCE t_tamanios_id_tamanio;
ALTER TABLE t_tamanios ALTER COLUMN id_tamanio SET DEFAULT nextval('t_tamanios_id_tamanio'::regclass);

INSERT INTO public.t_tamanios(tamanio, id_tipo_mascota)
VALUES ('Grande', 2);

INSERT INTO public.t_tamanios(tamanio, id_tipo_mascota)
VALUES ('Mediano', 2);

INSERT INTO public.t_tamanios(tamanio, id_tipo_mascota)
VALUES ('Pequeño', 2);

--Tabla t_razas
CREATE TABLE public.t_razas
(
    id_raza integer NOT NULL,
    nombre_raza character varying,
	id_tipo_mascota int4 NOT NULL,
    CONSTRAINT t_razas_pkey PRIMARY KEY (id_raza)
);
--Se le coloca la restricción de la llave foránea del campo id_tipo_mascota, que viene 
--de la tabla t_tipos_mascotas a la tabla t_razas
ALTER TABLE t_razas ADD CONSTRAINT t_razas_id_tipo_mascota_fk FOREIGN KEY (id_tipo_mascota) REFERENCES t_tipos_mascotas(id_tipo_mascota);

CREATE SEQUENCE t_razas_id_raza;
ALTER TABLE t_razas ALTER COLUMN id_raza SET DEFAULT nextval('t_razas_id_raza'::regclass);

ALTER TABLE public.t_razas ADD COLUMN id_tamanio integer;
ALTER TABLE t_razas ADD CONSTRAINT t_razas_id_tamanio_fk FOREIGN KEY (id_tamanio) REFERENCES t_tamanios(id_tamanio);

INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pug',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Jack Russell Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Chiuahua',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Zuchón',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Shorkie',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Frenchton',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Teddy',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mal-shi',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Schnocker',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Shih-poo',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bullhuahua',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cavapoo',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Puggle',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Schnoodle',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cavachón',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Yorkie poos',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Chorkie',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Morkie',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Australian Cobberdog Miniatura',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cockapoo',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Goldendoodle Mini',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Maltipoo',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Labradoodle toy',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Podenco Portugués Pequeño',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Caniche',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Dandie Dinmont Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Affenpinscher',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cavalier King Charles spaniel',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Pomsky',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Xoloitzcuintle Toy',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Ratonero Valenciano',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Parson Russell Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cocker Spaniel Americano',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Galgo Italiano',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Peruano Pequeño',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bodeguero Andaluz',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bull Terrier Inglés Miniatura',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bichón Habanero',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bichón Boloñés',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Grifón Belga',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Petit Brabançon',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Grifón de Bruselas',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pinscher Miniatura',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('West Highland White Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Schnauzer Miniatura',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cairn Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Border Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Crestado Chino',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Caniche Toy',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Welsh corgi Pembroke',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor de los Pirineos',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Ratón de Praga',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Norfolk terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pekinés',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bichón Maltés',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Yorkshire Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Fox Paulistinha',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Staffordshire Bull Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Skye terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Schipperke',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Dachshund',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pomerania',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Terrier Australiano',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bichón frisé',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pequeño Perro León',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Spitz Alemán Pequeño',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Shih tzu',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Scottish terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bulldog Francés',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Boston Terrier',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Coton de Tuléar',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Fox Terrier de pelo liso',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Lhasa Apso',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Shiba inu',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Papillón',2,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Springer Spaniel Inglés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bernedoodle',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Kerry Blue Terrier',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('American Bully',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Braco Francés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Australian Cobberdog Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Kelpie Australiano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Goldendoodle Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Labradoodle Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Podenco Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Berger de Picardie',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Spitz Finlandés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cazador de Alces Noruego',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Podenco Canario',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Spaniel Bretón',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Holandés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro de Agua Portugués',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bedlington Terrier',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Terrier Tibetano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Xoloitzcuintle Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Harrier Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Peruano Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Chow Chow',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Samoyedo',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Caniche Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Catalán',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pit bull terrier americano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bulldog Americano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Welsh Corgi Cardigan',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bull terrier inglés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Beagle',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cocker spaniel inglés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Bergamasco',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro de agua español',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Appenzeller',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Ca de bou',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Basset Artesiano Normando',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Basset Hound',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor polaco de las llanuras',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pincher austriaco',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Staffordshire Terrier Americano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Basenji',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Soft coated wheaten terrier irlandés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Schnauzer estándar',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Spitz Alemán Mediano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Ganadero Australiano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bulldog Inglés',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Ovejero Australiano',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Fox terrier de pelo alambre',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Shar pei',2,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Dogo Canario',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Lobo Mexicano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mastín Inglés',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Rottweiler',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Husky Siberiano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Akita Americano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Belga Malinois',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Leopardo de Catahoula',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor de los Cárpatos',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mucuchíes',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pachón Navarro',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Chodsky',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Golden Retriever',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Shikoku Inu',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Kishu ken',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Cimarrón Uruguayo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pinscher Alemán',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Border Collie',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Goldador',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Pastor Croata',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Husky Inu',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('aïdi o perro de las montañas',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Aussiedoodle',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Azawakh',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Australian Cobberdog Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Goldendoodle Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Labradoodle estándar o grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Podenco Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Eurasier',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Caucásico',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Thai Ridgeback',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Alaskan Malamute',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Podenco Andaluz',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Podenco Ibicenco',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Foxhound Americano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mastín del Pirineo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mastín Español',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Sloughi',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Braco Italiano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Can de Palleiro',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Lobero Irlandés',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Kuvasz',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bloodhound',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bóxer',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Borzoi',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Lobo Checoslovaco',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Xoloitzcuintle Estándar',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Harrier Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Peruano Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Labrador Retriever',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Caniche Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Keeshond',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Collie de pelo largo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mastín Tibetano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor belga tervueren',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Terrier Negro Ruso',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Lobo de Saarloos',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor de las Islas Shetland',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Collie de pelo corto',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Schnauzer gigante',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Greyhound',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Braco Alemán de pelo corto',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Akita inu',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Boyero de Berna',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Airedale terrier',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor belga laekenois',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro crestado rodesiano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pointer inglés',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('San Bernardo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro de montaña de los pirineos',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Perro Terranova',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Corso Italiano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Collie Barbudo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Broholmer',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Galgo Español',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Weimaraner',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gran sabueso anglo-francés tricolor',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Saluki',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor de los Pirineos de cara rasa',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Nova Scotia duck tolling retriever',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor alemán',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Chesapeake bay retriever',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gran Danés',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mastín napolitano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Tosa Inu',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Whippet',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Dogo Argentino',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Fila Brasilero',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Lebrel escocés',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Dogo de Burdeos',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Boyero de Flandes',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Setter Irlandés Rojo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Bullmastiff',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Braco Húngaro',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Dálmata',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Kangal',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Spitz Alemán Grande',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Blanco Suizo',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor de Beauce',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Doberman Poinscher',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Pastor Belga Groendael',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Viejo Pastor Inglés',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Galgo Afgano',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Boerboel',2,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('criollo',2,null);

--t_razas gato
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato skookum',1,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato munchkin',1,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato devon rex',1,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato cornish rex',1,3);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato bobtail japonés',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato toyger',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato american wirehair',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato pixie bob',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato tonkinés',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato LaPerm',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato burmilla',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato curl americano',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato burmés',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato oriental de pelo largo',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato scottish fold',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Van turco',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato korat',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato somalí',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato sphynx o esfinge',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato sokoke',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato nebelung',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato lobo',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato ocelote',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato peterbald',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato oriental de pelo corto',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato siberiano',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato manx',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato exótico de pelo corto',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato birmano',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato snowshoe',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato abisinio',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato balinés',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('British shorthair',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato azul ruso',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato bombay',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Europeo',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Mau egipcio',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Australian Mist',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Himalayo',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato de la Habana',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Persa',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Siamés',1,2);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato montés',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato chausie',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Savannah',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato cartujo',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato selkirk rex',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato bosque de Noruega',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Gato de Bengala',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Ashera',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Maine coon',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Ragdoll',1,1);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('criollo',1,null);

--t_razas hamster
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Roborovski',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Chino',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Campbell',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Ruso',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Sirio o Dorado',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Siamés',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Oso Negro',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Angora',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Albino',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Arlequín',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('Hámster Panda',3,null);
INSERT INTO public.t_razas(nombre_raza, id_tipo_mascota,id_tamanio) VALUES ('criollo',3,null);


--Tabla t_colores
CREATE TABLE public.t_colores
(
    id_color integer NOT NULL,
    nombre_color character varying,
    CONSTRAINT t_colores_pkey PRIMARY KEY (id_color)
);

CREATE SEQUENCE t_colores_id_color_seq;
ALTER TABLE t_colores ALTER COLUMN id_color SET DEFAULT nextval('t_colores_id_color_seq'::regclass);

INSERT INTO public.t_colores(nombre_color)
VALUES ('Café');

INSERT INTO public.t_colores(nombre_color)
VALUES ('Negro');

INSERT INTO public.t_colores(nombre_color)
VALUES ('Gris');

INSERT INTO public.t_colores(nombre_color)
VALUES ('Blanco');

--Tabla t_mascotas
-- Table: public.t_mascotas

-- DROP TABLE public.t_mascotas;

CREATE TABLE public.t_mascotas
(
    id_mascota integer NOT NULL DEFAULT nextval('t_mascotas_id_mascota_seq'::regclass),
    nombre_mascota character varying COLLATE pg_catalog."default",
    edad_mascota integer NOT NULL,
    escala_edad integer NOT NULL,
    esterilizado integer,
    genero_mascota character varying COLLATE pg_catalog."default",
    id_raza integer NOT NULL,
    id_tamanio integer,
    id_color integer NOT NULL,
    descripcion_mascota character varying COLLATE pg_catalog."default",
    id_usuario integer NOT NULL,
    tipo_tramite integer NOT NULL,
    id_codigo integer,
    CONSTRAINT t_mascotas_pkey PRIMARY KEY (id_mascota),
    CONSTRAINT t_mascotas_id_codigo_fk FOREIGN KEY (id_codigo)
        REFERENCES public.t_ubicaciones_geograficas (id_codigo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT t_mascotas_id_color_fk FOREIGN KEY (id_color)
        REFERENCES public.t_colores (id_color) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT t_mascotas_id_raza_fk FOREIGN KEY (id_raza)
        REFERENCES public.t_razas (id_raza) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT t_mascotas_id_tamanio_fk FOREIGN KEY (id_tamanio)
        REFERENCES public.t_tamanios (id_tamanio) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT t_mascotas_id_usuario_fk FOREIGN KEY (id_usuario)
        REFERENCES public.t_usuario (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE public.t_mascotas
    OWNER to veterinarias;

--Se le coloca la restricción de la llave foránea del campo id_raza, que viene 
--de la tabla t_razas a la tabla t_mascotas
ALTER TABLE t_mascotas ADD CONSTRAINT t_mascotas_id_raza_fk FOREIGN KEY (id_raza) REFERENCES t_razas(id_raza);

--Se le coloca la restricción de la llave foránea del campo id_tamanio, que viene 
--de la tabla t_tamanios a la tabla t_mascotas
ALTER TABLE t_mascotas ADD CONSTRAINT t_mascotas_id_tamanio_fk FOREIGN KEY (id_tamanio) REFERENCES t_tamanios(id_tamanio);

--Se le coloca la restricción de la llave foránea del campo id_usuario, que viene 
--de la tabla t_usuario a la tabla t_mascotas
ALTER TABLE t_mascotas ADD CONSTRAINT t_mascotas_id_usuario_fk FOREIGN KEY (id_usuario) REFERENCES t_usuario(id);

--Se le coloca la restricción de la llave foránea del campo id_color, que viene 
--de la tabla t_colores a la tabla t_mascotas
ALTER TABLE t_mascotas ADD CONSTRAINT t_mascotas_id_color_fk FOREIGN KEY (id_color) REFERENCES t_colores(id_color);


--Tabla t_fotos

CREATE TABLE public.t_fotos
(
    id integer NOT NULL,
    ruta_guardado character varying,
    nombre_imagen character varying,
    id_mascota int4 NOT NULL,
    CONSTRAINT t_fotos_pkey PRIMARY KEY (id)
);

ALTER TABLE public.t_fotos ADD COLUMN consecutivo integer NOT NULL;

CREATE SEQUENCE t_fotos_id_seq;
ALTER TABLE t_fotos ALTER COLUMN id SET DEFAULT nextval('t_fotos_id_seq'::regclass);

--Se le coloca la restricción de la llave foránea del campo id_mascota, que viene 
--de la tabla t_mascotas a la tabla t_fotos
ALTER TABLE t_fotos ADD CONSTRAINT t_fotos_id_mascota_fk FOREIGN KEY (id_mascota) REFERENCES t_mascotas(id_mascota);

--Tabla que relaciona a la tabla t_mascotas con la tabla t_vacunas
CREATE TABLE public.t_mascotas_vacunas
(
    id integer NOT NULL,
    id_vacuna int4 NOT NULL,
    id_mascota int4 NOT NULL,
    CONSTRAINT t_mascotas_vacunas_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE t_mascotas_vacunas_id_seq;
ALTER TABLE t_mascotas_vacunas ALTER COLUMN id SET DEFAULT nextval('t_mascotas_vacunas_id_seq'::regclass);

--Se le coloca la restricción de la llave foránea del campo id_vacuna, que viene 
--de la tabla t_vacunas a la tabla t_mascotas_vacunas
ALTER TABLE t_mascotas_vacunas ADD CONSTRAINT t_mascotas_vacunas_id_vacuna_fk FOREIGN KEY (id_vacuna) REFERENCES t_vacunas(id);

--Se le coloca la restricción de la llave foránea del campo id_mascota, que viene 
--de la tabla t_mascotas a la tabla t_mascotas_vacunas
ALTER TABLE t_mascotas_vacunas ADD CONSTRAINT t_mascotas_vacunas_id_mascota_fk FOREIGN KEY (id_mascota) REFERENCES t_mascotas(id_mascota);

--Tabla ubicaciones geograficas 
CREATE TABLE public.t_ubicaciones_geograficas (
    id_codigo integer NOT NULL,
    descripcion character varying NOT NULL,
    id_unde integer NOT NULL,
    vigente boolean NOT NULL,
    codigo_dane integer NOT NULL,
    tipo character varying NOT NULL
);

--t_departamentos de Colombia

INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1, 'COLOMBIA', 0, true, 169, 'PA');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (2, 'BOGOTÁ', 1, true, 11, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (3, 'BOGOTÁ D.C', 2, true, 11001, 'CP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (4, 'AMAZONAS', 1, true, 91, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (5, 'LETICIA', 4, true, 91001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (6, 'EL ENCANTO', 4, true, 91263, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (7, 'LA CHORRERA', 4, true, 91405, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (8, 'LA PEDRERA', 4, true, 91407, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (9, 'LA VICTORIA', 4, true, 91430, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (10, 'MIRITI - PARANÁ', 4, true, 91460, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (11, 'PUERTO ALEGRÍA', 4, true, 91530, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (12, 'PUERTO ARICA', 4, true, 91536, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (13, 'PUERTO NARIÑO', 4, true, 91540, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (14, 'PUERTO SANTANDER', 4, true, 91669, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (15, 'TARAPACÁ', 4, true, 91798, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (16, 'ANTIOQUIA', 1, true, 5, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (17, 'MEDELLÍN', 16, true, 5001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (18, 'ABEJORRAL', 16, true, 5002, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (19, 'ABRIAQUÍ', 16, true, 5004, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (20, 'ALEJANDRÍA', 16, true, 5021, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (21, 'AMAGÁ', 16, true, 5030, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (22, 'AMALFI', 16, true, 5031, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (23, 'ANDES', 16, true, 5034, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (24, 'ANGELÓPOLIS', 16, true, 5036, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (25, 'ANGOSTURA', 16, true, 5038, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (26, 'ANORÍ', 16, true, 5040, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (27, 'SANTAFÉ DE ANTIOQUIA', 16, true, 5042, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (28, 'ANZA', 16, true, 5044, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (29, 'APARTADÓ', 16, true, 5045, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (30, 'ARBOLETES', 16, true, 5051, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (31, 'ARGELIA', 16, true, 5055, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (32, 'ARMENIA', 16, true, 5059, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (33, 'BARBOSA', 16, true, 5079, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (34, 'BELMIRA', 16, true, 5086, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (35, 'BELLO', 16, true, 5088, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (36, 'BETANIA', 16, true, 5091, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (37, 'BETULIA', 16, true, 5093, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (38, 'CIUDAD BOLÍVAR', 16, true, 5101, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (39, 'BRICEÑO', 16, true, 5107, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (40, 'BURITICÁ', 16, true, 5113, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (41, 'CÁCERES', 16, true, 5120, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (42, 'CAICEDO', 16, true, 5125, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (43, 'CALDAS', 16, true, 5129, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (44, 'CAMPAMENTO', 16, true, 5134, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (45, 'CAÑASGORDAS', 16, true, 5138, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (46, 'CARACOLÍ', 16, true, 5142, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (47, 'CARAMANTA', 16, true, 5145, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (48, 'CAREPA', 16, true, 5147, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (49, 'EL CARMEN DE VIBORAL', 16, true, 5148, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (50, 'CAt_rolINA', 16, true, 5150, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (51, 'CAUCASIA', 16, true, 5154, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (52, 'CHIGORODÓ', 16, true, 5172, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (53, 'CISNEROS', 16, true, 5190, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (54, 'COCORNÁ', 16, true, 5197, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (55, 'CONCEPCIÓN', 16, true, 5206, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (56, 'CONCORDIA', 16, true, 5209, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (57, 'COPACABANA', 16, true, 5212, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (58, 'DABEIBA', 16, true, 5234, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (59, 'DONMATÍAS', 16, true, 5237, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (60, 'EBÉJICO', 16, true, 5240, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (61, 'EL BAGRE', 16, true, 5250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (62, 'ENTRERRIOS', 16, true, 5264, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (63, 'ENVIGADO', 16, true, 5266, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (64, 'FREDONIA', 16, true, 5282, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (65, 'FRONTINO', 16, true, 5284, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (66, 'GIRALDO', 16, true, 5306, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (67, 'GIRARDOTA', 16, true, 5308, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (68, 'GÓMEZ PLATA', 16, true, 5310, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (69, 'GRANADA', 16, true, 5313, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (70, 'GUADALUPE', 16, true, 5315, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (71, 'GUARNE', 16, true, 5318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (72, 'GUATAPE', 16, true, 5321, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (73, 'HELICONIA', 16, true, 5347, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (74, 'HISPANIA', 16, true, 5353, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (75, 'ITAGUI', 16, true, 5360, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (76, 'ITUANGO', 16, true, 5361, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (77, 'JARDÍN', 16, true, 5364, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (78, 'JERICÓ', 16, true, 5368, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (79, 'LA CEJA', 16, true, 5376, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (80, 'LA ESTRELLA', 16, true, 5380, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (81, 'LA PINTADA', 16, true, 5390, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (82, 'LA UNIÓN', 16, true, 5400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (83, 'LIBORINA', 16, true, 5411, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (84, 'MACEO', 16, true, 5425, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (85, 'MARINILLA', 16, true, 5440, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (86, 'MONTEBELLO', 16, true, 5467, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (87, 'MURINDÓ', 16, true, 5475, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (88, 'MUTATÁ', 16, true, 5480, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (89, 'NARIÑO', 16, true, 5483, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (90, 'NECOCLÍ', 16, true, 5490, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (91, 'NECHÍ', 16, true, 5495, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (92, 'OLAYA', 16, true, 5501, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (93, 'PEÑOL', 16, true, 5541, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (94, 'PEQUE', 16, true, 5543, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (95, 'PUEBLORRICO', 16, true, 5576, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (96, 'PUERTO BERRÍO', 16, true, 5579, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (97, 'PUERTO NARE', 16, true, 5585, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (98, 'PUERTO TRIUNFO', 16, true, 5591, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (99, 'REMEDIOS', 16, true, 5604, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (100, 'RETIRO', 16, true, 5607, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (101, 'RIONEGRO', 16, true, 5615, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (102, 'SABANALARGA', 16, true, 5628, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (103, 'SABANETA', 16, true, 5631, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (104, 'SALGAR', 16, true, 5642, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (105, 'SAN ANDRÉS DE CUERQUÍA', 16, true, 5647, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (106, 'SAN CARLOS', 16, true, 5649, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (107, 'SAN FRANCISCO', 16, true, 5652, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (108, 'SAN JERÓNIMO', 16, true, 5656, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (109, 'SAN JOSÉ DE LA MONTAÑA', 16, true, 5658, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (110, 'SAN JUAN DE URABÁ', 16, true, 5659, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (111, 'SAN LUIS', 16, true, 5660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (112, 'SAN PEDRO DE LOS MILAGROS', 16, true, 5664, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (113, 'SAN PEDRO DE URABA', 16, true, 5665, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (114, 'SAN RAFAEL', 16, true, 5667, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (115, 'SAN ROQUE', 16, true, 5670, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (116, 'SAN VICENTE', 16, true, 5674, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (117, 'SANTA BÁRBARA', 16, true, 5679, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (118, 'SANTA ROSA DE OSOS', 16, true, 5686, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (119, 'SANTO DOMINGO', 16, true, 5690, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (120, 'EL SANTUARIO', 16, true, 5697, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (121, 'SEGOVIA', 16, true, 5736, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (122, 'SONSON', 16, true, 5756, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (123, 'SOPETRÁN', 16, true, 5761, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (124, 'TÁMESIS', 16, true, 5789, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (125, 'TARAZÁ', 16, true, 5790, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (126, 'TARSO', 16, true, 5792, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (127, 'TITIRIBÍ', 16, true, 5809, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (128, 'TOLEDO', 16, true, 5819, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (129, 'TURBO', 16, true, 5837, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (130, 'URAMITA', 16, true, 5842, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (131, 'URRAO', 16, true, 5847, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (132, 'VALDIVIA', 16, true, 5854, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (133, 'VALPARAÍSO', 16, true, 5856, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (134, 'VEGACHÍ', 16, true, 5858, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (135, 'VENECIA', 16, true, 5861, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (136, 'VIGÍA DEL FUERTE', 16, true, 5873, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (137, 'YALÍ', 16, true, 5885, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (138, 'YARUMAL', 16, true, 5887, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (139, 'YOLOMBÓ', 16, true, 5890, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (140, 'YONDÓ', 16, true, 5893, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (141, 'ZARAGOZA', 16, true, 5895, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (142, 'ARAUCA', 1, true, 81, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (143, 'ARAUCA', 142, true, 81001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (144, 'ARAUQUITA', 142, true, 81065, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (145, 'CRAVO NORTE', 142, true, 81220, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (146, 'FORTUL', 142, true, 81300, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (147, 'PUERTO RONDÓN', 142, true, 81591, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (148, 'SARAVENA', 142, true, 81736, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (149, 'TAME', 142, true, 81794, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (150, 'ATLÁNTICO', 1, true, 8, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (151, 'BARRANQUILLA', 150, true, 8001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (152, 'BARANOA', 150, true, 8078, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (153, 'CAMPO DE LA CRUZ', 150, true, 8137, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (154, 'CANDELARIA', 150, true, 8141, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (155, 'GALAPA', 150, true, 8296, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (156, 'JUAN DE ACOSTA', 150, true, 8372, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (157, 'LURUACO', 150, true, 8421, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (158, 'MALAMBO', 150, true, 8433, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (159, 'MANATÍ', 150, true, 8436, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (160, 'PALMAR DE VARELA', 150, true, 8520, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (161, 'PIOJÓ', 150, true, 8549, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (162, 'POLONUEVO', 150, true, 8558, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (163, 'PONEDERA', 150, true, 8560, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (164, 'PUERTO COLOMBIA', 150, true, 8573, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (165, 'REPELÓN', 150, true, 8606, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (166, 'SABANAGRANDE', 150, true, 8634, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (167, 'SABANALARGA', 150, true, 8638, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (168, 'SANTA LUCÍA', 150, true, 8675, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (169, 'SANTO TOMÁS', 150, true, 8685, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (170, 'SOLEDAD', 150, true, 8758, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (171, 'SUAN', 150, true, 8770, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (172, 'TUBARÁ', 150, true, 8832, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (173, 'USIACURÍ', 150, true, 8849, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (174, 'BOLIVAR', 1, true, 13, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (175, 'CARTAGENA', 174, true, 13001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (176, 'ACHÍ', 174, true, 13006, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (177, 'ALTOS DEL ROSARIO', 174, true, 13030, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (178, 'ARENAL', 174, true, 13042, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (179, 'ARJONA', 174, true, 13052, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (180, 'ARROYOHONDO', 174, true, 13062, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (181, 'BARRANCO DE LOBA', 174, true, 13074, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (182, 'CALAMAR', 174, true, 13140, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (183, 'CANTAGALLO', 174, true, 13160, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (184, 'CICUCO', 174, true, 13188, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (185, 'CÓRDOBA', 174, true, 13212, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (186, 'CLEMENCIA', 174, true, 13222, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (187, 'EL CARMEN DE BOLÍVAR', 174, true, 13244, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (188, 'EL GUAMO', 174, true, 13248, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (189, 'EL PEÑÓN', 174, true, 13268, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (190, 'HATILLO DE LOBA', 174, true, 13300, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (191, 'MAGANGUÉ', 174, true, 13430, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (192, 'MAHATES', 174, true, 13433, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (193, 'MARGARITA', 174, true, 13440, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (194, 'MARÍA LA BAJA', 174, true, 13442, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (195, 'MONTECRISTO', 174, true, 13458, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (196, 'MOMPÓS', 174, true, 13468, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (197, 'MORALES', 174, true, 13473, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (198, 'NOROSÍ', 174, true, 13490, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (199, 'PINILLOS', 174, true, 13549, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (200, 'REGIDOR', 174, true, 13580, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (201, 'RÍO VIEJO', 174, true, 13600, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (202, 'SAN CRISTÓBAL', 174, true, 13620, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (203, 'SAN ESTANISLAO', 174, true, 13647, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (204, 'SAN FERNANDO', 174, true, 13650, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (205, 'SAN JACINTO', 174, true, 13654, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (206, 'SAN JACINTO DEL CAUCA', 174, true, 13655, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (207, 'SAN JUAN NEPOMUCENO', 174, true, 13657, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (208, 'SAN MARTÍN DE LOBA', 174, true, 13667, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (209, 'SAN PABLO', 174, true, 13670, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (210, 'SANTA CATALINA', 174, true, 13673, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (211, 'SANTA ROSA', 174, true, 13683, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (212, 'SANTA ROSA DEL SUR', 174, true, 13688, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (213, 'SIMITÍ', 174, true, 13744, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (214, 'SOPLAVIENTO', 174, true, 13760, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (215, 'TALAIGUA NUEVO', 174, true, 13780, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (216, 'TIQUISIO', 174, true, 13810, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (217, 'TURBACO', 174, true, 13836, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (218, 'TURBANÁ', 174, true, 13838, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (219, 'VILLANUEVA', 174, true, 13873, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (220, 'ZAMBRANO', 174, true, 13894, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (221, 'BOYACÁ', 1, true, 15, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (222, 'TUNJA', 221, true, 15001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (223, 'ALMEIDA', 221, true, 15022, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (224, 'AQUITANIA', 221, true, 15047, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (225, 'ARCABUCO', 221, true, 15051, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (226, 'BELÉN', 221, true, 15087, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (227, 'BERBEO', 221, true, 15090, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (228, 'BETÉITIVA', 221, true, 15092, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (229, 'BOAVITA', 221, true, 15097, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (230, 'BOYACÁ', 221, true, 15104, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (231, 'BRICEÑO', 221, true, 15106, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (232, 'BUENAVISTA', 221, true, 15109, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (233, 'BUSBANZÁ', 221, true, 15114, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (234, 'CALDAS', 221, true, 15131, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (235, 'CAMPOHERMOSO', 221, true, 15135, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (236, 'CERINZA', 221, true, 15162, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (237, 'CHINAVITA', 221, true, 15172, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (238, 'CHIQUINQUIRÁ', 221, true, 15176, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (239, 'CHISCAS', 221, true, 15180, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (240, 'CHITA', 221, true, 15183, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (241, 'CHITARAQUE', 221, true, 15185, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (242, 'CHIVATÁ', 221, true, 15187, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (243, 'CIÉNEGA', 221, true, 15189, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (244, 'CÓMBITA', 221, true, 15204, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (245, 'COPER', 221, true, 15212, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (246, 'CORRALES', 221, true, 15215, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (247, 'COVARACHÍA', 221, true, 15218, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (248, 'CUBARÁ', 221, true, 15223, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (249, 'CUCAITA', 221, true, 15224, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (250, 'CUÍTIVA', 221, true, 15226, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (251, 'CHÍQUIZA', 221, true, 15232, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (252, 'CHIVOR', 221, true, 15236, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (253, 'DUITAMA', 221, true, 15238, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (254, 'EL COCUY', 221, true, 15244, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (255, 'EL ESPINO', 221, true, 15248, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (256, 'FIRAVITOBA', 221, true, 15272, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (257, 'FLORESTA', 221, true, 15276, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (258, 'GACHANTIVÁ', 221, true, 15293, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (259, 'GAMEZA', 221, true, 15296, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (260, 'GARAGOA', 221, true, 15299, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (261, 'GUACAMAYAS', 221, true, 15317, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (262, 'GUATEQUE', 221, true, 15322, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (263, 'GUAYATÁ', 221, true, 15325, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (264, 'GÜICÁN', 221, true, 15332, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (265, 'IZA', 221, true, 15362, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (266, 'JENESANO', 221, true, 15367, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (267, 'JERICÓ', 221, true, 15368, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (268, 'LABRANZAGRANDE', 221, true, 15377, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (269, 'LA CAPILLA', 221, true, 15380, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (270, 'LA VICTORIA', 221, true, 15401, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (271, 'LA UVITA', 221, true, 15403, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (272, 'VILLA DE LEYVA', 221, true, 15407, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (273, 'MACANAL', 221, true, 15425, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (274, 'MARIPÍ', 221, true, 15442, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (275, 'MIRAFLORES', 221, true, 15455, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (276, 'MONGUA', 221, true, 15464, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (277, 'MONGUÍ', 221, true, 15466, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (278, 'MONIQUIRÁ', 221, true, 15469, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (279, 'MOTAVITA', 221, true, 15476, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (280, 'MUZO', 221, true, 15480, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (281, 'NOBSA', 221, true, 15491, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (282, 'NUEVO COLÓN', 221, true, 15494, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (283, 'OICATÁ', 221, true, 15500, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (284, 'OTANCHE', 221, true, 15507, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (285, 'PACHAVITA', 221, true, 15511, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (286, 'PÁEZ', 221, true, 15514, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (287, 'PAIPA', 221, true, 15516, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (288, 'PAJARITO', 221, true, 15518, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (289, 'PANQUEBA', 221, true, 15522, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (290, 'PAUNA', 221, true, 15531, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (291, 'PAYA', 221, true, 15533, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (292, 'PAZ DE RÍO', 221, true, 15537, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (293, 'PESCA', 221, true, 15542, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (294, 'PISBA', 221, true, 15550, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (295, 'PUERTO BOYACÁ', 221, true, 15572, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (296, 'QUÍPAMA', 221, true, 15580, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (297, 'RAMIRIQUÍ', 221, true, 15599, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (298, 'RÁQUIRA', 221, true, 15600, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (299, 'RONDÓN', 221, true, 15621, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (300, 'SABOYÁ', 221, true, 15632, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (301, 'SÁCHICA', 221, true, 15638, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (302, 'SAMACÁ', 221, true, 15646, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (303, 'SAN EDUARDO', 221, true, 15660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (304, 'SAN JOSÉ DE PARE', 221, true, 15664, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (305, 'SAN LUIS DE GACENO', 221, true, 15667, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (306, 'SAN MATEO', 221, true, 15673, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (307, 'SAN MIGUEL DE SEMA', 221, true, 15676, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (308, 'SAN PABLO DE BORBUR', 221, true, 15681, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (309, 'SANTANA', 221, true, 15686, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (310, 'SANTA MARÍA', 221, true, 15690, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (311, 'SANTA ROSA DE VITERBO', 221, true, 15693, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (312, 'SANTA SOFÍA', 221, true, 15696, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (313, 'SATIVANORTE', 221, true, 15720, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (314, 'SATIVASUR', 221, true, 15723, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (315, 'SIACHOQUE', 221, true, 15740, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (316, 'SOATÁ', 221, true, 15753, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (317, 'SOCOTÁ', 221, true, 15755, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (318, 'SOCHA', 221, true, 15757, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (319, 'SOGAMOSO', 221, true, 15759, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (320, 'SOMONDOCO', 221, true, 15761, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (321, 'SORA', 221, true, 15762, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (322, 'SOTAQUIRÁ', 221, true, 15763, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (323, 'SORACÁ', 221, true, 15764, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (324, 'SUSACÓN', 221, true, 15774, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (325, 'SUTAMARCHÁN', 221, true, 15776, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (326, 'SUTATENZA', 221, true, 15778, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (327, 'TASCO', 221, true, 15790, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (328, 'TENZA', 221, true, 15798, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (329, 'TIBANÁ', 221, true, 15804, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (330, 'TIBASOSA', 221, true, 15806, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (331, 'TINJACÁ', 221, true, 15808, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (332, 'TIPACOQUE', 221, true, 15810, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (333, 'TOCA', 221, true, 15814, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (334, 'TOGÜÍ', 221, true, 15816, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (335, 'TÓPAGA', 221, true, 15820, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (336, 'TOTA', 221, true, 15822, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (337, 'TUNUNGUÁ', 221, true, 15832, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (338, 'TURMEQUÉ', 221, true, 15835, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (339, 'TUTA', 221, true, 15837, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (340, 'TUTAZÁ', 221, true, 15839, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (341, 'UMBITA', 221, true, 15842, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (342, 'VENTAQUEMADA', 221, true, 15861, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (343, 'VIRACACHÁ', 221, true, 15879, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (344, 'ZETAQUIRA', 221, true, 15897, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (345, 'CALDAS', 1, true, 17, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (346, 'MANIZALES', 345, true, 17001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (347, 'AGUADAS', 345, true, 17013, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (348, 'ANSERMA', 345, true, 17042, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (349, 'ARANZAZU', 345, true, 17050, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (350, 'BELALCÁZAR', 345, true, 17088, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (351, 'CHINCHINÁ', 345, true, 17174, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (352, 'FILADELFIA', 345, true, 17272, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (353, 'LA DORADA', 345, true, 17380, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (354, 'LA MERCED', 345, true, 17388, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (355, 'MANZANARES', 345, true, 17433, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (356, 'MARMATO', 345, true, 17442, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (357, 'MARQUETALIA', 345, true, 17444, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (358, 'MARULANDA', 345, true, 17446, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (359, 'NEIRA', 345, true, 17486, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (360, 'NORCASIA', 345, true, 17495, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (361, 'PÁCORA', 345, true, 17513, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (362, 'PALESTINA', 345, true, 17524, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (363, 'PENSILVANIA', 345, true, 17541, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (364, 'RIOSUCIO', 345, true, 17614, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (365, 'RISARALDA', 345, true, 17616, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (366, 'SALAMINA', 345, true, 17653, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (367, 'SAMANÁ', 345, true, 17662, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (368, 'SAN JOSÉ', 345, true, 17665, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (369, 'SUPÍA', 345, true, 17777, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (370, 'VICTORIA', 345, true, 17867, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (371, 'VILLAMARÍA', 345, true, 17873, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (372, 'VITERBO', 345, true, 17877, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (373, 'CAQUETA', 1, true, 18, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (374, 'FLORENCIA', 373, true, 18001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (375, 'ALBANIA', 373, true, 18029, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (376, 'BELÉN DE LOS ANDAQUÍES', 373, true, 18094, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (377, 'CARTAGENA DEL CHAIRÁ', 373, true, 18150, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (378, 'CURILLO', 373, true, 18205, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (379, 'EL DONCELLO', 373, true, 18247, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (380, 'EL PAUJIL', 373, true, 18256, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (381, 'LA MONTAÑITA', 373, true, 18410, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (382, 'MILÁN', 373, true, 18460, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (383, 'MORELIA', 373, true, 18479, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (384, 'PUERTO RICO', 373, true, 18592, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (385, 'SAN JOSÉ DEL FRAGUA', 373, true, 18610, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (386, 'SAN VICENTE DEL CAGUÁN', 373, true, 18753, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (387, 'SOLANO', 373, true, 18756, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (388, 'SOLITA', 373, true, 18785, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (389, 'VALPARAÍSO', 373, true, 18860, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (390, 'CASANARE', 1, true, 85, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (391, 'YOPAL', 390, true, 85001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (392, 'AGUAZUL', 390, true, 85010, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (393, 'CHAMEZA', 390, true, 85015, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (394, 'HATO COROZAL', 390, true, 85125, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (395, 'LA SALINA', 390, true, 85136, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (396, 'MANÍ', 390, true, 85139, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (397, 'MONTERREY', 390, true, 85162, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (398, 'NUNCHÍA', 390, true, 85225, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (399, 'OROCUÉ', 390, true, 85230, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (400, 'PAZ DE ARIPORO', 390, true, 85250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (401, 'PORE', 390, true, 85263, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (402, 'RECETOR', 390, true, 85279, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (403, 'SABANALARGA', 390, true, 85300, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (404, 'SÁCAMA', 390, true, 85315, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (405, 'SAN LUIS DE PALENQUE', 390, true, 85325, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (406, 'TÁMARA', 390, true, 85400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (407, 'TAURAMENA', 390, true, 85410, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (408, 'TRINIDAD', 390, true, 85430, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (409, 'VILLANUEVA', 390, true, 85440, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (410, 'CAUCA', 1, true, 19, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (411, 'POPAYÁN', 410, true, 19001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (412, 'ALMAGUER', 410, true, 19022, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (413, 'ARGELIA', 410, true, 19050, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (414, 'BALBOA', 410, true, 19075, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (415, 'BOLÍVAR', 410, true, 19100, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (416, 'BUENOS AIRES', 410, true, 19110, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (417, 'CAJIBÍO', 410, true, 19130, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (418, 'CALDONO', 410, true, 19137, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (419, 'CALOTO', 410, true, 19142, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (420, 'CORINTO', 410, true, 19212, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (421, 'EL TAMBO', 410, true, 19256, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (422, 'FLORENCIA', 410, true, 19290, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (423, 'GUACHENÉ', 410, true, 19300, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (424, 'GUAPI', 410, true, 19318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (425, 'INZÁ', 410, true, 19355, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (426, 'JAMBALÓ', 410, true, 19364, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (427, 'LA SIERRA', 410, true, 19392, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (428, 'LA VEGA', 410, true, 19397, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (429, 'LÓPEZ', 410, true, 19418, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (430, 'MERCADERES', 410, true, 19450, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (431, 'MIRANDA', 410, true, 19455, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (432, 'MORALES', 410, true, 19473, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (433, 'PADILLA', 410, true, 19513, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (434, 'PAEZ', 410, true, 19517, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (435, 'PATÍA', 410, true, 19532, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (436, 'PIAMONTE', 410, true, 19533, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (437, 'PIENDAMÓ', 410, true, 19548, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (438, 'PUERTO TEJADA', 410, true, 19573, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (439, 'PURACÉ', 410, true, 19585, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (440, 'ROSAS', 410, true, 19622, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (441, 'SAN SEBASTIÁN', 410, true, 19693, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (442, 'SANTANDER DE QUILICHAO', 410, true, 19698, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (443, 'SANTA ROSA', 410, true, 19701, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (444, 'SILVIA', 410, true, 19743, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (445, 'SOTARA', 410, true, 19760, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (446, 'SUÁREZ', 410, true, 19780, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (447, 'SUCRE', 410, true, 19785, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (448, 'TIMBÍO', 410, true, 19807, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (449, 'TIMBIQUÍ', 410, true, 19809, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (450, 'TORIBIO', 410, true, 19821, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (451, 'TOTORÓ', 410, true, 19824, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (452, 'VILLA RICA', 410, true, 19845, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (453, 'CESAR', 410, true, 20, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (454, 'VALLEDUPAR', 410, true, 20001, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (455, 'AGUACHICA', 410, true, 20011, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (456, 'AGUSTÍN CODAZZI', 410, true, 20013, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (457, 'ASTREA', 410, true, 20032, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (458, 'BECERRIL', 410, true, 20045, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (459, 'BOSCONIA', 410, true, 20060, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (460, 'CHIMICHAGUA', 410, true, 20175, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (461, 'CHIRIGUANÁ', 410, true, 20178, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (462, 'CURUMANÍ', 410, true, 20228, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (463, 'EL COPEY', 410, true, 20238, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (464, 'EL PASO', 410, true, 20250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (465, 'GAMARRA', 410, true, 20295, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (466, 'GONZÁLEZ', 410, true, 20310, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (467, 'LA GLORIA', 410, true, 20383, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (468, 'LA JAGUA DE IBIRICO', 410, true, 20400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (469, 'MANAURE', 410, true, 20443, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (470, 'PAILITAS', 410, true, 20517, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (471, 'PELAYA', 410, true, 20550, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (472, 'PUEBLO BELLO', 410, true, 20570, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (473, 'RÍO DE ORO', 410, true, 20614, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (474, 'LA PAZ', 410, true, 20621, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (475, 'SAN ALBERTO', 410, true, 20710, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (476, 'SAN DIEGO', 410, true, 20750, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (477, 'SAN MARTÍN', 410, true, 20770, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (478, 'TAMALAMEQUE', 410, true, 20787, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (479, 'CHOCO', 1, true, 27, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (480, 'QUIBDÓ', 479, true, 27001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (481, 'ACANDÍ', 479, true, 27006, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (482, 'ALTO BAUDÓ', 479, true, 27025, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (483, 'ATRATO', 479, true, 27050, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (484, 'BAGADÓ', 479, true, 27073, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (485, 'BAHÍA SOLANO', 479, true, 27075, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (486, 'BAJO BAUDÓ', 479, true, 27077, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (487, 'BOJAYA', 479, true, 27099, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (488, 'EL CANTÓN DEL SAN PABLO', 479, true, 27135, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (489, 'CARMEN DEL DARIÉN', 479, true, 27150, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (490, 'CÉRTEGUI', 479, true, 27160, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (491, 'CONDOTO', 479, true, 27205, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (492, 'EL CARMEN DE ATRATO', 479, true, 27245, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (493, 'EL LITORAL DEL SAN JUAN', 479, true, 27250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (494, 'ISTMINA', 479, true, 27361, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (495, 'JURADÓ', 479, true, 27372, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (496, 'LLORÓ', 479, true, 27413, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (497, 'MEDIO ATRATO', 479, true, 27425, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (498, 'MEDIO BAUDÓ', 479, true, 27430, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (499, 'MEDIO SAN JUAN', 479, true, 27450, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (500, 'NÓVITA', 479, true, 27491, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (501, 'NUQUÍ', 479, true, 27495, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (502, 'RÍO IRÓ', 479, true, 27580, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (503, 'RÍO QUITO', 479, true, 27600, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (504, 'RIOSUCIO', 479, true, 27615, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (505, 'SAN JOSÉ DEL PALMAR', 479, true, 27660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (506, 'SIPÍ', 479, true, 27745, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (507, 'TADÓ', 479, true, 27787, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (508, 'UNGUÍA', 479, true, 27800, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (509, 'UNIÓN PANAMERICANA', 479, true, 27810, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (510, 'CORDOBA', 1, true, 23, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (511, 'MONTERÍA', 510, true, 23001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (512, 'AYAPEL', 510, true, 23068, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (513, 'BUENAVISTA', 510, true, 23079, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (514, 'CANALETE', 510, true, 23090, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (515, 'CERETÉ', 510, true, 23162, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (516, 'CHIMÁ', 510, true, 23168, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (517, 'CHINÚ', 510, true, 23182, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (518, 'CIÉNAGA DE ORO', 510, true, 23189, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (519, 'COTORRA', 510, true, 23300, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (520, 'LA APARTADA', 510, true, 23350, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (521, 'LORICA', 510, true, 23417, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (522, 'LOS CÓRDOBAS', 510, true, 23419, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (523, 'MOMIL', 510, true, 23464, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (524, 'MONTELÍBANO', 510, true, 23466, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (525, 'MOÑITOS', 510, true, 23500, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (526, 'PLANETA RICA', 510, true, 23555, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (527, 'PUEBLO NUEVO', 510, true, 23570, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (528, 'PUERTO ESCONDIDO', 510, true, 23574, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (529, 'PUERTO LIBERTADOR', 510, true, 23580, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (530, 'PURÍSIMA', 510, true, 23586, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (531, 'SAHAGÚN', 510, true, 23660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (532, 'SAN ANDRÉS SOTAVENTO', 510, true, 23670, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (533, 'SAN ANTERO', 510, true, 23672, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (534, 'SAN BERNARDO DEL VIENTO', 510, true, 23675, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (535, 'SAN CARLOS', 510, true, 23678, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (536, 'SAN JOSÉ DE URÉ', 510, true, 23682, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (537, 'SAN PELAYO', 510, true, 23686, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (538, 'TIERRALTA', 510, true, 23807, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (539, 'TUCHÍN', 510, true, 23815, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (540, 'VALENCIA', 510, true, 23855, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (541, 'CUNDINAMARCA', 1, true, 25, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (542, 'AGUA DE DIOS', 541, true, 25001, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (543, 'ALBÁN', 541, true, 25019, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (544, 'ANAPOIMA', 541, true, 25035, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (545, 'ANOLAIMA', 541, true, 25040, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (546, 'ARBELÁEZ', 541, true, 25053, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (547, 'BELTRÁN', 541, true, 25086, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (548, 'BITUIMA', 541, true, 25095, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (549, 'BOJACÁ', 541, true, 25099, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (550, 'CABRERA', 541, true, 25120, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (551, 'CACHIPAY', 541, true, 25123, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (552, 'CAJICÁ', 541, true, 25126, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (553, 'CAPARRAPÍ', 541, true, 25148, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (554, 'CAQUEZA', 541, true, 25151, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (555, 'CARMEN DE CARUPA', 541, true, 25154, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (556, 'CHAGUANÍ', 541, true, 25168, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (557, 'CHÍA', 541, true, 25175, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (558, 'CHIPAQUE', 541, true, 25178, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (559, 'CHOACHÍ', 541, true, 25181, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (560, 'CHOCONTÁ', 541, true, 25183, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (561, 'COGUA', 541, true, 25200, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (562, 'COTA', 541, true, 25214, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (563, 'CUCUNUBÁ', 541, true, 25224, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (564, 'EL COLEGIO', 541, true, 25245, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (565, 'EL PEÑÓN', 541, true, 25258, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (566, 'EL ROSAL', 541, true, 25260, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (567, 'FACATATIVÁ', 541, true, 25269, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (568, 'FOMEQUE', 541, true, 25279, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (569, 'FOSCA', 541, true, 25281, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (570, 'FUNZA', 541, true, 25286, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (571, 'FÚQUENE', 541, true, 25288, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (572, 'FUSAGASUGÁ', 541, true, 25290, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (573, 'GACHALA', 541, true, 25293, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (574, 'GACHANCIPÁ', 541, true, 25295, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (575, 'GACHETÁ', 541, true, 25297, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (576, 'GAMA', 541, true, 25299, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (577, 'GIRARDOT', 541, true, 25307, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (578, 'GRANADA', 541, true, 25312, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (579, 'GUACHETÁ', 541, true, 25317, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (580, 'GUADUAS', 541, true, 25320, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (581, 'GUASCA', 541, true, 25322, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (582, 'GUATAQUÍ', 541, true, 25324, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (583, 'GUATAVITA', 541, true, 25326, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (584, 'GUAYABAL DE SIQUIMA', 541, true, 25328, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (585, 'GUAYABETAL', 541, true, 25335, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (586, 'GUTIÉRREZ', 541, true, 25339, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (587, 'JERUSALÉN', 541, true, 25368, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (588, 'JUNÍN', 541, true, 25372, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (589, 'LA CALERA', 541, true, 25377, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (590, 'LA MESA', 541, true, 25386, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (591, 'LA PALMA', 541, true, 25394, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (592, 'LA PEÑA', 541, true, 25398, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (593, 'LA VEGA', 541, true, 25402, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (594, 'LENGUAZAQUE', 541, true, 25407, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (595, 'MACHETA', 541, true, 25426, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (596, 'MADRID', 541, true, 25430, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (597, 'MANTA', 541, true, 25436, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (598, 'MEDINA', 541, true, 25438, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (599, 'MOSQUERA', 541, true, 25473, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (600, 'NARIÑO', 541, true, 25483, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (601, 'NEMOCÓN', 541, true, 25486, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (602, 'NILO', 541, true, 25488, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (603, 'NIMAIMA', 541, true, 25489, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (604, 'NOCAIMA', 541, true, 25491, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (605, 'VENECIA', 541, true, 25506, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (606, 'PACHO', 541, true, 25513, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (607, 'PAIME', 541, true, 25518, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (608, 'PANDI', 541, true, 25524, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (609, 'PARATEBUENO', 541, true, 25530, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (610, 'PASCA', 541, true, 25535, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (611, 'PUERTO SALGAR', 541, true, 25572, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (612, 'PULÍ', 541, true, 25580, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (613, 'QUEBRADANEGRA', 541, true, 25592, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (614, 'QUETAME', 541, true, 25594, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (615, 'QUIPILE', 541, true, 25596, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (616, 'APULO', 541, true, 25599, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (617, 'RICAURTE', 541, true, 25612, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (618, 'SAN ANTONIO DEL TEQUENDAMA', 541, true, 25645, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (619, 'SAN BERNARDO', 541, true, 25649, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (620, 'SAN CAYETANO', 541, true, 25653, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (621, 'SAN FRANCISCO', 541, true, 25658, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (622, 'SAN JUAN DE RÍO SECO', 541, true, 25662, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (623, 'SASAIMA', 541, true, 25718, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (624, 'SESQUILÉ', 541, true, 25736, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (625, 'SIBATÉ', 541, true, 25740, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (626, 'SILVANIA', 541, true, 25743, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (627, 'SIMIJACA', 541, true, 25745, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (628, 'SOACHA', 541, true, 25754, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (629, 'SOPÓ', 541, true, 25758, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (630, 'SUBACHOQUE', 541, true, 25769, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (631, 'SUESCA', 541, true, 25772, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (632, 'SUPATÁ', 541, true, 25777, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (633, 'SUSA', 541, true, 25779, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (634, 'SUTATAUSA', 541, true, 25781, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (635, 'TABIO', 541, true, 25785, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (636, 'TAUSA', 541, true, 25793, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (637, 'TENA', 541, true, 25797, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (638, 'TENJO', 541, true, 25799, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (639, 'TIBACUY', 541, true, 25805, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (640, 'TIBIRITA', 541, true, 25807, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (641, 'TOCAIMA', 541, true, 25815, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (642, 'TOCANCIPÁ', 541, true, 25817, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (643, 'TOPAIPÍ', 541, true, 25823, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (644, 'UBALÁ', 541, true, 25839, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (645, 'UBAQUE', 541, true, 25841, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (646, 'VILLA DE SAN DIEGO DE UBATE', 541, true, 25843, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (647, 'UNE', 541, true, 25845, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (648, 'ÚTICA', 541, true, 25851, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (649, 'VERGARA', 541, true, 25862, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (650, 'VIANÍ', 541, true, 25867, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (651, 'VILLAGÓMEZ', 541, true, 25871, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (652, 'VILLAPINZÓN', 541, true, 25873, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (653, 'VILLETA', 541, true, 25875, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (654, 'VIOTÁ', 541, true, 25878, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (655, 'YACOPÍ', 541, true, 25885, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (656, 'ZIPACÓN', 541, true, 25898, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (657, 'ZIPAQUIRÁ', 541, true, 25899, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (658, 'GUAINÍA', 1, true, 94, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (659, 'INÍRIDA', 658, true, 94001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (660, 'BARRANCO MINAS', 658, true, 94343, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (661, 'MAPIRIPANA', 658, true, 94663, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (662, 'SAN FELIPE', 658, true, 94883, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (663, 'PUERTO COLOMBIA', 658, true, 94884, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (664, 'LA GUADALUPE', 658, true, 94885, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (665, 'CACAHUAL', 658, true, 94886, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (666, 'PANA PANA', 658, true, 94887, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (667, 'MORICHAL', 658, true, 94888, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (668, 'GUAVIARE', 1, true, 95, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (669, 'SAN JOSÉ DEL GUAVIARE', 668, true, 95001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (670, 'CALAMAR', 668, true, 95015, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (671, 'EL RETORNO', 668, true, 95025, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (672, 'MIRAFLORES', 668, true, 95200, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (673, 'HUILA', 1, true, 41, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (674, 'NEIVA', 673, true, 41001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (675, 'ACEVEDO', 673, true, 41006, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (676, 'AGRADO', 673, true, 41013, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (677, 'AIPE', 673, true, 41016, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (678, 'ALGECIRAS', 673, true, 41020, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (679, 'ALTAMIRA', 673, true, 41026, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (680, 'BARAYA', 673, true, 41078, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (681, 'CAMPOALEGRE', 673, true, 41132, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (682, 'COLOMBIA', 673, true, 41206, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (683, 'ELÍAS', 673, true, 41244, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (684, 'GARZÓN', 673, true, 41298, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (685, 'GIGANTE', 673, true, 41306, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (686, 'GUADALUPE', 673, true, 41319, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (687, 'HOBO', 673, true, 41349, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (688, 'IQUIRA', 673, true, 41357, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (689, 'ISNOS', 673, true, 41359, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (690, 'LA ARGENTINA', 673, true, 41378, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (691, 'LA PLATA', 673, true, 41396, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (692, 'NÁTAGA', 673, true, 41483, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (693, 'OPORAPA', 673, true, 41503, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (694, 'PAICOL', 673, true, 41518, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (695, 'PALERMO', 673, true, 41524, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (696, 'PALESTINA', 673, true, 41530, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (697, 'PITAL', 673, true, 41548, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (698, 'PITALITO', 673, true, 41551, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (699, 'RIVERA', 673, true, 41615, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (700, 'SALADOBLANCO', 673, true, 41660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (701, 'SAN AGUSTÍN', 673, true, 41668, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (702, 'SANTA MARÍA', 673, true, 41676, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (703, 'SUAZA', 673, true, 41770, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (704, 'TARQUI', 673, true, 41791, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (705, 'TESALIA', 673, true, 41797, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (706, 'TELLO', 673, true, 41799, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (707, 'TERUEL', 673, true, 41801, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (708, 'TIMANÁ', 673, true, 41807, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (709, 'VILLAVIEJA', 673, true, 41872, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (710, 'YAGUARÁ', 673, true, 41885, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (711, 'LA GUAJIRA', 1, true, 44, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (712, 'RIOHACHA', 711, true, 44001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (713, 'ALBANIA', 711, true, 44035, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (714, 'BARRANCAS', 711, true, 44078, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (715, 'DIBULLA', 711, true, 44090, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (716, 'DISTRACCIÓN', 711, true, 44098, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (717, 'EL MOLINO', 711, true, 44110, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (718, 'FONSECA', 711, true, 44279, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (719, 'HATONUEVO', 711, true, 44378, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (720, 'LA JAGUA DEL PILAR', 711, true, 44420, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (721, 'MAICAO', 711, true, 44430, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (722, 'MANAURE', 711, true, 44560, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (723, 'SAN JUAN DEL CESAR', 711, true, 44650, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (724, 'URIBIA', 711, true, 44847, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (725, 'URUMITA', 711, true, 44855, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (726, 'VILLANUEVA', 711, true, 44874, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (727, 'MAGDALENA', 1, true, 47, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (728, 'SANTA MARTA', 727, true, 47001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (729, 'ALGARROBO', 727, true, 47030, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (730, 'ARACATACA', 727, true, 47053, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (731, 'ARIGUANÍ', 727, true, 47058, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (732, 'CERRO SAN ANTONIO', 727, true, 47161, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (733, 'CHIVOLO', 727, true, 47170, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (734, 'CIÉNAGA', 727, true, 47189, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (735, 'CONCORDIA', 727, true, 47205, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (736, 'EL BANCO', 727, true, 47245, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (737, 'EL PIÑON', 727, true, 47258, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (738, 'EL RETÉN', 727, true, 47268, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (739, 'FUNDACIÓN', 727, true, 47288, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (740, 'GUAMAL', 727, true, 47318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (741, 'NUEVA GRANADA', 727, true, 47460, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (742, 'PEDRAZA', 727, true, 47541, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (743, 'PIJIÑO DEL CARMEN', 727, true, 47545, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (744, 'PIVIJAY', 727, true, 47551, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (745, 'PLATO', 727, true, 47555, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (746, 'PUEBLOVIEJO', 727, true, 47570, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (747, 'REMOLINO', 727, true, 47605, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (748, 'SABANAS DE SAN ANGEL', 727, true, 47660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (749, 'SALAMINA', 727, true, 47675, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (750, 'SAN SEBASTIÁN DE BUENAVISTA', 727, true, 47692, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (751, 'SAN ZENÓN', 727, true, 47703, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (752, 'SANTA ANA', 727, true, 47707, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (753, 'SANTA BÁRBARA DE PINTO', 727, true, 47720, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (754, 'SITIONUEVO', 727, true, 47745, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (755, 'TENERIFE', 727, true, 47798, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (756, 'ZAPAYÁN', 727, true, 47960, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (757, 'ZONA BANANERA', 727, true, 47980, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (758, 'META', 1, true, 50, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (759, 'VILLAVICENCIO', 758, true, 50001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (760, 'ACACÍAS', 758, true, 50006, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (761, 'BARRANCA DE UPÍA', 758, true, 50110, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (762, 'CABUYARO', 758, true, 50124, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (763, 'CASTILLA LA NUEVA', 758, true, 50150, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (764, 'CUBARRAL', 758, true, 50223, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (765, 'CUMARAL', 758, true, 50226, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (766, 'EL CALVARIO', 758, true, 50245, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (767, 'EL CASTILLO', 758, true, 50251, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (768, 'EL DORADO', 758, true, 50270, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (769, 'FUENTE DE ORO', 758, true, 50287, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (770, 'GRANADA', 758, true, 50313, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (771, 'GUAMAL', 758, true, 50318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (772, 'MAPIRIPÁN', 758, true, 50325, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (773, 'MESETAS', 758, true, 50330, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (774, 'LA MACARENA', 758, true, 50350, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (775, 'URIBE', 758, true, 50370, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (776, 'LEJANÍAS', 758, true, 50400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (777, 'PUERTO CONCORDIA', 758, true, 50450, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (778, 'PUERTO GAITÁN', 758, true, 50568, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (779, 'PUERTO LÓPEZ', 758, true, 50573, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (780, 'PUERTO LLERAS', 758, true, 50577, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (781, 'PUERTO RICO', 758, true, 50590, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (782, 'RESTREPO', 758, true, 50606, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (783, 'SAN CARLOS DE GUAROA', 758, true, 50680, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (784, 'SAN JUAN DE ARAMA', 758, true, 50683, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (785, 'SAN JUANITO', 758, true, 50686, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (786, 'SAN MARTÍN', 758, true, 50689, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (787, 'VISTAHERMOSA', 758, true, 50711, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (788, 'NARIÑO', 1, true, 52, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (789, 'PASTO', 788, true, 52001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (790, 'ALBÁN', 788, true, 52019, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (791, 'ALDANA', 788, true, 52022, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (792, 'ANCUYÁ', 788, true, 52036, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (793, 'ARBOLEDA', 788, true, 52051, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (794, 'BARBACOAS', 788, true, 52079, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (795, 'BELÉN', 788, true, 52083, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (796, 'BUESACO', 788, true, 52110, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (797, 'COLÓN', 788, true, 52203, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (798, 'CONSACA', 788, true, 52207, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (799, 'CONTADERO', 788, true, 52210, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (800, 'CÓRDOBA', 788, true, 52215, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (801, 'CUASPUD', 788, true, 52224, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (802, 'CUMBAL', 788, true, 52227, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (803, 'CUMBITARA', 788, true, 52233, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (804, 'CHACHAGÜÍ', 788, true, 52240, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (805, 'EL CHARCO', 788, true, 52250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (806, 'EL PEÑOL', 788, true, 52254, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (807, 'EL ROSARIO', 788, true, 52256, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (808, 'EL TABLÓN DE GÓMEZ', 788, true, 52258, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (809, 'EL TAMBO', 788, true, 52260, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (810, 'FUNES', 788, true, 52287, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (811, 'GUACHUCAL', 788, true, 52317, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (812, 'GUAITARILLA', 788, true, 52320, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (813, 'GUALMATÁN', 788, true, 52323, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (814, 'ILES', 788, true, 52352, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (815, 'IMUÉS', 788, true, 52354, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (816, 'IPIALES', 788, true, 52356, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (817, 'LA CRUZ', 788, true, 52378, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (818, 'LA FLORIDA', 788, true, 52381, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (819, 'LA LLANADA', 788, true, 52385, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (820, 'LA TOLA', 788, true, 52390, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (821, 'LA UNIÓN', 788, true, 52399, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (822, 'LEIVA', 788, true, 52405, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (823, 'LINARES', 788, true, 52411, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (824, 'LOS ANDES', 788, true, 52418, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (825, 'MAGÜI', 788, true, 52427, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (826, 'MALLAMA', 788, true, 52435, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (827, 'MOSQUERA', 788, true, 52473, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (828, 'NARIÑO', 788, true, 52480, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (829, 'OLAYA HERRERA', 788, true, 52490, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (830, 'OSPINA', 788, true, 52506, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (831, 'FRANCISCO PIZARRO', 788, true, 52520, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (832, 'POLICARPA', 788, true, 52540, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (833, 'POTOSÍ', 788, true, 52560, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (834, 'PROVIDENCIA', 788, true, 52565, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (835, 'PUERRES', 788, true, 52573, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (836, 'PUPIALES', 788, true, 52585, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (837, 'RICAURTE', 788, true, 52612, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (838, 'ROBERTO PAYÁN', 788, true, 52621, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (839, 'SAMANIEGO', 788, true, 52678, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (840, 'SANDONÁ', 788, true, 52683, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (841, 'SAN BERNARDO', 788, true, 52685, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (842, 'SAN LORENZO', 788, true, 52687, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (843, 'SAN PABLO', 788, true, 52693, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (844, 'SAN PEDRO DE CARTAGO', 788, true, 52694, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (845, 'SANTA BÁRBARA', 788, true, 52696, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (846, 'SANTACRUZ', 788, true, 52699, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (847, 'SAPUYES', 788, true, 52720, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (848, 'TAMINANGO', 788, true, 52786, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (849, 'TANGUA', 788, true, 52788, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (850, 'SAN ANDRES DE TUMACO', 788, true, 52835, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (851, 'TÚQUERRES', 788, true, 52838, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (852, 'YACUANQUER', 788, true, 52885, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (853, 'NORTE DE SANTANDER', 1, true, 54, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (854, 'CÚCUTA', 853, true, 54001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (855, 'ABREGO', 853, true, 54003, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (856, 'ARBOLEDAS', 853, true, 54051, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (857, 'BOCHALEMA', 853, true, 54099, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (858, 'BUCARASICA', 853, true, 54109, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (859, 'CÁCOTA', 853, true, 54125, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (860, 'CACHIRÁ', 853, true, 54128, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (861, 'CHINÁCOTA', 853, true, 54172, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (862, 'CHITAGÁ', 853, true, 54174, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (863, 'CONVENCIÓN', 853, true, 54206, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (864, 'CUCUTILLA', 853, true, 54223, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (865, 'DURANIA', 853, true, 54239, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (866, 'EL CARMEN', 853, true, 54245, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (867, 'EL TARRA', 853, true, 54250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (868, 'EL ZULIA', 853, true, 54261, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (869, 'GRAMALOTE', 853, true, 54313, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (870, 'HACARÍ', 853, true, 54344, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (871, 'HERRÁN', 853, true, 54347, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (872, 'LABATECA', 853, true, 54377, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (873, 'LA ESPERANZA', 853, true, 54385, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (874, 'LA PLAYA', 853, true, 54398, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (875, 'LOS PATIOS', 853, true, 54405, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (876, 'LOURDES', 853, true, 54418, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (877, 'MUTISCUA', 853, true, 54480, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (878, 'OCAÑA', 853, true, 54498, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (879, 'PAMPLONA', 853, true, 54518, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (880, 'PAMPLONITA', 853, true, 54520, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (881, 'PUERTO SANTANDER', 853, true, 54553, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (882, 'RAGONVALIA', 853, true, 54599, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (883, 'SALAZAR', 853, true, 54660, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (884, 'SAN CALIXTO', 853, true, 54670, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (885, 'SAN CAYETANO', 853, true, 54673, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (886, 'SANTIAGO', 853, true, 54680, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (887, 'SARDINATA', 853, true, 54720, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (888, 'SILOS', 853, true, 54743, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (889, 'TEORAMA', 853, true, 54800, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (890, 'TIBÚ', 853, true, 54810, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (891, 'TOLEDO', 853, true, 54820, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (892, 'VILLA CARO', 853, true, 54871, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (893, 'VILLA DEL ROSARIO', 853, true, 54874, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (894, 'PUTUMAYO', 1, true, 86, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (895, 'MOCOA', 894, true, 86001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (896, 'COLÓN', 894, true, 86219, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (897, 'ORITO', 894, true, 86320, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (898, 'PUERTO ASÍS', 894, true, 86568, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (899, 'PUERTO CAICEDO', 894, true, 86569, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (900, 'PUERTO GUZMÁN', 894, true, 86571, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (901, 'PUERTO LEGUÍZAMO', 894, true, 86573, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (902, 'SIBUNDOY', 894, true, 86749, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (903, 'SAN FRANCISCO', 894, true, 86755, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (904, 'SAN MIGUEL', 894, true, 86757, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (905, 'SANTIAGO', 894, true, 86760, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (906, 'VALLE DEL GUAMUEZ', 894, true, 86865, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (907, 'VILLAGARZÓN', 894, true, 86885, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (908, 'QUINDIO', 1, true, 63, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (909, 'ARMENIA', 908, true, 63001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (910, 'BUENAVISTA', 908, true, 63111, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (911, 'CALARCA', 908, true, 63130, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (912, 'CIRCASIA', 908, true, 63190, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (913, 'CÓRDOBA', 908, true, 63212, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (914, 'FILANDIA', 908, true, 63272, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (915, 'GÉNOVA', 908, true, 63302, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (916, 'LA TEBAIDA', 908, true, 63401, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (917, 'MONTENEGRO', 908, true, 63470, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (918, 'PIJAO', 908, true, 63548, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (919, 'QUIMBAYA', 908, true, 63594, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (920, 'SALENTO', 908, true, 63690, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (921, 'RISARALDA', 1, true, 66, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (922, 'PEREIRA', 921, true, 66001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (923, 'APÍA', 921, true, 66045, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (924, 'BALBOA', 921, true, 66075, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (925, 'BELÉN DE UMBRÍA', 921, true, 66088, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (926, 'DOSQUEBRADAS', 921, true, 66170, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (927, 'GUÁTICA', 921, true, 66318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (928, 'LA CELIA', 921, true, 66383, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (929, 'LA VIRGINIA', 921, true, 66400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (930, 'MARSELLA', 921, true, 66440, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (931, 'MISTRATÓ', 921, true, 66456, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (932, 'PUEBLO RICO', 921, true, 66572, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (933, 'QUINCHÍA', 921, true, 66594, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (934, 'SANTA ROSA DE CABAL', 921, true, 66682, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (935, 'SANTUARIO', 921, true, 66687, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (936, 'SAN ANDRÉS', 1, true, 88, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (937, 'SAN ANDRÉS', 936, true, 88001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (938, 'PROVIDENCIA', 936, true, 88564, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (939, 'SANTANDER', 1, true, 68, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (940, 'BUCARAMANGA', 939, true, 68001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (941, 'AGUADA', 939, true, 68013, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (942, 'ALBANIA', 939, true, 68020, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (943, 'ARATOCA', 939, true, 68051, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (944, 'BARBOSA', 939, true, 68077, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (945, 'BARICHARA', 939, true, 68079, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (946, 'BARRANCABERMEJA', 939, true, 68081, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (947, 'BETULIA', 939, true, 68092, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (948, 'BOLÍVAR', 939, true, 68101, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (949, 'CABRERA', 939, true, 68121, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (950, 'CALIFORNIA', 939, true, 68132, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (951, 'CAPITANEJO', 939, true, 68147, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (952, 'CARCASÍ', 939, true, 68152, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (953, 'CEPITÁ', 939, true, 68160, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (954, 'CERRITO', 939, true, 68162, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (955, 'CHARALÁ', 939, true, 68167, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (956, 'CHARTA', 939, true, 68169, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (957, 'CHIMA', 939, true, 68176, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (958, 'CHIPATÁ', 939, true, 68179, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (959, 'CIMITARRA', 939, true, 68190, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (960, 'CONCEPCIÓN', 939, true, 68207, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (961, 'CONFINES', 939, true, 68209, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (962, 'CONTRATACIÓN', 939, true, 68211, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (963, 'COROMORO', 939, true, 68217, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (964, 'CURITÍ', 939, true, 68229, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (965, 'EL CARMEN DE CHUCURÍ', 939, true, 68235, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (966, 'EL GUACAMAYO', 939, true, 68245, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (967, 'EL PEÑÓN', 939, true, 68250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (968, 'EL PLAYÓN', 939, true, 68255, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (969, 'ENCINO', 939, true, 68264, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (970, 'ENCISO', 939, true, 68266, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (971, 'FLORIÁN', 939, true, 68271, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (972, 'FLORIDABLANCA', 939, true, 68276, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (973, 'GALÁN', 939, true, 68296, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (974, 'GAMBITA', 939, true, 68298, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (975, 'GIRÓN', 939, true, 68307, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (976, 'GUACA', 939, true, 68318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (977, 'GUADALUPE', 939, true, 68320, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (978, 'GUAPOTÁ', 939, true, 68322, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (979, 'GUAVATÁ', 939, true, 68324, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (980, 'GÜEPSA', 939, true, 68327, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (981, 'HATO', 939, true, 68344, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (982, 'JESÚS MARÍA', 939, true, 68368, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (983, 'JORDÁN', 939, true, 68370, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (984, 'LA BELLEZA', 939, true, 68377, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (985, 'LANDÁZURI', 939, true, 68385, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (986, 'LA PAZ', 939, true, 68397, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (987, 'LEBRIJA', 939, true, 68406, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (988, 'LOS SANTOS', 939, true, 68418, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (989, 'MACARAVITA', 939, true, 68425, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (990, 'MÁLAGA', 939, true, 68432, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (991, 'MATANZA', 939, true, 68444, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (992, 'MOGOTES', 939, true, 68464, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (993, 'MOLAGAVITA', 939, true, 68468, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (994, 'OCAMONTE', 939, true, 68498, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (995, 'OIBA', 939, true, 68500, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (996, 'ONZAGA', 939, true, 68502, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (997, 'PALMAR', 939, true, 68522, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (998, 'PALMAS DEL SOCORRO', 939, true, 68524, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (999, 'PÁRAMO', 939, true, 68533, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1000, 'PIEDECUESTA', 939, true, 68547, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1001, 'PINCHOTE', 939, true, 68549, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1002, 'PUENTE NACIONAL', 939, true, 68572, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1003, 'PUERTO PARRA', 939, true, 68573, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1004, 'PUERTO WILCHES', 939, true, 68575, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1005, 'RIONEGRO', 939, true, 68615, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1006, 'SABANA DE TORRES', 939, true, 68655, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1007, 'SAN ANDRÉS', 939, true, 68669, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1008, 'SAN BENITO', 939, true, 68673, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1009, 'SAN GIL', 939, true, 68679, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1010, 'SAN JOAQUÍN', 939, true, 68682, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1011, 'SAN JOSÉ DE MIRANDA', 939, true, 68684, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1012, 'SAN MIGUEL', 939, true, 68686, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1013, 'SAN VICENTE DE CHUCURÍ', 939, true, 68689, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1014, 'SANTA BÁRBARA', 939, true, 68705, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1015, 'SANTA HELENA DEL OPÓN', 939, true, 68720, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1016, 'SIMACOTA', 939, true, 68745, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1017, 'SOCORRO', 939, true, 68755, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1018, 'SUAITA', 939, true, 68770, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1019, 'SUCRE', 939, true, 68773, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1020, 'SURATÁ', 939, true, 68780, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1021, 'TONA', 939, true, 68820, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1022, 'VALLE DE SAN JOSÉ', 939, true, 68855, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1023, 'VÉLEZ', 939, true, 68861, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1024, 'VETAS', 939, true, 68867, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1025, 'VILLANUEVA', 939, true, 68872, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1026, 'ZAPATOCA', 939, true, 68895, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1027, 'SUCRE', 1, true, 70, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1028, 'SINCELEJO', 1027, true, 70001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1029, 'BUENAVISTA', 1027, true, 70110, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1030, 'CAIMITO', 1027, true, 70124, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1031, 'COLOSO', 1027, true, 70204, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1032, 'COROZAL', 1027, true, 70215, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1033, 'COVEÑAS', 1027, true, 70221, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1034, 'CHALÁN', 1027, true, 70230, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1035, 'EL ROBLE', 1027, true, 70233, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1036, 'GALERAS', 1027, true, 70235, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1037, 'GUARANDA', 1027, true, 70265, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1038, 'LA UNIÓN', 1027, true, 70400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1039, 'LOS PALMITOS', 1027, true, 70418, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1040, 'MAJAGUAL', 1027, true, 70429, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1041, 'MORROA', 1027, true, 70473, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1042, 'OVEJAS', 1027, true, 70508, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1043, 'PALMITO', 1027, true, 70523, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1044, 'SAMPUÉS', 1027, true, 70670, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1045, 'SAN BENITO ABAD', 1027, true, 70678, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1046, 'SAN JUAN DE BETULIA', 1027, true, 70702, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1047, 'SAN MARCOS', 1027, true, 70708, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1048, 'SAN ONOFRE', 1027, true, 70713, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1049, 'SAN PEDRO', 1027, true, 70717, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1050, 'SAN LUIS DE SINCÉ', 1027, true, 70742, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1051, 'SUCRE', 1027, true, 70771, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1052, 'SANTIAGO DE TOLÚ', 1027, true, 70820, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1053, 'TOLÚ VIEJO', 1027, true, 70823, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1054, 'TOLIMA', 1, true, 73000, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1055, 'IBAGUÉ', 1054, true, 73001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1056, 'ALPUJARRA', 1054, true, 73024, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1057, 'ALVARADO', 1054, true, 73026, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1058, 'AMBALEMA', 1054, true, 73030, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1059, 'ANZOÁTEGUI', 1054, true, 73043, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1060, 'ARMERO', 1054, true, 73055, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1061, 'ATACO', 1054, true, 73067, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1062, 'CAJAMARCA', 1054, true, 73124, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1063, 'CARMEN DE APICALÁ', 1054, true, 73148, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1064, 'CASABIANCA', 1054, true, 73152, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1065, 'CHAPARRAL', 1054, true, 73168, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1066, 'COELLO', 1054, true, 73200, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1067, 'COYAIMA', 1054, true, 73217, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1068, 'CUNDAY', 1054, true, 73226, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1069, 'DOLORES', 1054, true, 73236, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1070, 'ESPINAL', 1054, true, 73268, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1071, 'FALAN', 1054, true, 73270, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1072, 'FLANDES', 1054, true, 73275, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1073, 'FRESNO', 1054, true, 73283, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1074, 'GUAMO', 1054, true, 73319, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1075, 'HERVEO', 1054, true, 73347, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1076, 'HONDA', 1054, true, 73349, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1077, 'ICONONZO', 1054, true, 73352, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1078, 'LÉRIDA', 1054, true, 73408, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1079, 'LÍBANO', 1054, true, 73411, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1080, 'SAN SEBASTIÁN DE MARIQUITA', 1054, true, 73443, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1081, 'MELGAR', 1054, true, 73449, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1082, 'MURILLO', 1054, true, 73461, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1083, 'NATAGAIMA', 1054, true, 73483, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1084, 'ORTEGA', 1054, true, 73504, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1085, 'PALOCABILDO', 1054, true, 73520, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1086, 'PIEDRAS', 1054, true, 73547, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1087, 'PLANADAS', 1054, true, 73555, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1088, 'PRADO', 1054, true, 73563, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1089, 'PURIFICACIÓN', 1054, true, 73585, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1090, 'RIOBLANCO', 1054, true, 73616, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1091, 'RONCESVALLES', 1054, true, 73622, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1092, 'ROVIRA', 1054, true, 73624, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1093, 'SALDAÑA', 1054, true, 73671, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1094, 'SAN ANTONIO', 1054, true, 73675, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1095, 'SAN LUIS', 1054, true, 73678, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1096, 'SANTA ISABEL', 1054, true, 73686, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1097, 'SUÁREZ', 1054, true, 73770, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1098, 'VALLE DE SAN JUAN', 1054, true, 73854, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1099, 'VENADILLO', 1054, true, 73861, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1100, 'VILLAHERMOSA', 1054, true, 73870, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1101, 'VILLARRICA', 1054, true, 73873, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1102, 'VALLE', 1, true, 76, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1103, 'CALI', 1102, true, 76001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1104, 'ALCALÁ', 1102, true, 76020, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1105, 'ANDALUCÍA', 1102, true, 76036, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1106, 'ANSERMANUEVO', 1102, true, 76041, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1107, 'ARGELIA', 1102, true, 76054, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1108, 'BOLÍVAR', 1102, true, 76100, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1109, 'BUENAVENTURA', 1102, true, 76109, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1110, 'GUADALAJARA DE BUGA', 1102, true, 76111, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1111, 'BUGALAGRANDE', 1102, true, 76113, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1112, 'CAICEDONIA', 1102, true, 76122, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1113, 'CALIMA', 1102, true, 76126, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1114, 'CANDELARIA', 1102, true, 76130, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1115, 'CARTAGO', 1102, true, 76147, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1116, 'DAGUA', 1102, true, 76233, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1117, 'EL ÁGUILA', 1102, true, 76243, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1118, 'EL CAIRO', 1102, true, 76246, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1119, 'EL CERRITO', 1102, true, 76248, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1120, 'EL DOVIO', 1102, true, 76250, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1121, 'FLORIDA', 1102, true, 76275, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1122, 'GINEBRA', 1102, true, 76306, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1123, 'GUACARÍ', 1102, true, 76318, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1124, 'JAMUNDÍ', 1102, true, 76364, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1125, 'LA CUMBRE', 1102, true, 76377, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1126, 'LA UNIÓN', 1102, true, 76400, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1127, 'LA VICTORIA', 1102, true, 76403, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1128, 'OBANDO', 1102, true, 76497, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1129, 'PALMIRA', 1102, true, 76520, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1130, 'PRADERA', 1102, true, 76563, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1131, 'RESTREPO', 1102, true, 76606, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1132, 'RIOFRÍO', 1102, true, 76616, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1133, 't_rolDANILLO', 1102, true, 76622, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1134, 'SAN PEDRO', 1102, true, 76670, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1135, 'SEVILLA', 1102, true, 76736, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1136, 'TORO', 1102, true, 76823, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1137, 'TRUJILLO', 1102, true, 76828, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1138, 'TULUÁ', 1102, true, 76834, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1139, 'ULLOA', 1102, true, 76845, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1140, 'VERSALLES', 1102, true, 76863, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1141, 'VIJES', 1102, true, 76869, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1142, 'YOTOCO', 1102, true, 76890, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1143, 'YUMBO', 1102, true, 76892, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1144, 'ZARZAL', 1102, true, 76895, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1145, 'VAUPÉS', 1, true, 97, 'DP');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1146, 'MITÚ', 1145, true, 97001, 'MC');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1147, 'CARURU', 1145, true, 97161, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1148, 'PACOA', 1145, true, 97511, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1149, 'TARAIRA', 1145, true, 97666, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1150, 'PAPUNAUA', 1145, true, 97777, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1151, 'YAVARATÉ', 1145, true, 97889, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1152, 'VICHADA', 1145, true, 99, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1153, 'PUERTO CARREÑO', 1145, true, 99001, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1154, 'LA PRIMAVERA', 1145, true, 99524, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1155, 'SANTA ROSALÍA', 1145, true, 99624, 'MN');
INSERT INTO public.t_ubicaciones_geograficas (id_codigo, descripcion, id_unde, vigente, codigo_dane, tipo) VALUES (1156, 'CUMARIBO', 1145, true, 99773, 'MN');



--tabla para formulario de adopcion

	
create table t_formulario(
	id_formulario serial,
	nombre_adoptante character varying(100),
    direccion_adoptante character varying(150),
	id_codigo integer,
    localidad character varying(30),
    telefono integer,
    email character varying(50),
    ocupacion character varying(40),
    estado_civil character varying(10),
	pregunta_mascota_1 character varying(30),
    pregunta_mascota_2 character varying(30),
    pregunta_mascota_3 character varying(30),
    pregunta_mascota_4 BOOLEAN,
	pregunta_familia_1 integer,
    pregunta_familia_2 BOOLEAN,
    pregunta_familia_3 BOOLEAN,
    pregunta_familia_4 BOOLEAN,
    pregunta_familia_5 BOOLEAN,
    pregunta_familia_6 character varying(30),
    pregunta_familia_7 character varying(30),
    pregunta_adpcion_1 character varying(30),
    pregunta_adpcion_2 integer,
    pregunta_adpcion_3 character varying(50),
    pregunta_adpcion_4 BOOLEAN,
    pregunta_adpcion_5 character varying(30),
    pregunta_adpcion_6 integer,
    pregunta_adpcion_7 character varying(30),
    pregunta_adpcion_8 character varying(30),
    pregunta_adpcion_9 character varying(30),
    pregunta_adpcion_10 BOOLEAN,
    pregunta_adpcion_11 BOOLEAN,
    pregunta_adpcion_12 BOOLEAN,
    pregunta_adpcion_13 BOOLEAN,
    pregunta_adpcion_14 BOOLEAN,
    pregunta_adpcion_15 BOOLEAN,
    pregunta_adpcion_16 BOOLEAN,
    pregunta_adpcion_17 character varying(60),
    pregunta_adpcion_18 BOOLEAN,
	terminos BOOLEAN,
	primary key (id_formulario),
	 CONSTRAINT t_formulario_id_codigo_fk FOREIGN KEY (id_codigo)
        REFERENCES public.t_ubicaciones_geograficas (id_codigo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
	
	
	  
 );


alter table t_formulario
  add id integer;

ALTER TABLE t_formulario
   ADD CONSTRAINT fk_t_formulario_t_usuario
   FOREIGN KEY (id) 
   REFERENCES t_usuario(id);
   