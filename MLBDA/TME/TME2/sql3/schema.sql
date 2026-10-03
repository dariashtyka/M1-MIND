-- compléter l'entête 
-- ==================

-- NOM    :
-- Prénom :

-- NOM    :
-- Prénom :

-- Groupe :
-- binome :

-- ================================================

-- nettoyer le compte
-- ------------------
drop type Piece force;
drop type Matiere force;
drop type Piece_Base force;
drop type Piece_Composite force;
drop type Cube force;
drop type Sphere force;
drop type Cylindre force;
drop type Parallelepipede force;
drop type Quantite force;
drop type EnsQuantite force;

-- Définition des types de données
-- -------------------------------

create type Piece as object (
 nom Varchar2(30)
) not final;
/
create type Matiere as object (
 nom Varchar2(30),
 prix_kilo Number(9),
 masse_volumique Number(10)
)
;
/
create type Piece_Base under Piece(
  mat ref Matiere
) not final;
/
create type Quantite as object(
  piece_concernee ref Piece,
  nombre Number(10)
);
/
create type EnsQuantite as table of Quantite;
/
create type Piece_Composite under Piece(
  cout_ass Number(10),
  contenance EnsQuantite
);
/
-- Idée de Charles pour contient/quantité: créer un type E {(piece1, 5), (piece2, 2) ...}


create type Cube under Piece_Base(
  cote Number(10)
);
/
create type Sphere under Piece_Base(
 rayon Number(10)
);
/
create type Cylindre under Piece_Base(
 diametre Number(10),
 hauteur Number(10)
);
/

create type Parallelepipede under Piece_Base(
 hauteur Number(10),
 largeur Number(10),
 profondeur Number(10)
);
/


show errors







-- liste de tous les types créés
@liste

