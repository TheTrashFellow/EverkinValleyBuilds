CREATE TABLE personnage_batiment_village (
    id_personnage INT NOT NULL,
    id_batiment INT NOT NULL,
    position_x FLOAT DEFAULT 0,
    position_y FLOAT DEFAULT 0,
    position_z FLOAT DEFAULT 0,
    rotation_y FLOAT DEFAULT 0,
    est_place BOOL DEFAULT 0,
    
    FOREIGN KEY (id_personnage) REFERENCES personnages(id_personnage),
    FOREIGN KEY (id_batiment) REFERENCES types_batiments(id_batiment)
);