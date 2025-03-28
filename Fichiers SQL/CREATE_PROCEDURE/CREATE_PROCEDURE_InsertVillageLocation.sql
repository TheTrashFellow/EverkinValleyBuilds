DELIMITER //

CREATE PROCEDURE InsertVillageLocation(
    IN p_id_personnage FLOAT,
    IN p_village_dernier_x FLOAT,
    IN p_village_dernier_y FLOAT,
    IN p_village_dernier_z FLOAT
)
BEGIN
    DECLARE y FLOAT DEFAULT 0;
    SELECT village_dernier_y INTO y FROM personnages WHERE id_personnage = p_id_personnage;


    IF (y = 0) THEN
        UPDATE personnages SET village_dernier_x = p_village_dernier_x, village_dernier_y = p_village_dernier_y, village_dernier_z = p_village_dernier_z WHERE id_personnage = p_id_personnage;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Village déjà existant';
    END IF;
END //

DELIMITER ;
