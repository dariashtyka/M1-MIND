et(0,0,0).
et(0,1,0).
et(1,0,0).
et(1,1,1).

ou(0,0,0).
ou(0,1,1).
ou(1,0,1).
ou(1,1,1).

non(0,1).
non(1,0).

/*

58 ?- et(X,Y,1).
X = Y, Y = 1.

59 ?- et(0,0,R).
R = 0.

60 ?- et(X,Y,R).
X = Y, Y = R, R = 0 ;
X = R, R = 0,
Y = 1 ;
X = 1,
Y = R, R = 0 ;
X = Y, Y = R, R = 1.

*/


/*circuit(X,Y,Z) :- et(X,Y,R), ou(R, X, Z).*/
circuit(X,Y,Z) :- non(X, N), et(X,Y,F), non(F,G), et(G,N,T), et(X,Y,R), et(R, X, K), ou(T,K, Z).
/*circuit(X,Y,Z) :- et(X,Y,R), et(R, X, Z).*/

/*
66 ?- circuit(X,Y,Z).
X = Y, Y = 0,
Z = 1 ;
X = 0,
Y = Z, Z = 1 ;
X = 1,
Y = Z, Z = 0 ;
X = Y, Y = Z, Z = 1.


faux implique vrai/faux c'est vrai
67 ?- circuit(0,Y,Z).
Y = 0,
Z = 1 ;
Y = Z, Z = 1.

vrai implique faux c'est faux
68 ?- circuit(1,Y,Z).
Y = Z, Z = 0 ;

vrai implique vrai c'est vrai
Y = Z, Z = 1.

69 ?- circuit(X,Y,0).
X = 1,
Y = 0 ;
false.

*/