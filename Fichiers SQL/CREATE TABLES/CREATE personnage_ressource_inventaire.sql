CREATE TABLE personnage_ressource_inventaire (
    id_personnage INT NOT NULL,
    id_ressource INT NOT NULL,
    quantite INT NOT NULL,
    maximum INT DEFAULT 10,

    CONSTRAINT p_key PRIMARY KEY (id_personnage, id_ressource),
    FOREIGN KEY (id_personnage) REFERENCES personnages(id_personnage),
    FOREIGN KEY (id_ressource) REFERENCES types_ressources(id_ressource)
);