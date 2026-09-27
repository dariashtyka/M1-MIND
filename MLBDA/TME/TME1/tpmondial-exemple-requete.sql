--NOM : 
--Prenom : 


-- les Pays
;
select *
from Country
order by name
;


-- les organisations
;
select name from Organization
order by name
;

--R10
select m.organization, COUNT(*), SUM(c.population)
from IsMember m JOIN country c ON (c.code = m.country)
GROUP BY m.organization;

--R11
select m.organization, COUNT(*) as nb, SUM(c.population)
from IsMember m JOIN country c ON (c.code = m.country)
GROUP BY m.organization
HAVING nb >100; -- ça marche avec > mais mieux faire COUNT(*)

--12. Les pays d'Amérique avec leur plus haute montagne
SELECT c.name, m.name
FROM encompasses e, geo_mountain g, mountain m, country c 
WHERE (e.continent = 'America' AND g.country = e.country AND m.name= g.mountain)
  AND m.height = (
  SELECT MAX(m1.height)
  FROM mountain m1 JOIN geo_mountain g1 ON(g1.mountain = m1.name )
  WHERE g1.country = c.code);
-- GROUP BY c.code; -- pas de group by car pas besoin on a qu'une ligne

--13. Les affluents directs du Nil : tous les fleuves qui se jettent dans le Nil.
SELECT name
FROM river
WHERE river = 'Nile';

--14. Tous les affluents du Nil : ceux qui s'écoulent directement ou indirectement dans le Nil. Remarque : les affluents des affluents des affluents du Nil n'ont aucun affluent.
SELECT name
FROM river
WHERE river = 'Nile'
  UNION 
SELECT r1.name 
FROM river r1, river r2
WHERE r1.river = r2.name AND r2.river ='Nile'
  UNION 
 SELECT r1.name 
FROM river r1, river r2, river r3
WHERE r1.river = r2.name AND r2.river =r3.name and r3.river = 'Nile';

-- 15. La longueur totale des cours d'eau alimentant le Nil, Nil inclus.
-- SELECT SUM(r.length)
-- FROM river r
-- WHERE r.river = 'Nile'
--   UNION 
-- SELECT SUM(r1.length)
-- FROM river r1, river r2
-- WHERE r1.river = r2.name AND r2.river ='Nile'
--   UNION 
--  SELECT SUM(r1.length)
-- FROM river r1, river r2, river r3
-- WHERE r1.river = r2.name AND r2.river =r3.name and r3.river = 'Nile';
SELECT SUM(r.length) + 

(SELECT SUM(r1.length)
FROM river r1, river r2
WHERE r1.river = r2.name AND r2.river ='Nile') 
-- + 
-- 
-- (SELECT SUM(r1.length)
-- FROM river r1, river r2, river r3
-- WHERE r1.river = r2.name AND r2.river =r3.name and r3.river = 'Nile')
as s
FROM river r
WHERE r.river = 'Nile';

-- 16. a) La plus grande organisation en termes de nombre pays membre
select m.organization, COUNT(*)as nb_membres, SUM(c.population)
from IsMember m JOIN country c ON (c.code = m.country)
GROUP BY m.organization
HAVING nb_membres>= ALL (SELECT COUNT(*) as nb_membres
from IsMember m JOIN country c ON (c.code = m.country)
GROUP BY m.organization
);
-- GROUP BY m.organization
-- HAVING nb_membres = (SELECT MAX(nb_membres)
-- from IsMember m JOIN country c ON (c.code = m.country)
-- GROUP BY m.organization
-- );

-- 16. b) Les 3 plus grandes organisations en termes de nombre pays membre
select m.organization, COUNT(*)as nb_membres, SUM(c.population)
from IsMember m JOIN country c ON (c.code = m.country)
GROUP BY m.organization
ORDER BY nb_membres DESC
LIMIT 3;

-- 17. La densité de population (exprimée en nombre d'habitants par km2) de la zone formée de l'Algérie et la Lybie ainsi que de tous leurs voisins directs.
SELECT c.name, SUM(c.population) / SUM(c.area)
  FROM country c JOIN borders b ON (b.country1 = c.code OR b.country2 = c.code)
  WHERE c.name = 'Algeria' OR c.name = 'Libya'
  GROUP BY c.name;
