DELIMITER //

CREATE PROCEDURE InsertIngredientRecette(
    IN p_id_ressource INT,
    IN p_id_recette INT,
    IN p_quantite INT  
)
BEGIN
    IF EXISTS (SELECT 1 FROM bundles_ingredients WHERE id_ressource = p_id_ressource AND id_recette = p_id_recette) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Cet ingrédient est déjà lié à cette recette';     
    ELSE
        INSERT INTO bundles_ingredients (id_ressource, id_recette, quantite)
        VALUES (p_id_ressource, p_id_recette, p_quantite);
    END IF;
END //
DELIMITER ;