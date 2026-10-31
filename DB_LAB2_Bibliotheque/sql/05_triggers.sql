-- Étape 5 : triggers de gestion des emprunts et des retours
USE bibliotheque;

DROP TRIGGER IF EXISTS trg_emprunt_before_insert;
DROP TRIGGER IF EXISTS trg_emprunt_after_update;

DELIMITER $$

-- Avant chaque nouvel emprunt :
-- 1) verrouiller et vérifier l'ouvrage ;
-- 2) refuser si l'ouvrage n'existe pas ou n'est pas disponible ;
-- 3) marquer l'ouvrage comme indisponible.
CREATE TRIGGER trg_emprunt_before_insert
BEFORE INSERT ON emprunt
FOR EACH ROW
BEGIN
    DECLARE v_disponible BOOLEAN DEFAULT NULL;

    SELECT disponible
      INTO v_disponible
      FROM ouvrage
     WHERE id = NEW.ouvrage_id
     FOR UPDATE;

    IF v_disponible IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Emprunt refuse : ouvrage inexistant.';
    ELSEIF v_disponible = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Emprunt refuse : ouvrage non disponible.';
    ELSE
        UPDATE ouvrage
           SET disponible = FALSE
         WHERE id = NEW.ouvrage_id;
    END IF;
END$$

-- Lorsqu'un emprunt est clôturé (date_fin devient non NULL),
-- remettre l'ouvrage à disposition.
CREATE TRIGGER trg_emprunt_after_update
AFTER UPDATE ON emprunt
FOR EACH ROW
BEGIN
    IF OLD.date_fin IS NULL AND NEW.date_fin IS NOT NULL THEN
        UPDATE ouvrage
           SET disponible = TRUE
         WHERE id = NEW.ouvrage_id;
    END IF;
END$$

DELIMITER ;

-- Vérification
SHOW TRIGGERS;
