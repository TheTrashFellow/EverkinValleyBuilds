DELIMITER //

CREATE PROCEDURE InsertTypesRessources(
    IN p_nom_ressource VARCHAR(255) -- Ajout d'une taille pour le VARCHAR
)
BEGIN
    -- Vérifier si la ressource existe déjà
    IF EXISTS (SELECT 1 FROM types_ressources WHERE nom_ressource = p_nom_ressource) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cette ressource existe déjà';  
    ELSE
        -- Insérer la nouvelle ressource
        INSERT INTO types_ressources (nom_ressource)
        VALUES (p_nom_ressource);
    END IF;
END //

DELIMITER ;
