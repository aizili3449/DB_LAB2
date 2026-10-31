-- Étape 3 : contraintes d'intégrité
USE bibliotheque;

-- AUTEUR
ALTER TABLE auteur
    ADD CONSTRAINT chk_auteur_nom
    CHECK (LENGTH(nom) > 0);

-- OUVRAGE
ALTER TABLE ouvrage
    ADD CONSTRAINT uq_ouvrage_isbn UNIQUE (isbn),
    ADD CONSTRAINT chk_ouvrage_isbn
    CHECK (isbn REGEXP '^[0-9]{13}$'),
    ADD CONSTRAINT fk_ouvrage_auteur
    FOREIGN KEY (auteur_id) REFERENCES auteur(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

-- ABONNE
ALTER TABLE abonne
    ADD CONSTRAINT uq_abonne_email UNIQUE (email),
    ADD CONSTRAINT chk_abonne_email
    CHECK (email LIKE '%@%.%');

-- EMPRUNT
ALTER TABLE emprunt
    ADD CONSTRAINT fk_emprunt_ouvrage
    FOREIGN KEY (ouvrage_id) REFERENCES ouvrage(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    ADD CONSTRAINT fk_emprunt_abonne
    FOREIGN KEY (abonne_id) REFERENCES abonne(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    ADD CONSTRAINT chk_dates
    CHECK (date_fin IS NULL OR date_fin >= date_debut);
