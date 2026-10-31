-- Étape 2 : création des quatre tables
-- Les contraintes PK/FK/UNIQUE/CHECK sont ajoutées dans 03_constraints.sql.

USE bibliotheque;

CREATE TABLE IF NOT EXISTS auteur (
    id INT NOT NULL AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ouvrage (
    id INT NOT NULL AUTO_INCREMENT,
    titre VARCHAR(200) NOT NULL,
    isbn CHAR(13) NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    auteur_id INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS abonne (
    id INT NOT NULL AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    date_inscription DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS emprunt (
    ouvrage_id INT NOT NULL,
    abonne_id INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NULL,
    PRIMARY KEY (ouvrage_id, abonne_id, date_debut)
) ENGINE = InnoDB;
