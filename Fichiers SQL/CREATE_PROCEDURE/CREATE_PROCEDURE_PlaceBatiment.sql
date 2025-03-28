DELIMITER //

CREATE PROCEDURE PlaceBatiment(
    IN p_id_personnage VARCHAR(64),
    IN p_id_batiment VARCHAR(128),
    IN p_position_x FLOAT,
    IN p_position_y FLOAT,
    IN p_position_z FLOAT,
    IN p_rotation_y FLOAT 
)
BEGIN    
    UPDATE personnage_batiment_village SET position_x = p_position_x, position_y = p_position_y, position_z = p_position_z, rotation_y = p_rotation_y, est_place = TRUE WHERE id_personnage = p_id_personnage AND id_batiment = p_id_batiment LIMIT 1;
END //

DELIMITER ;
