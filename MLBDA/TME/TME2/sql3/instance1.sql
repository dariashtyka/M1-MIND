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

drop table LesMatiers force;
drop table LesPiecesBase force;
drop table LesPiecesCompo force;

create table LesMatiers of Matiere;
create table LesPiecesBase of Piece_Base
nested table entre_dans store as T2;
create table LesPiecesCompo of Piece_Composite
  nested table contenance store as T1, 
  nested table entre_dans store as T3;
-- faire des tables pour tous les sous -types : paas bien pour avoir toutes les pieces en bois par exemple (Matiere, CUbe, Cylindre ....)
-- faire des tables pour (Matiere, Piece) pas bien pour la R3
-- le mieux faire comme j'ai fait
-- à l'examen il faut savoir créer les types faire des requetes 
-- instanciation des objets
-- ========================
insert into LesMatiers VALUES (Matiere('bois', 10, 2));
INSERT INTO LesMatiers VALUES (Matiere('fer', 5, 3));
INSERT INTO LesMatiers VALUES (Matiere('ferrite', 6, 10));

insert into LesPiecesBase VALUES (
Cylindre( 
-- Piece (nom, entre dans)
'canne', NULL , 
-- Piece Base (ref de matiere m1)
  (SELECT REF(m)
  FROM LesMatiers m 
  WHERE m.nom = 'bois'),
-- Cylindre (diametre, hauteur)
2, 30 ));

-- Sphère : 'pied', (30), bois
INSERT INTO LesPiecesBase VALUES (
  Sphere(
    -- Piece (nom, entre dans)
    'pied', NULL,
    -- Piece Base (ref de matière)
    (SELECT REF(m)
     FROM LesMatiers m
     WHERE m.nom = 'bois'),
    -- Sphere (rayon)
    30
  )
);


-- Parallélépipède : 'plateau', (1, 100, 80), bois
INSERT INTO LesPiecesBase VALUES (
  Parallelepipede(
    -- Piece (nom, entre dans)
    'plateau', NULL,
    -- Piece Base (ref de matière)
    (SELECT REF(m)
     FROM LesMatiers m
     WHERE m.nom = 'bois'),
    -- Parallélépipède (épaisseur, longueur, largeur)
    1, 100, 80
  )
);


-- Cylindre : 'clou', (1, 20), fer
INSERT INTO LesPiecesBase VALUES (
  Cylindre(
    -- Piece (nom, entre dans)
    'clou', NULL,
    -- Piece Base (ref de matière)
    (SELECT REF(m)
     FROM LesMatiers m
     WHERE m.nom = 'fer'),
    -- Cylindre (diamètre, hauteur)
    1, 20
  )
);


-- Sphère : 'boule', (30), fer
INSERT INTO LesPiecesBase VALUES (
  Sphere(
    -- Piece (nom, entre dans)
    'boule', NULL,
    -- Piece Base (ref de matière)
    (SELECT REF(m)
     FROM LesMatiers m
     WHERE m.nom = 'fer'),
    -- Sphere (rayon)
    30
  )
);


-- Cylindre : 'aimant', (2, 5), ferrite
INSERT INTO LesPiecesBase VALUES (
  Cylindre(
    -- Piece (nom, entre dans)
    'aimant', NULL,
    -- Piece Base (ref de matière)
    (SELECT REF(m)
     FROM LesMatiers m
     WHERE m.nom = 'ferrite'),
    -- Cylindre (diamètre, hauteur)
    2, 5
  )
);

