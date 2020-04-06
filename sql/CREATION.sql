SET client_min_messages TO WARNING;

\echo '\n'
\! tput setaf 1
\echo '======================= \t DESTRUCTION_DES_TABLES \t ======================='
\! tput sgr0


DROP TABLE IF EXISTS JEUX_OLYMPIQUES CASCADE;
DROP TABLE IF EXISTS EPREUVES CASCADE;
DROP TABLE IF EXISTS SUB_EPREUVES CASCADE;
DROP TABLE IF EXISTS ATHLETES CASCADE;
DROP TABLE IF EXISTS MEMBRES CASCADE;
DROP TABLE IF EXISTS EQUIPES CASCADE;
DROP TABLE IF EXISTS COMPOSE CASCADE;
DROP TABLE IF EXISTS RESULTATS_ATHLETE CASCADE;
DROP TABLE IF EXISTS RESULTATS_EQUIPE CASCADE;


-- =======================================================================
-------------------------- Table :JEUX_OLYMPIQUES  -----------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_JEUX_OLYMPIQUES \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS JEUX_OLYMPIQUES
(
  ID_JEU_OLYMPIQUE  SERIAL NOT NULL,
  VILLE             VARCHAR(30),
  ANNEE             INT,
  TYPE_EDITION      VARCHAR(10),
  CONSTRAINT PK_JEUx_OLYMPIQUEs PRIMARY KEY (ID_JEU_OLYMPIQUE),
  CONSTRAINT CK_VILLE_JEUX_OLYMPIQUES CHECK (VILLE IS NOT NULL),
  CONSTRAINT CK_VALIDITE_DATE CHECK ( (TYPE_EDITION = 'ETE' AND MOD((ANNEE - 1912),4) = 0) OR  (TYPE_EDITION = 'HIVER' AND MOD((ANNEE - 1994),4) = 0 ) )
);


-- =======================================================================
---------------------------- Table : ATHLETES  ---------------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_ATHLETES \t \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS ATHLETES
(
  ID_ATHLETE      SERIAL NOT NULL,
  NOM             VARCHAR(100),
  PRENOM          VARCHAR(100),
  DATE_NAISSANCE  DATE,
  SEXE            VARCHAR(1),
  PAYS            VARCHAR(100),
  STATUS          INT,

  CONSTRAINT PK_ATHLETES PRIMARY KEY (ID_ATHLETE),
  CONSTRAINT CK_NOM_ATHLETES CHECK (NOM IS NOT NULL),
  CONSTRAINT CK_PRENOM_ATHLETES CHECK (PRENOM IS NOT NULL),
  CONSTRAINT CK_DATE_NAISSANCE_ATHLETES CHECK (DATE_NAISSANCE IS NOT NULL),
  CONSTRAINT CK_SEXE_ATHLETES CHECK (SEXE IN ('F','M')),
  CONSTRAINT CK_PAYS_ATHLETES CHECK (PAYS IS NOT NULL),
  CONSTRAINT CK_STATUS CHECK (STATUS IN (0 , 1))
);

CREATE INDEX idx_id_athlete ON ATHLETES(ID_ATHLETE);


-- =======================================================================
---------------------------- Table : EPREUVES  ---------------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_EPREUVES \t \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS EPREUVES
(
  NOM_EPREUVE      VARCHAR(100),
  TYPE_EPREUVE     VARCHAR(20),

  CONSTRAINT CK_TYPE_EPREUVE_EPREUVE CHECK ( TYPE_EPREUVE IN ('INDIVIDUELLE', 'EN EQUIPE'))
);


-- =======================================================================
-------------------------- Table : SUB_EPREUVES  -------------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_SUB_EPREUVES \t \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS SUB_EPREUVES
(
  ID                  SERIAL NOT NULL,
  NOM_EPREUVE         VARCHAR(100),
  DETAIL              VARCHAR(300),
  CONSTRAINT PK_SUB_EPREUVES PRIMARY KEY (ID)
);

CREATE INDEX idx_id_sub_epreuve ON SUB_EPREUVES(ID);


-- =======================================================================
---------------------------- Table : COMPOSE  ----------------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_COMPOSE \t \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS COMPOSE
(
  ID_JEU_OLYMPIQUE     SERIAL NOT NULL,
  ID_SUB_EPREUVE       INT,
  CONSTRAINT PK_COMPOSE PRIMARY KEY (ID_JEU_OLYMPIQUE,ID_SUB_EPREUVE),
  CONSTRAINT FK_ID_JEU_OMPQ_COMPOSE FOREIGN KEY (ID_JEU_OLYMPIQUE) REFERENCES JEUX_OLYMPIQUES(ID_JEU_OLYMPIQUE),
  CONSTRAINT FK_ID_SUB_EPREUVE_COMPOSE FOREIGN KEY (ID_SUB_EPREUVE) REFERENCES SUB_EPREUVES(ID)
);


