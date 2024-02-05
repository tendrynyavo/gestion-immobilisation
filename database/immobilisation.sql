CREATE TABLE categorie(
   id_categorie VARCHAR2(50) ,
   nom VARCHAR2(100)  NOT NULL,
   code VARCHAR2(50) ,
   PRIMARY KEY(id_categorie)
);

CREATE TABLE adresse(
   id_addresse VARCHAR2(50) ,
   nom VARCHAR2(100)  NOT NULL,
   PRIMARY KEY(id_addresse)
);

CREATE TABLE comportement(
   id_etat VARCHAR2(50) ,
   designation VARCHAR2(100) ,
   debut BINARY_DOUBLE,
   fin BINARY_DOUBLE,
   color VARCHAR2(50) ,
   PRIMARY KEY(id_etat)
);

CREATE TABLE employee(
   id_employee VARCHAR2(50) ,
   nom VARCHAR2(100) ,
   prenom VARCHAR2(100) ,
   PRIMARY KEY(id_employee)
);

CREATE TABLE immobilisation(
   id_immobilisation VARCHAR2(50) ,
   nom VARCHAR2(100)  NOT NULL,
   id_categorie VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_immobilisation),
   FOREIGN KEY(id_categorie) REFERENCES categorie(id_categorie)
);

CREATE TABLE marque(
   id_marque VARCHAR2(50) ,
   nom VARCHAR2(100)  NOT NULL,
   id_immobilisation VARCHAR2(50) ,
   PRIMARY KEY(id_marque),
   FOREIGN KEY(id_immobilisation) REFERENCES immobilisation(id_immobilisation)
);

CREATE TABLE caracteristique(
   id_caracteristique VARCHAR2(50) ,
   nom VARCHAR2(100)  NOT NULL,
   id_immobilisation VARCHAR2(50) ,
   PRIMARY KEY(id_caracteristique),
   FOREIGN KEY(id_immobilisation) REFERENCES immobilisation(id_immobilisation)
);

CREATE TABLE composant(
   id_composant VARCHAR2(50) ,
   nom VARCHAR2(50)  NOT NULL,
   unite VARCHAR2(50) ,
   capacite BINARY_DOUBLE,
   alerte BINARY_DOUBLE,
   mere VARCHAR2(50) ,
   id_immobilisation VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_composant),
   FOREIGN KEY(mere) REFERENCES composant(id_composant),
   FOREIGN KEY(id_immobilisation) REFERENCES immobilisation(id_immobilisation)
);

CREATE TABLE bien(
   code VARCHAR2(50) ,
   nom VARCHAR2(50)  NOT NULL,
   id_marque VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(code),
   FOREIGN KEY(id_marque) REFERENCES marque(id_marque)
);

CREATE TABLE inventaire(
   id_inventaire VARCHAR2(50) ,
   date_inventaire DATE,
   code VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_inventaire),
   FOREIGN KEY(code) REFERENCES bien(code)
);

CREATE TABLE mission(
   id_mission VARCHAR2(50) ,
   latitude BINARY_DOUBLE,
   longitude BINARY_DOUBLE,
   debut TIMESTAMP,
   adresse VARCHAR2(100) ,
   etat NUMBER(10) NOT NULL,
   code VARCHAR2(50)  NOT NULL,
   id_employee VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_mission),
   FOREIGN KEY(code) REFERENCES bien(code),
   FOREIGN KEY(id_employee) REFERENCES employee(id_employee)
);

CREATE TABLE fin_mission(
   id_fin_mission VARCHAR2(50) ,
   fin TIMESTAMP,
   id_inventaire VARCHAR2(50)  NOT NULL,
   id_mission VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_fin_mission),
   FOREIGN KEY(id_inventaire) REFERENCES inventaire(id_inventaire),
   FOREIGN KEY(id_mission) REFERENCES mission(id_mission)
);

CREATE TABLE valide_mission(
   id_validation VARCHAR2(50) ,
   date_validation TIMESTAMP,
   id_mission VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_validation),
   FOREIGN KEY(id_mission) REFERENCES mission(id_mission)
);

CREATE TABLE reception(
   id_reception VARCHAR2(50) ,
   date_reception DATE NOT NULL,
   id_addresse VARCHAR2(50)  NOT NULL,
   id_immobilisation VARCHAR2(50)  NOT NULL,
   code VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_reception),
   UNIQUE(code),
   FOREIGN KEY(id_addresse) REFERENCES adresse(id_addresse),
   FOREIGN KEY(id_immobilisation) REFERENCES immobilisation(id_immobilisation),
   FOREIGN KEY(code) REFERENCES bien(code)
);

CREATE TABLE detail_bien(
   id_caracteristique VARCHAR2(50) ,
   code VARCHAR2(50) ,
   valeur VARCHAR2(200) ,
   PRIMARY KEY(id_caracteristique, code),
   FOREIGN KEY(id_caracteristique) REFERENCES caracteristique(id_caracteristique),
   FOREIGN KEY(code) REFERENCES bien(code)
);

CREATE TABLE etat_composant(
   id_composant VARCHAR2(50) ,
   id_inventaire VARCHAR2(50) ,
   etat BINARY_DOUBLE,
   PRIMARY KEY(id_composant, id_inventaire),
   FOREIGN KEY(id_composant) REFERENCES composant(id_composant),
   FOREIGN KEY(id_inventaire) REFERENCES inventaire(id_inventaire)
);

CREATE TABLE etat_inventaire(
   id_composant VARCHAR2(50) ,
   id_validation VARCHAR2(50) ,
   etat BINARY_DOUBLE,
   PRIMARY KEY(id_composant, id_validation),
   FOREIGN KEY(id_composant) REFERENCES composant(id_composant),
   FOREIGN KEY(id_validation) REFERENCES valide_mission(id_validation)
);

CREATE TABLE sample (
   x DOUBLE PRECISION,
   y DOUBLE PRECISION
);