-- pour voir ou partent les valeurs propres à Cylindre, Sphere etc ... (il sont pas perdu dans BD
-- SELECT p.nom,
--        TREAT(VALUE(p) AS Cylindre).diametre,
--        TREAT(VALUE(p) AS Cylindre).hauteur
-- FROM LesPiecesBase p
-- WHERE VALUE(p) IS OF (Cylindre);

INSERT INTO LesPiecesCompo VALUES (
-- Piece (nom, entre dans ) ATTENTION à modifier après les pieces d'avant
'table', NULL, 

-- PieceCompo (cout_ass, contenance EnsQuantite)
100,
      -- avec Quantite (piece_concernee ref Piece, nombre)
    EnsQuantite(
      Quantite(
        (SELECT REF(p)
        FROM LesPiecesBase p
        WHERE p.nom = 'plateau'
        ), 1
      ),
       Quantite(
        (SELECT REF(p)
        FROM LesPiecesBase p
        WHERE p.nom = 'pied'
        ), 4
      ),
       Quantite(
        (SELECT REF(p)
        FROM LesPiecesBase p
        WHERE p.nom = 'clou'
        ), 12
      )
    )
      
);
-- modifs des pieces d'avant
-- UPDATE Table ( SELECT p.entre_dans
--               FROM LesPiecesBase p 
--               where p.nom = 'plateau') p_entre_dans -- FAUX
UPDATE LesPiecesBase p
SET p.entre_dans = T_entre_dans_plusieurs (
  T_entre_dans(
    -- ref de PieceCompo
    (SELECT REF(p)
    FROM LesPiecesCompo p
    WHERE p.nom = 'table'
    ),
    -- Number
    1
  )
)
WHERE p.nom = 'plateau'
;
UPDATE LesPiecesBase p
SET p.entre_dans = T_entre_dans_plusieurs (
  T_entre_dans(
    -- ref de PieceCompo
    (SELECT REF(p)
    FROM LesPiecesCompo p
    WHERE p.nom = 'table'
    ),
    -- Number
    4
  )
)
WHERE p.nom = 'pied'
;

UPDATE LesPiecesBase p
SET p.entre_dans = T_entre_dans_plusieurs (
  T_entre_dans(
    -- ref de PieceCompo
    (SELECT REF(p)
    FROM LesPiecesCompo p
    WHERE p.nom = 'table'
    ),
    -- Number
    12
  )
)
WHERE p.nom = 'clou'
;

DELETE FROM LesPiecesCompo
WHERE nom = 'billard';
COMMIT;

INSERT INTO LesPiecesCompo VALUES (
-- Piece (nom, entre dans ) ATTENTION à modifier après les pieces d'avant
'billard', NULL, 

-- PieceCompo (cout_ass, contenance EnsQuantite)
10,
      -- avec Quantite (piece_concernee ref Piece, nombre)
    EnsQuantite(
      Quantite(
        (SELECT REF(p)
        FROM LesPiecesCompo p
        WHERE p.nom = 'table'
        ), 1
      ),
       Quantite(
        (SELECT REF(p)
        FROM LesPiecesBase p
        WHERE p.nom = 'boule'
        ), 3
      ),
       Quantite(
        (SELECT REF(p)
        FROM LesPiecesBase p
        WHERE p.nom = 'canne'
        ), 12
      )
    )
      
);



UPDATE LesPiecesCompo p
SET p.entre_dans = T_entre_dans_plusieurs (
  T_entre_dans(
    -- ref de PieceCompo
    (SELECT REF(p)
    FROM LesPiecesCompo p
    WHERE p.nom = 'billard'
    ),
    -- Number
    1
  )
)
WHERE p.nom = 'table'
;

UPDATE LesPiecesBase p
SET p.entre_dans = T_entre_dans_plusieurs (
  T_entre_dans(
    -- ref de PieceCompo
    (SELECT REF(p)
    FROM LesPiecesCompo p
    WHERE p.nom = 'billard'
    ),
    -- Number
    3
  )
)
WHERE p.nom = 'boule'
;
UPDATE LesPiecesBase p
SET p.entre_dans = T_entre_dans_plusieurs (
  T_entre_dans(
    -- ref de PieceCompo
    (SELECT REF(p)
    FROM LesPiecesCompo p
    WHERE p.nom = 'billard'
    ),
    -- Number
    2
  )
)
WHERE p.nom = 'canne'
;



-- INSERT INTO TABLE
-- ( SELECT p.entre_dans
--               FROM LesPiecesBase p 
--               where p.nom = 'boule')
--  VALUES (
--   T_entre_dans(
-- -- ref de PieceCompo
--     (SELECT REF(p)
--     FROM LesPiecesCompo p
--     WHERE p.nom = 'billard'
--     ),
-- -- Number
--     1
--   )
-- )
-- ;



