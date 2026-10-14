/* --- FAITS CONCRETS --- */


consciencieux(pascal).
consciencieux(zoe).

/* --- RÈGLES ---*/
/* Quelqu'un révise Y si c'est un étudiant sérieux et qu'il y a un examen Y */
revise(X) :- serieux(X).

/* Quelqu'un fait ses devoirs s'il est consciencieux, étudiant et qu'il y a un devoir*/
faitdevoir(X) :- consciencieux(X).


/* Un étudiant réussit s'il révise pour un examen */
reuissi(X) :- revise(X).


/* Un étudiant est sérieux s'il fait un devoir*/
serieux(X) :- faitdevoir(X).



/*etudiant(pascal).
etudiant(zoe).*/
/*, etudiant(X).*/