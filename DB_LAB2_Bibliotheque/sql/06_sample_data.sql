-- Étape 6 : données de démonstration
-- À exécuter une seule fois sur une base fraîche.
USE bibliotheque;

INSERT INTO auteur (nom, prenom, date_naissance) VALUES
('Hugo', 'Victor', '1802-02-26'),
('Camus', 'Albert', '1913-11-07'),
('Verne', 'Jules', '1828-02-08');

INSERT INTO ouvrage (titre, isbn, disponible, auteur_id) VALUES
('Les Misérables', '9781234567890', TRUE, 1),
('L''Étranger', '9781234567891', TRUE, 2),
('Le Tour du monde en 80 jours', '9781234567892', TRUE, 3),
('Notre-Dame de Paris', '9781234567893', TRUE, 1);

INSERT INTO abonne (nom, prenom, email) VALUES
('Martin', 'Luc', 'luc.martin@example.com'),
('Dupont', 'Sara', 'sara.dupont@example.com'),
('Bernard', 'Yassine', 'yassine.bernard@example.com');

-- Emprunt de démonstration : le trigger rend l'ouvrage 1 indisponible.
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
VALUES (1, 1, CURRENT_DATE);

-- Vérification des données
SELECT * FROM auteur;
SELECT * FROM ouvrage;
SELECT * FROM abonne;
SELECT * FROM emprunt;
