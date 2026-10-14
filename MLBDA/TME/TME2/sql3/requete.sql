-- compléter l'entête 
-- ==================

-- NOM    :
-- Prénom :

-- NOM    :
-- Prénom :

-- Groupe :
-- binome :

-- ================================================
-- R1.	Quel est le nom et le prix au kilo des matières ?
prompt 'R1:'
SELECT nom, prix_kilo
FROM LesMatiers;


-- R2.	Quel est le nom des matières dont le prix au kilo est inférieur à 5 EUR ?
prompt 'R2:'
SELECT nom
FROM LesMatiers
WHERE prix_kilo<5;

-- R3.	Quelles sont les pièces de base en bois ?
prompt 'R3:'
SELECT *
FROM LesPiecesBase p
WHERE p.mat.nom = 'bois';

-- R4.	Quel est le nom des matières dont le libellé contient "fer" ?
prompt 'R4:'
SELECT nom
FROM LesMatiers
WHERE nom LIKE 'fer%';

-- R5.	Donner le nom des pièces de base formant la pièce nommée 'billard'
prompt 'R5:'
SELECT p.nom
FROM LesPiecesBase p
WHERE REF(p) IN (
  SELECT c.piece_concernee
  FROM LesPiecesCompo pc, table (pc.contenance) c
  WHERE pc.nom = 'billard'
);

-- R6.	Donner le nom de chaque matière avec son nombre de pièces de bases.
prompt 'R6:'


-- R7.	Quelles sont les matières pour lesquelles il existe au moins 3 pièces de base ?
prompt 'R7:'


