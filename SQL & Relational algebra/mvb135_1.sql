/*
1. Adjuntar un fitxer .sql on hi hagui l'especificació de les taules, que ha d'ésser fidedigne al de l'enunciat.
*/

CREATE TABLE ALIMENT (
    REFERENCIA VARCHAR(13),                             /*Referencia del producte*/
    NOM VARCHAR(50) NOT NULL,                           /*Nom del producte*/
    PREU INTEGER NOT NULL,                              /*Preu del producte*/
    CONSTRAINT PK_ALIMENT PRIMARY KEY (REFERENCIA)
);

CREATE TABLE PROVEIDOR (
    NIF VARCHAR(11),                                    /*NIF del proveidor*/
    NOM VARCHAR(50) NOT NULL,                           /*Nom del proveidor*/
    CONSTRAINT PK_PROVEIDOR PRIMARY KEY (NIF)
);

CREATE TABLE ALBARA (
    CODI NUMERIC(5),                                    /*Codi de l'albara*/
    NIF_PRO VARCHAR(11) NOT NULL,                       /*Nif del proveidor*/
    DATA DATE NOT NULL,                                 /*Data de l'albara*/
    FACTURAT VARCHAR(1) NOT NULL,                       /*Esta facturat?*/
    CONSTRAINT PK_ALBARA PRIMARY KEY (CODI),
    CONSTRAINT CHECKFACT CHECK(FACTURAT IN ('S','N')),
    CONSTRAINT FK_PROVEIDOR FOREIGN KEY (NIF_PRO) REFERENCES PROVEIDOR (NIF)
);

CREATE TABLE LINIA_ALBARA (
    CODI_ALB NUMERIC(5) NOT NULL,                       /*Codi de l'albara*/
    REFERENCIA VARCHAR(13) NOT NULL,                    /*Referencia del producte*/
    QUILOGRAMS INTEGER NOT NULL,                        /*Quilograms de producte*/
    PREU INTEGER,                                       /*Preu per quilogram de producte*/
    CONSTRAINT PK_LINALB PRIMARY KEY (CODI_ALB, REFERENCIA),
    CONSTRAINT FK_LA_ALBARA FOREIGN KEY (CODI_ALB) REFERENCES ALBARA (CODI),
    CONSTRAINT FK_LA_ALIMENT FOREIGN KEY (REFERENCIA) REFERENCES ALIMENT (REFERENCIA) 
);

CREATE TABLE VENDA (
    CODI NUMERIC(8),                                    /*Codi de la venda*/
    REFERENCIA VARCHAR(13) NOT NULL,                    /*Referencia del producte*/
    DATA DATE NOT NULL,                                 /*Data de la venda*/
    QUILOGRAMS INTEGER NOT NULL,                        /*Quilograms venuts de producte*/
    PREU INTEGER NOT NULL,                              /*Preu per quilogram de producte*/
    CONSTRAINT PK_VENDA PRIMARY KEY (CODI),
    CONSTRAINT FK_VENDA FOREIGN KEY (REFERENCIA) REFERENCES ALIMENT (REFERENCIA)
);