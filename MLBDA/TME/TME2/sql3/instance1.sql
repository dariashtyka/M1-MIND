-- compléter l'entête 
-- ==================

-- NOM    :
-- Prénom :

-- NOM    :
-- Prénom :

-- Groupe :
-- binome :

-- ================================================

-- stockage des données : définition des relations
-- ====================

-- On an besoin de:
-- R1, R2 LesMatieres
-- R3 pieces
create table LesMatiers of Matieres;
create table LesPiecesBase of Piece_Base;
create table LesPiecesCompo of Piece_Composite
  nested table ;
-- faire des tables pour tous les sous -types : paas bien pour avoir toutes les pieces en bois par exemple (Matiere, CUbe, Cylindre ....)
-- faire des tables pour (Matiere, Piece) pas bien pour la R3
-- le mieux faire comme j'ai fait
-- à l'examen il faut savoir créer les types faire des requetes 
-- instanciation des objets
-- ========================
