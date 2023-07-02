-- paso 1 
CREATE DATABASE prueba_francisco_arce_004;

\ c prueba_francisco_arce_004

--1. Dado el Siguiente Modelo:

-- Tabla Películas con id como PK INTEGER, nombre como VARCHAR(255) y ano como INTEGER
-- y
-- Tabla Tags con id como PK INTEGER y tag como VARCHAR(32)
-- Crea el Modelo (revisa bien cuál es el Tipo de Relación antes de Crearlo), respeta las Claves Primarias (PK), Foráneas y Tipos de Datos
CREATE TABLE "Peliculas"(
    "id" INTEGER,
    "nombre" VARCHAR(255),
    "anno" INTEGER,
    PRIMARY KEY ("id")
);

CREATE TABLE "Tags"(
    "id" INTEGER,
    "tag" VARCHAR(32),
    PRIMARY KEY ("id")
);

CREATE TABLE "PeliculaTag" (
    "pelicula_id" INTEGER,
    "tag_id" INTEGER,
    FOREIGN KEY ("pelicula_id") REFERENCES "Peliculas"("id"),
    FOREIGN KEY ("pelicula_id") REFERENCES "Tags"("id")
);

--2. Inserta 5 Películas (INSERT INTO peliculas) y 5 Tags (INSERT INTO tags), la Primera Película, tiene que tener 3 Tags Asociados, la Segunda Película debe tener Dos Tags Asociados
INSERT INTO "Peliculas"
VALUES (1, 'Terminator', 1990),
       (2, 'Godzilla', 1990),
       (3, 'En Busca de la Felicidad', 2007),
       (4, '8 Mile', 2006),
       (5, 'Avengers Endgame', 2019);

INSERT INTO "Tags"
VALUES (1, 'Clasica y muy buena'),
       (2, 'Pelicula para ver una y otra vez'),
       (3, 'Pelicula realmente inspiradora'),
       (4, 'Gran opcion!'),
       (5, 'La mejor pelicula!');

