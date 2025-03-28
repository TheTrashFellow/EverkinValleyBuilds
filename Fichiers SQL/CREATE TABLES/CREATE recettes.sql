CREATE TABLE recettes (
  id_recette INT AUTO_INCREMENT PRIMARY KEY,
  nom_recette VARCHAR(64) NOT NULL,
  est_amelioration BOOL DEFAULT 0,
  a_ameliorer VARCHAR(5) DEFAULT "null",
  nouveau_niveau INT DEFAULT -1,
  id_batiment INT DEFAULT -1,

  FOREIGN KEY (id_batiment) REFERENCES types_batiments(id_batiment)
);