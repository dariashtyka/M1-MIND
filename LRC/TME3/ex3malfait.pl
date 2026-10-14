# etudiant(X).
etudiant(pascal).
etudiant(zoe).
# consciencieux(X).
consciencieux(pascal).
consciencieux(zoe).
# examen(Y).
# devoir(Y).
# revise(X, Y).
revise(X, Y) :- serieux(X), etudiant(X), examen(Y).
faitdevoir(X,Y) :- consciencieux(X), etudiant(X), devoir(Y).
reuissi(X).
reuissi(X) :- revise(X, Y), etudiant(X), examen(Y).
serieux(X).
serieux(X) :- etudiant(X), faitdevoir(X,Y), devoir(Y).