-- Étape 4 : index demandés par le laboratoire
USE bibliotheque;

CREATE INDEX idx_ouvrage_disponible
    ON ouvrage(disponible);

CREATE INDEX idx_emprunt_date_fin
    ON emprunt(date_fin);

-- Vérification
SHOW INDEX FROM ouvrage;
SHOW INDEX FROM emprunt;
