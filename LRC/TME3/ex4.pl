pere(tolik,daria).
pere(shura, tolik).
pere(pasha, ira).
pere(shura, serhii).


mere(ira,daria).
mere(tanya, tolik).
mere(tanya, serhii).

parent(X, Y) :- pere(X,Y).
parent(X, Y):- mere(X,Y).
/* TEST question3 */
/*
27 ?- parent(X,daria).
X = tolik ;
X = ira.

28 ?- parent(daria, X).
false.

29 ?- parent(A,B).
A = tolik,
B = daria ;
A = ira,
B = daria.

*/

/* question 4 */
parents(X,Y,Z):-pere(X,Z), mere(Y,Z).
/* TEST question 4 */
/*
31 ?- parents(X,Y,daria).
X = tolik,
Y = ira.

32 ?- parents(X,Y,Z).
X = tolik,
Y = ira,
Z = daria.

34 ?- parents(daria,Y,Z).
false.
*/

/* question 5 */
grandpere(X,Y) :- pere(Z,Y), pere(X,Z).
frereOuSoeur(S, D) :- parents(X, Y, S), parents(X, Y, D), S\=D.
/*

36 ?- grandpere(X,daria).
X = shura ;
false.

37 ?- grandpere(X,Y).
X = shura,
Y = daria ;
false.

38 ?- grandpere(shura,Y).
Y = daria ;
false.

39 ?- grandpere(daria,Y).
false.

40 ?- frereOuSoeur(S, daria).
false.

46 ?- frereOuSoeur(F,tolik).
F = serhii ;
false.

46 ?- frereOuSoeur(F,serhii).
F = tolik ;
false.
*/

ancetre(X,Y) :- parent(X,Y).
ancetre(X,D) :- parent(X, T), ancetre(T, D).
/*ancetre(X,Y) :- grandpere(X, Y).*/
/*
51 ?- ancetre(X,daria).
X = tolik ;
X = ira ;
X = shura ;
X = pasha ;
X = tanya ;
X = shura ;
false.

52 ?- ancetre(X,Y).
X = tolik,
Y = daria ;
X = shura,
Y = tolik ;
X = pasha,
Y = ira ;
X = shura,
Y = serhii ;
X = ira,
Y = daria ;
X = tanya,
Y = tolik ;
X = tanya,
Y = serhii ;
X = shura,
Y = daria ;
X = pasha,
Y = daria ;
X = tanya,
Y = daria ;
X = shura,
Y = daria ;
false.

55 ?- ancetre(shura,Y).
Y = tolik ;
Y = serhii ;
Y = daria ;
false.

56 ?- ancetre(X,daria).
X = tolik ;
X = ira ;
X = shura ;
X = pasha ;
X = tanya ;
false.

*/