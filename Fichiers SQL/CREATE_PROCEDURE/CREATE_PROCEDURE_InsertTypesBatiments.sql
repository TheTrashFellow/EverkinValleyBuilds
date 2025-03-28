DELIMITER //

CREATE PROCEDURE InsertTypesBatiments(
    IN p_nom_batiment VARCHAR(64),
    IN p_amelioration VARCHAR(128) 
)
BEGIN
    
    IF EXISTS (SELECT 1 FROM types_batiments WHERE nom_batiment = p_nom_batiment) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ce batiment existe déjà';  
    ELSE
        
        INSERT INTO types_batiments (nom_batiment, amelioration)
        VALUES (p_nom_batiment, p_amelioration);
    END IF;
END //

DELIMITER ;
