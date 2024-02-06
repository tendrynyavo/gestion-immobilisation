INSERT INTO IMMOBILISATION.COMPOSANT (ID_COMPOSANT,NOM,MERE,ID_IMMOBILISATION,CAPACITE,UNITE,ALERTE) VALUES
	 ('C030','Systeme exploitation',NULL,'IM002',NULL,NULL,5),
	 ('C031','Mises a jour','C030','IM002',NULL,NULL,5),
	 ('C032','Maintenance des correctifs de s¿curit¿','C030','IM002',NULL,NULL,5),
	 ('C033','Logiciels et pilotes',NULL,'IM002',NULL,NULL,5),
	 ('C034','Mises a jour','C033','IM002',NULL,NULL,5),
	 ('C035','Sauvegarde',NULL,'IM002',NULL,NULL,5),
	 ('C036','Configuration','C035','IM002',NULL,NULL,5),
	 ('C037','Verification','C035','IM002',NULL,NULL,5),
	 ('C038','Systeme de refroidissement',NULL,'IM002',NULL,NULL,5),
	 ('C039','Ventilateurs','C038','IM002',NULL,NULL,5);
INSERT INTO IMMOBILISATION.COMPOSANT (ID_COMPOSANT,NOM,MERE,ID_IMMOBILISATION,CAPACITE,UNITE,ALERTE) VALUES
	 ('C040','Temperatures du processeur','C038','IM002',NULL,NULL,5),
	 ('C041','Anti-virus et sécurité',NULL,'IM002',NULL,NULL,5),
	 ('C042','Mises a jour','C041','IM002',NULL,NULL,5),
	 ('C043','Analyse','C041','IM002',NULL,NULL,5),
	 ('C044','Tetes impression',NULL,'IM003',NULL,NULL,5),
	 ('C045','Nettoyage','C044','IM003',NULL,NULL,5),
	 ('C046','Alignement','C044','IM003',NULL,NULL,5),
	 ('C047','Bac a papier',NULL,'IM003',NULL,NULL,5),
	 ('C048','Nettoyage','C047','IM003',NULL,NULL,5),
	 ('C049','Ajustement','C047','IM003',NULL,NULL,5);
INSERT INTO IMMOBILISATION.COMPOSANT (ID_COMPOSANT,NOM,MERE,ID_IMMOBILISATION,CAPACITE,UNITE,ALERTE) VALUES
	 ('C050','Rouleaux alimentation',NULL,'IM003',NULL,NULL,5),
	 ('C051','Nettoyage','C050','IM003',NULL,NULL,5),
	 ('C052','Remplacement','C050','IM003',NULL,NULL,5),
	 ('C053','Cartouches encre/toner',NULL,'IM003',NULL,NULL,5),
	 ('C054','Remplacement','C053','IM003',NULL,NULL,5),
	 ('C055','Niveaux encre','C053','IM003',NULL,NULL,5),
	 ('C056','Stockage',NULL,'IM004',NULL,NULL,5),
	 ('C057','Environnement','C056','IM004',NULL,NULL,5),
	 ('C058','Protection','C056','IM004',NULL,NULL,5),
	 ('C059','Manipulation',NULL,'IM004',NULL,NULL,5);
INSERT INTO IMMOBILISATION.COMPOSANT (ID_COMPOSANT,NOM,MERE,ID_IMMOBILISATION,CAPACITE,UNITE,ALERTE) VALUES
	 ('C060','Soins','C059','IM004',NULL,NULL,5),
	 ('C061','Lumiere','C059','IM004',NULL,NULL,5),
	 ('C062','Compatibilite',NULL,'IM004',NULL,NULL,5),
	 ('C063','Utilisation','C062','IM004',NULL,NULL,5),
	 ('C064','Verification','C062','IM004',NULL,NULL,5),
	 ('C066','License Microsoft Office','C033','IM002',12,'mois',5),
	 ('C067','Essence',NULL,'IM001',90,'L',5),
	 ('C003','Systeme de refroidissement','C001','IM001',NULL,NULL,3),
	 ('C001','Moteur',NULL,'IM001',NULL,NULL,6),
	 ('C002','Changement huile moteur','C001','IM001',20,'L',4);
INSERT INTO IMMOBILISATION.COMPOSANT (ID_COMPOSANT,NOM,MERE,ID_IMMOBILISATION,CAPACITE,UNITE,ALERTE) VALUES
	 ('C004','Courroie de distribution','C001','IM001',NULL,NULL,3),
	 ('C005','Bougies allumage','C001','IM001',NULL,NULL,3),
	 ('C014','Batterie',NULL,'IM001',NULL,NULL,3),
	 ('C015','Bornes de la batterie','C014','IM001',NULL,NULL,3),
	 ('C016','Niveau electrolyte','C014','IM001',40,'V',6),
	 ('C010','Pneus',NULL,'IM001',NULL,NULL,3),
	 ('C011','Rotation des pneus','C010','IM001',NULL,NULL,3),
	 ('C012','Equilibrage des pneus','C010','IM001',NULL,NULL,3),
	 ('C013','Alignement','C010','IM001',NULL,NULL,3);
