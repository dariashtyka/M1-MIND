set sqlbl on


-- EXERCICE CAO


-- SCHEMA avec heritage

-- vider le compte oracle pour tjrs repartir du meme etat initial 
--@vider
DROP type T_Matiere force;
DROP type T_Piece force;
DROP type T_Piece_Composite force;
DROP type T_entre_dans force;
DROP type T_entre_dans_plusieurs force;
DROP type T_contient force;
DROP type T_contient_plusieurs force;
DROP type T_Piece_base force;
DROP type T_Cube force;
DROP type T_Cube force;
DROP type T_Cylindre force;
DROP type T_Paral force;


-- Définition des types de données

-- Matiere

create type T_Matiere as object (
	nom varchar2(30),
	prix_au_kilo number,
	masse_volumique number
);
-- compiler chaque définition de type
/


-- un type utilisé avant d'être défini doit être pré-déclaré
create type T_Piece;
/

create type T_Piece_Composite;
/


-- L'association ENTRE_DANS : une piece (de base ou composite) ENTRE_DANS la fabrication d'une ou plusieurs pieces composites,
-- en précisant la quantité de composants nécessaire pour fabriquer la pièce composite.

create type T_entre_dans as object (
	quoi      ref T_Piece_Composite,
	quantite  number
);
/
show error


-- cardinalité de l'association : 1-N
create type T_entre_dans_plusieurs as table of T_entre_dans;
/
show error


-- L'association contient : une piece composite CONTIENT des pieces (de base ou composite),
-- en précisant la quantité contenue.

create type T_contient as object (
	quoi      ref T_Piece,
	quantite  number
);
/

-- cardinalité de l'association : 1-N
create type T_contient_plusieurs as table of T_Contient;
/


-- PIECE 
-- est une sur-classe de Piece_base et Piece_Composite

prompt T_Piece

create type T_Piece as object (
	nom         varchar2(30),
        entre_dans  T_entre_dans_plusieurs
) not final;
/


-- PIECE de BASE
prompt T_Piece_base

create type T_Piece_base under T_Piece (
	est_en ref   T_Matiere
) not final;
/

-- Les pièces de base réelles : cube, sphere et cylindre

prompt T_Cube

create type T_Cube under T_Piece_base (
	cote        number
);
/

prompt T_Sphere

create type T_Sphere under T_Piece_base (
	rayon        number
);
/

prompt T_Cylindre

create type T_Cylindre under T_Piece_base (
	diametre        number,
        hauteur         number
);
/

-- un parallélépipède rectangle
prompt T_Paral
create type T_Paral under T_Piece_base (
	hauteur        number,
        largeur        number,
        profondeur     number
);
/


-- PIECE COMPOSITE
prompt T_Piece_Composite 

create type T_Piece_composite under T_Piece(
 	cout_assemblage  number,
 	contient_pieces  T_contient_plusieurs
);
/


