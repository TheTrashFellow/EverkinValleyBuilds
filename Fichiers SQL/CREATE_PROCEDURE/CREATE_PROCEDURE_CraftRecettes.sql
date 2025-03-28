DELIMITER //

CREATE PROCEDURE CraftRecettes(
    IN p_id_personnage INT,
    IN p_id_recette INT       
)
BEGIN    
    DECLARE idRessource INT DEFAULT 0;
    

    DECLARE amelioration VARCHAR(5) DEFAULT "null";
    DECLARE nouveauNiveau INT DEFAULT -1;
    DECLARE idBatiment INT DEFAULT 0;
    DECLARE batimentUpgrade VARCHAR(64) DEFAULT "null";

    DECLARE r_quantite INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;

    DECLARE cur CURSOR FOR
        SELECT id_ressource FROM bundles_ingredients WHERE id_recette = p_id_recette;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO idRessource;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT quantite INTO r_quantite FROM bundles_ingredients WHERE id_recette = p_id_recette AND id_ressource = idRessource;

        UPDATE personnage_ressource_inventaire SET quantite = quantite - r_quantite WHERE id_personnage = p_id_personnage AND id_ressource = idRessource;
        
    END LOOP;  

    SELECT id_batiment, a_ameliorer, nouveau_niveau INTO idBatiment, amelioration, nouveauNiveau FROM recettes WHERE id_recette = p_id_recette;

        IF (idBatiment != 0) THEN
            SELECT amelioration INTO batimentUpgrade FROM types_batiments WHERE id_batiment = idBatiment;
            INSERT INTO personnage_batiment_village(id_personnage, id_batiment) VALUES(p_id_personnage, idBatiment);

            IF BINARY TRIM(batimentUpgrade) = "+5 inventaire" THEN
            UPDATE personnage_ressource_inventaire 
            SET maximum = maximum + 5 
            WHERE id_personnage = p_id_personnage;
            ELSE
                UPDATE personnage_ressource_inventaire 
                SET maximum = maximum + 10 
                WHERE id_personnage = p_id_personnage;
            END IF;
        ELSE
            IF amelioration = 'Axe' THEN
                UPDATE personnages SET niveau_hache = nouveauNiveau WHERE id_personnage = p_id_personnage;
            ELSE
                UPDATE personnages SET niveau_pioche = nouveauNiveau WHERE id_personnage = p_id_personnage;
            END IF;
        END IF;

    CLOSE cur; 
END //
DELIMITER ;