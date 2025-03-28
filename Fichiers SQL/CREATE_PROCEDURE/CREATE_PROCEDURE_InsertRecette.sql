DELIMITER //

CREATE PROCEDURE InsertRecette(
    IN p_nom VARCHAR(64),
    IN p_amelioration BOOL,
    IN p_target VARCHAR(5),
    IN p_newLevel INT,
    IN p_idBatiment INT    
)
BEGIN
    IF EXISTS (SELECT 1 FROM recettes WHERE nom_recette = p_nom) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Cette recette existe déjà'; 
    ELSEIF EXISTS (SELECT 1 FROM recettes WHERE id_batiment = p_idBatiment) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Une recette existe déjà pour ce type de batiment '; 
    ELSE
        INSERT INTO recettes (nom_recette, est_amelioration, a_ameliorer, nouveau_niveau, id_batiment)
        VALUES (p_nom, p_amelioration, p_target, p_newLevel, p_idBatiment);
    END IF;
END //
DELIMITER ;