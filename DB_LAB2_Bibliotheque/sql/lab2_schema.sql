

CREATE DATABASE IF NOT EXISTS bibliotheque
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bibliotheque;

CREATE TABLE IF NOT EXISTS auteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NULL,
    CONSTRAINT chk_auteur_nom CHECK (LENGTH(nom) > 0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS ouvrage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    isbn CHAR(13) NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    auteur_id INT NOT NULL,

    CONSTRAINT uq_ouvrage_isbn UNIQUE (isbn),
    CONSTRAINT chk_ouvrage_isbn CHECK (isbn REGEXP '^[0-9]{13}$'),
    CONSTRAINT fk_ouvrage_auteur
        FOREIGN KEY (auteur_id) REFERENCES auteur(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS abonne (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    date_inscription DATE NOT NULL DEFAULT (CURRENT_DATE),

    CONSTRAINT uq_abonne_email UNIQUE (email),
    CONSTRAINT chk_abonne_nom CHECK (LENGTH(nom) > 0),
    CONSTRAINT chk_abonne_email CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS emprunt (
    ouvrage_id INT NOT NULL,
    abonne_id INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NULL,

    CONSTRAINT pk_emprunt
        PRIMARY KEY (ouvrage_id, abonne_id, date_debut),
    CONSTRAINT chk_emprunt_dates
        CHECK (date_fin IS NULL OR date_fin >= date_debut),
    CONSTRAINT fk_emprunt_ouvrage
        FOREIGN KEY (ouvrage_id) REFERENCES ouvrage(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_emprunt_abonne
        FOREIGN KEY (abonne_id) REFERENCES abonne(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE INDEX idx_ouvrage_disponible
    ON ouvrage(disponible);

CREATE INDEX idx_emprunt_date_fin
    ON emprunt(date_fin);


DELIMITER //

CREATE TRIGGER trg_emprunt_before_insert
BEFORE INSERT ON emprunt
FOR EACH ROW
BEGIN
    DECLARE v_disponible BOOLEAN DEFAULT FALSE;

    SELECT disponible
      INTO v_disponible
      FROM ouvrage
     WHERE id = NEW.ouvrage_id
     FOR UPDATE;

    IF v_disponible = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cet ouvrage n est pas disponible.';
    END IF;

    UPDATE ouvrage
       SET disponible = FALSE
     WHERE id = NEW.ouvrage_id;
END//

CREATE TRIGGER trg_emprunt_after_update
AFTER UPDATE ON emprunt
FOR EACH ROW
BEGIN
    IF OLD.date_fin IS NULL AND NEW.date_fin IS NOT NULL THEN
        UPDATE ouvrage
           SET disponible = TRUE
         WHERE id = NEW.ouvrage_id;
    END IF;
END//

DELIMITER ;