-- =======================================================================
----------------------------- Table : EQUIPES  ---------------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_EQUIPES \t \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS EQUIPES
(
  ID_EQUIPE       SERIAL NOT NULL,
  PAYS            VARCHAR(30),
  CONSTRAINT PK_EQUIPES PRIMARY KEY (ID_EQUIPE),
  CONSTRAINT CK_PAYS_EQUIPES CHECK (PAYS IS NOT NULL)
);


-- =======================================================================
--------------------------- Table : MEMBRES  -----------------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_MEMBRES \t \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS MEMBRES
(
  ID_ATHLETE        INT,
  ID_EQUIPE         INT,
  ANNEE             INT,
  CONSTRAINT PK_MEMBRES PRIMARY KEY (ID_ATHLETE,ID_EQUIPE,ANNEE),
  CONSTRAINT FK_ID_ATHLETE_MEMBRES  FOREIGN KEY (ID_ATHLETE) REFERENCES ATHLETES(ID_ATHLETE),
  CONSTRAINT FK_ID_EQUIPE_MEMBRES   FOREIGN KEY (ID_EQUIPE) REFERENCES  EQUIPES(ID_EQUIPE),
  CONSTRAINT CK_ANNEE_MEMBRES CHECK ( ANNEE >= 1912)
);




-- =======================================================================
----------------------- Table : RESULTATS_ATHLETE  -----------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_RESULTATS_ATHLETE \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS RESULTATS_ATHLETE
(
  ID_ATHLETE             INT,
  ID_JEU_OLYMPIQUE       INT,
  ID_SUB_EPREUVE         INT,
  RANG                   INT,
  DUREE                  REAL DEFAULT 0,
  DATE_                  DATE DEFAULT ('2016-06-06'),
  CONSTRAINT PK_RESULTATS_ATH PRIMARY KEY (ID_ATHLETE,ID_JEU_OLYMPIQUE,ID_SUB_EPREUVE),
  CONSTRAINT FK_ID_ATHLETE_RESULTATS_ATH  FOREIGN KEY (ID_ATHLETE) REFERENCES ATHLETES(ID_ATHLETE),
  CONSTRAINT FK_ID_JEU_OMPQ_RESULTATS_ATH FOREIGN KEY (ID_JEU_OLYMPIQUE) REFERENCES JEUX_OLYMPIQUES(ID_JEU_OLYMPIQUE),
  CONSTRAINT FK_ID_SUB_EPREUVE_RESULTATS_ATH FOREIGN KEY (ID_SUB_EPREUVE) REFERENCES SUB_EPREUVES(ID),
  CONSTRAINT DUREE_POSITIVE    CHECK(DUREE >= 0),
  CONSTRAINT CK_RANG_RESULTATS_ATH CHECK ( RANG IS NOT NULL)

);




-- =======================================================================
------------------------ Table : RESULTATS_EQUIPE  -----------------------
-- =======================================================================

\echo '\n'
\! tput setaf 1
\echo '======================= \t CREATION_RESULTATS_EQUIPE \t ======================='
\! tput sgr0


CREATE TABLE IF NOT EXISTS RESULTATS_EQUIPE
(
  ID_EQUIPE              INT,
  ID_JEU_OLYMPIQUE       INT,
  ID_SUB_EPREUVE         INT,
  RANG                   INT,
  SCORE                  VARCHAR(100)  NOT NULL,
  DATE_                  DATE DEFAULT ('2016-08-06'),
  CONSTRAINT PK_RESULTATS_EQ PRIMARY KEY (ID_EQUIPE,ID_JEU_OLYMPIQUE,ID_SUB_EPREUVE),
  CONSTRAINT FK_ID_EQUIPE_RESULTATS_EQ   FOREIGN KEY (ID_EQUIPE) REFERENCES  EQUIPES(ID_EQUIPE),
  CONSTRAINT FK_ID_JEU_OMPQ_RESULTATS_EQ FOREIGN KEY (ID_JEU_OLYMPIQUE) REFERENCES JEUX_OLYMPIQUES(ID_JEU_OLYMPIQUE),
  CONSTRAINT FK_ID_SUB_EPREUVE_RESULTATS_ATH FOREIGN KEY (ID_SUB_EPREUVE) REFERENCES SUB_EPREUVES(ID),
  CONSTRAINT CK_RANG_RESULTATS_EQ CHECK ( RANG IS NOT NULL)
);



-- ====================================================================== --
-- ====================================================================== --
-- ====================================================================== --
-- ====================================================================== --

\echo '\n'
\! tput setaf 3
\dt+
\! tput sgr0
