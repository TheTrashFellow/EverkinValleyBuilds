DELIMITER //

CREATE PROCEDURE CreerUtilisateur(
    IN p_courriel VARCHAR(64),
    IN p_password VARCHAR(128),
    IN p_nomPerso VARCHAR(16)
)
BEGIN
    IF EXISTS (SELECT 1 FROM utilisateurs WHERE nom_utilisateur = p_courriel) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Ce courriel est déjà en utilisation';
    ELSEIF EXISTS (SELECT 1 FROM personnages WHERE nom_personnage = p_nomPerso) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ce nom de personnage est déjà en utilisation';
    ELSE
--      DECLARE village VARCHAR(128);
--	DECLARE id_perso INT;

--      SET village = CONCAT('Village de ', p_nomPerso);

        INSERT INTO personnages (niveau_hache, niveau_pioche, nom_village, dernier_x, dernier_y, dernier_z, derniere_rotation_y, village_dernier_x, village_dernier_y, village_dernier_z, nom_personnage)
        VALUES (1, 1, CONCAT('Village de ', p_nomPerso), 0, 0, 0, 0, 0, 0, 0, p_nomPerso);

--      SET id_perso = (SELECT id_personnage FROM personnages WHERE nom_personnage = p_nomPerso LIMIT 1);

        INSERT INTO utilisateurs (nom_utilisateur, mot_de_passe, id_personnage)
        VALUES (p_courriel, p_password, (SELECT id_personnage FROM personnages WHERE nom_personnage = p_nomPerso));
    END IF;
END //
DELIMITER ;
