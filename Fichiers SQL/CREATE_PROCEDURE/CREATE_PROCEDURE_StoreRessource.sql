DELIMITER //

CREATE PROCEDURE StoreRessource(
    IN p_id_personnage INT,
    IN p_id_ressource INT,
    IN p_quantite INT    
)
BEGIN
    
    IF EXISTS (SELECT 1 FROM personnage_ressource_coffre WHERE id_ressource = p_id_ressource AND id_personnage = p_id_personnage) THEN
        DECLARE current_quantite INT DEFAULT 0;
        DECLARE current_max INT DEFAULT 0;
        SELECT quantite, maximum INTO current_quantite, current_max FROM personnage_ressource_coffre WHERE id_ressource = p_id_ressource AND id_personnage = p_id_personnage;

        IF (current_quantite = current_max) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le coffre à déjà atteint le max de cette ressource';     
        ELSE 
            IF (current_quantite + p_quantite >= current_max) THEN
                UPDATE personnage_ressource_coffre SET quantite = current_max WHERE id_ressource = p_id_ressource AND id_personnage = p_id_personnage;
                UPDATE personnage_ressource_inventaire SET quantite = (quantite - p_quantite) WHERE id_ressource = p_id_ressource AND id_personnage = p_id_personnage;
            ELSE
                UPDATE personnage_ressource_coffre SET quantite = current_quantite + p_quantite WHERE id_ressource = p_id_ressource AND id_personnage = p_id_personnage; 
                UPDATE personnage_ressource_inventaire SET quantite = (quantite - p_quantite) WHERE id_ressource = p_id_ressource AND id_personnage = p_id_personnage;          
            END IF;
        END IF;
    ELSE
        INSERT INTO personnage_ressource_coffre (id_personnage, id_ressource, quantite)
        VALUES (p_id_personnage, p_id_ressource, p_quantite);
    END IF;
END //
DELIMITER ;