DELIMITER //

CREATE PROCEDURE VerifyConnection(
    IN p_id_personnage INT
)
BEGIN    
    IF(SELECT est_connecte FROM personnage WHERE id_personnage = p_id_personnage) THEN               
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un client est déjà connecté sur ce compte';       
    ELSE
        UPDATE personnage SET est_connecte = 1 WHERE id_personnage = p_id_personnage;
    END IF;
END //
DELIMITER ;