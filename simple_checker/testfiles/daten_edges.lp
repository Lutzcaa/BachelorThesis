% =====================================================================
% daten_edges.lp  –  Kanten zwischen den Knoten aus daten.lp
%   edge(E,S,T): Kante E geht von Quelle S zu Ziel T
%   Labels und Properties von Kanten genau wie bei Knoten:
%   label(E,L), val(E,K,D)
% =====================================================================
% e1: u3 (Person) arbeitet bei u2 (Company), mit since          -> soll passen
edge(e1,u3,u2). label(e1,"WorksAt"). val(e1,since,date).
% e2: wie e1, aber die Quelle u4 hat die Property x zu viel        -> nicht
edge(e2,u4,u2). label(e2,"WorksAt"). val(e2,since,date).
% e3: wie e1, aber ohne since                                      -> nicht
edge(e3,u3,u2). label(e3,"WorksAt").
% e4: wie e1, aber die Kante hat ein Label zu viel                 -> nicht
edge(e4,u3,u2). label(e4,"WorksAt"). label(e4,"Remote"). val(e4,since,date).
% e5: falsche Richtung, von der Firma zur Person                   -> nicht
edge(e5,u2,u3). label(e5,"WorksAt"). val(e5,since,date).
