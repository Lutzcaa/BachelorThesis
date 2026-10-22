elem(X) :- node(X).
comp(X, lab(L))  :- label(X,L).
comp(X, prop(K)) :- val(X,K,_).
compat(X, blank) :- elem(X).
compat(X, label(L))  :- label(X,L).
compat(X, prop(K,D)) :- val(X,K,D).

usable(X, G, A) :- opt(G, A), compat(X, A).
hasusable(X, G) :- usable(X, G, _).
dead(X, Y) :- alt(_, Y), elem(X), conj(Y, G), not hasusable(X, G).
cand(X, Y) :- alt(_, Y), elem(X), not dead(X, Y).

1 { pick(X, Y, G,A) : usable(X, G, A) } 1 :- cand(X, Y), conj(Y, G).

covers(label(L), lab(L)) :- opt(_, label(L)).
covers(prop(K,D), prop(K)) :- opt(_, prop(K, D)).

covered(X, Y, C) :- comp(X, C), pick(X, Y, _, A), covers(A,C).
fail(X, Y) :- cand(X,Y), comp(X, C), not covered(X, Y, C).
conf(X,T) :- alt(T, Y), cand(X, Y), not fail(X, Y).

#show conf/2.