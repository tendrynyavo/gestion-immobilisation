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
   mere VARCHAR2(50) ,
   id_immobilisation VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_composant),
   FOREIGN KEY(mere) REFERENCES composant(id_composant),
   FOREIGN KEY(id_immobilisation) REFERENCES immobilisation(id_immobilisation)
);

CREATE TABLE reception(
   id_reception VARCHAR2(50) ,
   code VARCHAR2(100)  NOT NULL,
   date_reception DATE NOT NULL,
   id_addresse VARCHAR2(50)  NOT NULL,
   id_immobilisation VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(id_reception),
   FOREIGN KEY(id_addresse) REFERENCES adresse(id_addresse),
   FOREIGN KEY(id_immobilisation) REFERENCES immobilisation(id_immobilisation)
);

CREATE TABLE bien(
   code VARCHAR2(50) ,
   nom VARCHAR2(50)  NOT NULL,
   id_marque VARCHAR2(50)  NOT NULL,
   id_reception VARCHAR2(50)  NOT NULL,
   PRIMARY KEY(code),
   UNIQUE(id_reception),
   FOREIGN KEY(id_marque) REFERENCES marque(id_marque),
   FOREIGN KEY(id_reception) REFERENCES reception(id_reception)
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
   code VARCHAR2(50) ,
   etat NUMBER(10) NOT NULL,
   PRIMARY KEY(id_composant, code),
   FOREIGN KEY(id_composant) REFERENCES composant(id_composant),
   FOREIGN KEY(code) REFERENCES bien(code)
);
