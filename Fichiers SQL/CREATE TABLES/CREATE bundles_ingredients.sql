CREATE TABLE bundles_ingredients (
  id_ressource INT,
  id_recette INT,
  quantite INT,

  CONSTRAINT p_key PRIMARY KEY (id_ressource, id_recette),
  FOREIGN KEY (id_ressource) REFERENCES types_ressources(id_ressource),
  FOREIGN KEY (id_recette) REFERENCES recettes(id_recette)
);