-- Étape 7 : tests de cohérence
-- IMPORTANT :
-- 1) Exécuter d'abord les requêtes positives.
-- 2) Les commandes négatives sont commentées : les décommenter et les lancer
--    individuellement pour constater l'erreur attendue.
USE bibliotheque;

-- TEST POSITIF A : consulter l'état des ouvrages
SELECT id, titre, disponible FROM ouvrage ORDER BY id;

-- TEST POSITIF B : consulter les emprunts actifs
SELECT e.ouvrage_id, o.titre, e.abonne_id, e.date_debut, e.date_fin
FROM emprunt AS e
JOIN ouvrage AS o ON o.id = e.ouvrage_id
WHERE e.date_fin IS NULL;

-- TEST POSITIF C : emprunter un ouvrage disponible (ouvrage 2)
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
VALUES (2, 2, CURRENT_DATE);

-- Vérifier que l'ouvrage 2 est maintenant indisponible
SELECT id, titre, disponible
FROM ouvrage
WHERE id = 2;

-- TEST POSITIF D : rendre l'ouvrage 2
UPDATE emprunt
SET date_fin = CURRENT_DATE
WHERE ouvrage_id = 2
  AND abonne_id = 2
  AND date_debut = CURRENT_DATE
  AND date_fin IS NULL;

-- Vérifier que l'ouvrage 2 est de nouveau disponible
SELECT id, titre, disponible
FROM ouvrage
WHERE id = 2;

-- TEST NÉGATIF 1 : email dupliqué.
-- Décommenter et exécuter SEUL : doit échouer avec l'erreur 1062.
-- INSERT INTO abonne (nom, prenom, email)
-- VALUES ('Dupont', 'Jean', 'luc.martin@example.com');

-- TEST NÉGATIF 2 : date de fin antérieure à la date de début.
-- Décommenter et exécuter SEUL : doit échouer avec l'erreur 3819
-- (sur une version MySQL qui applique les CHECK).
-- INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut, date_fin)
-- VALUES (3, 1, '2024-10-01', '2024-09-30');

-- TEST NÉGATIF 3 : emprunter un ouvrage déjà indisponible (ouvrage 1).
-- Décommenter et exécuter SEUL : doit être refusé par le trigger.
-- INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
-- VALUES (1, 2, CURRENT_DATE);

-- Vérification finale
SHOW TRIGGERS;
SHOW INDEX FROM ouvrage;
SHOW INDEX FROM emprunt;