INSERT INTO "PeliculaTag"
VALUES (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (2, 5);

SELECT "Peliculas"."nombre",
    "Tags"."tag"
FROM "Peliculas"
    INNER JOIN "PeliculaTag" ON "Peliculas"."id" = "PeliculaTag"."pelicula_id"
    INNER JOIN "Tags" ON "PeliculaTag"."tag_id" = "Tags"."id";

-- 3. Cuenta la cantidad de Tags (COUNT) que tiene cada Película. Si una Película no tiene tags, debe mostrar 0:
SELECT "Peliculas".nombre,
    COUNT("PeliculaTag"."tag_id") AS numerodetagsdecadapelicula
FROM "Peliculas"
    LEFT JOIN "PeliculaTag" ON "Peliculas".id = "PeliculaTag"."pelicula_id"
GROUP BY "Peliculas".nombre;

--4 Dado el Siguiente Modelo:
-- DE PREGUNTAS A RESPUESTA MUCHOS, DE RESPUESTAS A PREGUNTAS UNO, DE RESPUESTAS A USUARIOS UNO Y DE USUARIOS A RESPUESTAS MUCHOS
--con: La Tabla Preguntas con id como PK INTEGER, pregunta como VARCHAR (255) y respuesta_correcta como VARCHAR,
-- la Tabla Usuarios, con id como PK INTEGER, nombre como VARCHAR(255) y edad como INTEGER
-- y
-- la Tabla Respuestas, con id como PK INTEGER, respuesta como VARCHAR(255), usuario_id como FK INTEGER y pregunta_id como FK INTEGER
-- Crea las Tablas, respetando los Nombres, Tipos, Claves Primarias y Foráneas, y Tipos de Datos:
CREATE TABLE "Preguntas"(
    "id" INTEGER,
    "pregunta" VARCHAR(255),
    "respuesta_correcta" VARCHAR,
    PRIMARY KEY ("id")
);

CREATE TABLE "Usuarios" (
    "id" INTEGER,
    "nombre" VARCHAR(255),
    "edad" INTEGER,
    PRIMARY KEY ("id")
);

CREATE TABLE "Respuestas" (
    "id" INTEGER,
    "respuesta" VARCHAR(255),
    "usuario_id" INTEGER,
    "pregunta_id" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("usuario_id") REFERENCES "Usuarios"("id"),
    FOREIGN KEY ("pregunta_id") REFERENCES "Preguntas"("id")
);

-- 5. Agrega Datos, 5 Usuarios y 5 Preguntas, la Primera Pregunta debe estar contestada 2 Veces Correctamente, por Distintos Usuarios, la Pregunta 2, debe estar contestada Correctamente por un Solo Usuario, y las otras 2 Respuestas, deben ser Incorrectas
-- a. Contestada Correctamente, significa que la Respuesta indicada en la Tabla Respuestas es Exactamente igual al Texto indicado en la Tabla Preguntas
INSERT INTO "Usuarios"
VALUES (1, 'Fran', 29),
    (2, 'Diego', 30),
    (3, 'Lucho', 34),
    (4, 'Gus', 34),
    (5, 'Leo', 36);

INSERT INTO "Preguntas"
VALUES (1, '¿Que le pasa a Lupita?', 'No se'),
    (2, '¿Que es lo que quiere el Negro?', 'Bailar'),
    (3, '¿Quien mato a Marylin?', 'La Prensa fue'),
    (4, '¿Que fue primero, el Huevo o la gallina?',
        'La Gallina'),
    (5, '¿Quien creo el Mundo?', 'Dios');

INSERT INTO "Respuestas"
VALUES (1, 'No se', 1, 1),
    (2, 'No se', 2, 1),
    (3, 'Bailar', 1, 2),
    (4, 'Hola!', 1, 4),
    (5, 'Wenas!!', 1, 3);

SELECT "Preguntas"."pregunta",
    "Respuestas"."respuesta",
    "Usuarios"."nombre"
FROM "Preguntas"
    INNER JOIN "Respuestas" ON "Preguntas"."respuesta_correcta" = "Respuestas"."respuesta"
    INNER JOIN "Usuarios" ON "Respuestas"."usuario_id" = "Usuarios"."id";

--6. Cuenta la Cantidad de Respuestas Correctas Totales por Usuario(indepediente de la Pregunta) *COUNT DE REPUESTAS CORRECTAS POR AGRUPADO EN BASE AL USUARIO*
SELECT "Usuarios"."nombre",
    COUNT("Preguntas"."respuesta_correcta")
FROM "Usuarios"
    LEFT JOIN "Respuestas" ON "Usuarios"."id" = "Respuestas"."usuario_id"
    LEFT JOIN "Preguntas" ON "Respuestas"."respuesta" = "Preguntas"."respuesta_correcta"
GROUP BY "Usuarios"."nombre";

--7. Por cada Pregunta, en la Tabla Preguntas, cuenta cuántos Usuarios tuvieron la Respuesta Correcta :D!!
SELECT "Preguntas"."pregunta",
    COUNT("Respuestas"."respuesta")
FROM "Preguntas"
    LEFT JOIN "Respuestas" ON "Preguntas"."respuesta_correcta" = "Respuestas"."respuesta"
    LEFT JOIN "Usuarios" ON "Respuestas"."usuario_id" = "Usuarios"."id"
GROUP BY "Preguntas"."pregunta";

-- 8. Implementa Borrado en Cascada de las Respuestas al Borrar un Usuario, y Borrar el Primer Usuario para Probar la Implementacion:
\ d "Respuestas"

ALTER TABLE "Respuestas" DROP CONSTRAINT "Respuestas_usuario_id_fkey",
    ADD FOREIGN KEY ("usuario_id") REFERENCES "Usuarios"("id") ON DELETE CASCADE;

DELETE FROM "Usuarios"
WHERE "id" = 1;

-- 9. Crea una Restricción que impida Insertar Usuarios Menores de 18 Años en la Base de Datos:
ALTER TABLE "Usuarios"
ADD CONSTRAINT mayoresa18anos CHECK ("edad" >= 18);
INSERT INTO "Usuarios"
VALUES (10, 'Hola', 17);

-- 10. Altera la Tabla existente de Usuarios (usuarios) agregando el Campo Email con la Restricción de unico:
ALTER TABLE "Usuarios"
ADD "email" VARCHAR(255);
ALTER TABLE "Usuarios"
ADD CONSTRAINT onemail UNIQUE ("email");

INSERT INTO "Usuarios" (id, email)
VALUES (1145, 'holaaaa!');