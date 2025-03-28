CREATE TABLE personnages (
    id_personnage INT AUTO_INCREMENT PRIMARY KEY,
    nom_personnage VARCHAR(16) UNIQUE NOT NULL,
    niveau_hache INT NOT NULL,
    niveau_pioche INT NOT NULL,
    nom_village VARCHAR(128) NOT NULL,
    dernier_x FLOAT NOT NULL,
    dernier_y FLOAT NOT NULL,
    dernier_z FLOAT NOT NULL,
    derniere_rotation_y FLOAT NOT NULL,
    village_dernier_x FLOAT,
    village_dernier_y FLOAT,
    village_dernier_z FLOAT,
    est_connecte BOOL DEFAULT 0
); #UNIQUE au nom

CREATE TABLE utilisateurs (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom_utilisateur VARCHAR(64) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(128) NOT NULL,
    id_personnage INT NOT NULL,

    FOREIGN KEY (id_personnage) REFERENCES personnages(id_personnage)
); #UNIQUE au courriel

CREATE TABLE types_ressources (
  id_ressource INT AUTO_INCREMENT PRIMARY KEY,
  nom_ressource VARCHAR(64) NOT NULL
);

CREATE TABLE villages_npcs (
  id_village_npc INT AUTO_INCREMENT PRIMARY KEY,
  nom_village VARCHAR(128) NOT NULL,
  position_x FLOAT NOT NULL,
  position_y FLOAT NOT NULL,
  position_z FLOAT NOT NULL
);

CREATE TABLE types_batiments (
  id_batiment INT AUTO_INCREMENT PRIMARY KEY,
  nom_batiment VARCHAR(64) NOT NULL,
  amelioration VARCHAR(128)
);

CREATE TABLE serveur_valeurs (
  id_iteration INT AUTO_INCREMENT PRIMARY KEY,
  seed VARCHAR(128) NOT NULL,
  season INT NOT NULL,
  iteration_start DATETIME NOT NULL,
  iteration_end DATETIME,
  ip_serveur VARCHAR(32) NOT NULL
);

CREATE TABLE recettes (
  id_recette INT AUTO_INCREMENT PRIMARY KEY,
  nom_recette VARCHAR(64) NOT NULL,
  est_amelioration BOOL DEFAULT false,
  a_ameliorer VARCHAR(5),
  nouveau_niveau INT,
  id_batiment INT,

  FOREIGN KEY (id_batiment) REFERENCES types_batiments(id_batiment)
);

CREATE TABLE bundles_ingredients (
  id_ressource INT,
  id_recette INT,
  quantite INT,

  CONSTRAINT p_key PRIMARY KEY (id_ressource, id_recette),
  FOREIGN KEY (id_ressource) REFERENCES types_ressources(id_ressource),
  FOREIGN KEY (id_recette) REFERENCES recettes(id_recette)
);

/*
CREATE TABLE npcs (
  id_npc INT AUTO_INCREMENT PRIMARY KEY,
  nom
  --Type de npc ? 
  /*OUVERT A DU DÉVELOPPEMENT FUTUR*/
);*/

CREATE TABLE personnage_ressource_inventaire (
    id_personnage INT NOT NULL,
    id_ressource INT NOT NULL,
    quantite INT NOT NULL,
    maximum INT DEFAULT 5,

    CONSTRAINT p_key PRIMARY KEY (id_personnage, id_ressource),
    FOREIGN KEY (id_personnage) REFERENCES personnages(id_personnage),
    FOREIGN KEY (id_ressource) REFERENCES types_ressources(id_ressource)
);

CREATE TABLE personnage_ressource_coffre (
    id_personnage INT NOT NULL,
    id_ressource INT NOT NULL,
    quantite INT NOT NULL,
    maximum INT DEFAULT 10,

    CONSTRAINT p_key PRIMARY KEY (id_personnage, id_ressource),
    FOREIGN KEY (id_personnage) REFERENCES personnages(id_personnage),
    FOREIGN KEY (id_ressource) REFERENCES types_ressources(id_ressource)
);

CREATE TABLE village_personnage_batiment (
    id_personnage INT NOT NULL,
    id_batiment INT NOT NULL,
    position_x FLOAT,
    position_y FLOAT,
    position_z FLOAT,
    rotation_y FLOAT,
    est_place BOOL,

    CONSTRAINT p_key PRIMARY KEY (id_personnage, id_batiment),
    FOREIGN KEY (id_personnage) REFERENCES personnages(id_personnage),
    FOREIGN KEY (id_batiment) REFERENCES types_batiments(id_batiment)
);

CREATE TABLE village_npc_batiment (
    id_village_npc INT NOT NULL,
    id_batiment INT NOT NULL,
    position_x FLOAT NOT NULL,
    position_y FLOAT NOT NULL,
    position_z FLOAT NOT NULL,
    rotation_y FLOAT NOT NULL,

    CONSTRAINT p_key PRIMARY KEY (id_village_npc, id_batiment),
    FOREIGN KEY (id_village_npc) REFERENCES villages_npcs(id_village_npc),
    FOREIGN KEY (id_batiment) REFERENCES types_batiments(id_batiment)
);


