-- ===================================================================================
-- ====================== Mario Ventura Burgos - 43223476J ===========================
-- ================= Sistemas de gestión de base de datos ============================
-- ========== Código de creación de tablas del modelo de datos definitivo ============
-- ===================================================================================

-- TABLA DE APODERAT
CREATE TABLE APODERAT (
    ideapo VARCHAR(10), -- Identificador del apoderado (màxim 10 dígits)
    CONSTRAINT PK_APODERAT PRIMARY KEY (ideapo)
) TABLESPACE my_tablespace;

-- TABLA DE UBICACION
CREATE TABLE UBICACION (
    ideubi INT(11) AUTO_INCREMENT,  -- Identificador de la ubicación
    nompai VARCHAR(40) NOT NULL,    -- Nombre del país
    nomciu VARCHAR(50) NOT NULL,    -- Nombre de la ciutat
    CONSTRAINT PK_UBICACION PRIMARY KEY (ideubi)
) TABLESPACE my_tablespace;

-- TABLA DE RAMADERIA
CREATE TABLE RAMADERIA (
    cifram VARCHAR(3),              -- CIF de la ramaderia
    nomram VARCHAR(50) NOT NULL,    -- Nombre de la ramaderia
    CONSTRAINT PK_RAMADERIA PRIMARY KEY (cifram)
) TABLESPACE my_tablespace;

-- TABLA DE FERIA
CREATE TABLE FERIA (
    fircor VARCHAR(50), -- Nombre de la festa o feria
    CONSTRAINT PK_FERIA PRIMARY KEY (fircor)
) TABLESPACE my_tablespace;

-- TABLA DE PERSONA
CREATE TABLE PERSONA (
    ideper VARCHAR(10),             -- Identificador de la persona
    ideubi INT(11) NOT NULL,        -- Clave forana que referencia a UBICACION(ideubi)
    nompe VARCHAR(50) NOT NULL,     -- Nombre de la persona
    co1pe VARCHAR(50) NOT NULL,     -- Primer apellido de la persona
    co2pe VARCHAR(50),              -- Segundo apellido de la persona
    maiper VARCHAR(100),            -- Mail de la persona
    dirper VARCHAR(100) NOT NULL,   -- Dirección de la persona
    CONSTRAINT PK_PERSONA PRIMARY KEY (ideper),
    CONSTRAINT FK_PERSONA_UBICACION FOREIGN KEY (ideubi) REFERENCES UBICACION(ideubi)
) TABLESPACE my_tablespace;

-- TABLA DE PLAZA
CREATE TABLE PLAZA (
    nompla VARCHAR(50), -- Nombre de la plaza
    ideubi INT(11) NOT NULL,    -- Clave forana que referencia a UBICACION(ideubi)
    anypla DATE NOT NULL,   -- Año de construcción de la plaza
    locpla INT NOT NULL,    -- Número de asientos de la plaza
    tippla BOOLEAN NULL,    -- Si la plaza es fija o movil
    estpla TEXT,            -- Estilos predominantes en la construcción
    muspla BOOLEAN NULL,    -- Indica si la plaza contiene un museo
    CONSTRAINT PK_PLAZA PRIMARY KEY (nompla),
    CONSTRAINT FK_PLAZA_UBICACION FOREIGN KEY (ideubi) REFERENCES UBICACION(ideubi),
    CONSTRAINT CHECK_PLAZA_MUSPLA CHECK (muspla IN (0, 1)),
    CONSTRAINT CHECK_PLAZA_TIPPLA CHECK (tippla IN (0, 1))
) TABLESPACE my_tablespace;

-- TABLA DE TORERO
CREATE TABLE TORERO (
    idetor VARCHAR(10), -- Identificador del torero (máximo 10 dígits)
    ideapo VARCHAR(10) NOT NULL, -- Clave forana que referencia a APODERAT(ideapo)
    CONSTRAINT PK_TORERO PRIMARY KEY (idetor),
    CONSTRAINT FK_TORERO_APODERAT FOREIGN KEY (ideapo) REFERENCES APODERAT(ideapo)
) TABLESPACE my_tablespace;

-- TABLA DE ACTUACION
CREATE TABLE ACTUACION (
    ideact INT(11) AUTO_INCREMENT, -- Identificador de la actuación
    idetor VARCHAR(10) NOT NULL, -- Clave forana que referencia a TORERO(idetor)
    nompla VARCHAR(50) NOT NULL, -- Clave forana que referencia a PLAZA(nompla)
    datcor DATE NOT NULL, -- Fecha de la actuación
    CONSTRAINT PK_ACTUACION PRIMARY KEY (ideact),
    CONSTRAINT FK_ACTUACION_TORERO FOREIGN KEY (idetor) REFERENCES TORERO(idetor),
    CONSTRAINT FK_ACTUACION_PLAZA FOREIGN KEY (nompla) REFERENCES PLAZA(nompla)
) TABLESPACE my_tablespace;

-- TABLA DE TORO
CREATE TABLE TORO (
    idtoro INT(11) AUTO_INCREMENT, -- Identificador del toro (autoincremental)
    cifram VARCHAR(3) NOT NULL,     -- Clave forana que referencia a RAMADERIA(cifram)
    nombou VARCHAR(50) NOT NULL,    -- Nombre o identificación del toro
    anybou DATE NOT NULL,           -- Año de nacimiento del toro
    pesbou DECIMAL(10,2) NOT NULL,  -- Peso del toro
    CONSTRAINT PK_TORO PRIMARY KEY (idtoro),
    CONSTRAINT FK_TORO_RAMADERIA FOREIGN KEY (cifram) REFERENCES RAMADERIA(cifram)
) TABLESPACE my_tablespace;

-- TABLA DE ESDEVENIMENT
CREATE TABLE ESDEVENIMENT (
    ideesd INT(11) AUTO_INCREMENT, -- Identificador del esdeveniment
    fircor VARCHAR(50) NOT NULL, -- Clave forana que referencia a FERIA(fircor)
    nompla VARCHAR(50) NOT NULL, -- Clave forana que referencia a PLAZA(nompla)
    datcor DATE NOT NULL, -- Fecha del esdeveniment
    CONSTRAINT PK_ESDEVENIMENT PRIMARY KEY (ideesd),
    CONSTRAINT FK_ESDEVENIMENT_FERIA FOREIGN KEY (fircor) REFERENCES FERIA(fircor),
    CONSTRAINT FK_ESDEVENIMENT_PLAZA FOREIGN KEY (nompla) REFERENCES PLAZA(nompla)
) TABLESPACE my_tablespace;

-- TABLA DE RELACION ENTRE ESDEVENIMENT Y TORO
CREATE TABLE R_ESDEVENIMENT_TORO (
    idtoro INT (11) NOT NULL,   -- id del toro que hace referencia a la tabla TORO
    ideesd INT(11) NOT NULL,    -- id del esdeveniment que hace referencia a la tabla ESDEVENIMENT
    CONSTRAINT PK_ESD_TORO PRIMARY KEY (idtoro, ideesd),
    CONSTRAINT FK_TORO FOREIGN KEY (idtoro) REFERENCES TORO (idtoro),
    CONSTRAINT FK_ESDEVENIMENT FOREIGN KEY (ideesd) REFERENCES ESDEVENIMENT (ideesd)
) TABLESPACE my_tablespace;