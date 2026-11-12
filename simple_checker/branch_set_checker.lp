% This program checks a PG Graph against a Schema in PG Schema Format
% This Program right now only supports checking Nodes and Nodetypes
% Edges, Abstract types and &|&-instances have yet to be implemented.

% The program returns a possible typing for all nodes against the node types
% defined in the given Schema
% If a node does not fit a type, it does not get a type
% The program on its own does not check if a graph checks out against a graphtype

elem(X) :- node(X).
elem(X) :- edge(X, _, _).
fits(X, T):- node(X), nodeType(T).
fits(X, T):- edge(X, _, _), edgeType(T).

% -----------------------------------------------------------------------------------
% Components: we select everything the node has (labels and properties). Each component
% must be covered by a chosen option at the end ("may" direction). The Datatype is not needed here, so
% properties are identified by their key only.
% -----------------------------------------------------------------------------------

% Rules for nodes

comp(X, lab(L))  :- node(X), label(X,L).
comp(X, prop(K)) :- node(X), val(X,K,_).

% Rules for edges - Edges have positions that must be integrated

% --- Verbesserung für comp von edges
%at(X, src, S):- edge(X, S, _).
%at(X, edge, X):- edge(X, _, _).
%at(X, tgt, T):- edge(X, _, T).
%comp(X, pos(P, lab(L))):- at(X, P, Z), label(Z, L).
%comp(X, pos(P, prop(K))):- at(X, P, Z), val(Z, K, D).

comp(X, pos(src, lab(L))) :- edge(X, S, _), label(S, L).
comp(X, pos(src, prop(K))) :- edge(X, S, _), val(S, K, _).
comp(X, pos(edge, lab(L))) :- edge(X, _, _), label(X, L).
comp(X, pos(edge, prop(K))) :- edge(X, _, _), val(X, K, _).
comp(X, pos(tgt, lab(L))) :- edge(X, _, T), label(T, L).
comp(X, pos(tgt, prop(K))) :- edge(X, _, T), val(T, K, _).


% -----------------------------------------------------------------------------------
% Compatibility: select which schema atoms the node SATISFIES. Only these may be chosen 
% ("must" direction). blank (the empty type used for OPTIONAL) is satisfied by every node
%
% Changes in V2: Add OPEN for Labels and Properties to the compatibility layer.
% -----------------------------------------------------------------------------------
compat(X, blank) :- node(X).
compat(X, labelopen) :- node(X).
compat(X, propopen) :- node(X).
compat(X, label(L))  :- node(X), label(X,L).
compat(X, prop(K,D)) :- node(X), val(X,K,D).

% --- Verbesserung für comp von edges
%compat(X, pos(P, blank)):-at(X, P, _).
%compat(X, pos(P, labelopen)):-at(X, P, _).
%compat(X, pos(P, propopen)):-at(X, P, _).
%compat(X, pos(P, label(L))):- at(X, P, Z), label(Z, L).
%compat(X, pos(P, prop(K, D))):- at(X,P, Z), val(Z, K, D).

compat(X, pos(src, blank)) :- edge(X, S, _).
compat(X, pos(src, labelopen)) :- edge(X, S, _).
compat(X, pos(src, propopen)) :- edge(X, S, _).
compat(X, pos(src, label(L))) :- edge(X, S, _), label(S, L).
compat(X, pos(src, prop(K, D))) :- edge(X, S, _), val(S, K, D).
compat(X, pos(edge, blank)) :- edge(X, _, _).
compat(X, pos(edge, labelopen)) :- edge(X, _, _).
compat(X, pos(edge, propopen)) :- edge(X, _, _).
compat(X, pos(edge, label(L))) :- edge(X, _, _), label(X, L).
compat(X, pos(edge, prop(K, D))) :- edge(X, _, _), val(X, K, D).
compat(X, pos(tgt, blank)) :- edge(X, _, T).
compat(X, pos(tgt, labelopen)) :- edge(X, _, T).
compat(X, pos(tgt, propopen)) :- edge(X, _, T).
compat(X, pos(tgt, label(L))) :- edge(X, _, T), label(T, L).
compat(X, pos(tgt, prop(K, D))) :- edge(X, S, T), val(T, K, D).
% -----------------------------------------------------------------------------------
% Pruning: an alternative is dead for a node if one of its conjuncts has no option the
% node satisfies, i.e. something required is missing. Only the remaining alternatives 
% (candidates) are considered further
% -----------------------------------------------------------------------------------
usable(X, G, A) :- opt(G, A), compat(X, A).
hasusable(X, G) :- usable(X, G, _).
dead(X, Y) :- alt(T, Y), elem(X), fits(X, T), conj(Y, G), not hasusable(X, G).
cand(X, Y) :- alt(T, Y), elem(X), fits(X, T), not dead(X, Y).

% -----------------------------------------------------------------------------------
% Choice: for every candidate alternative, each conjucnt picks exactly one usable
% option. The solver searches over these choices.
% -----------------------------------------------------------------------------------
1 { pick(X, Y, G,A) : usable(X, G, A) } 1 :- cand(X, Y), conj(Y, G).

% -----------------------------------------------------------------------------------
% Coverage: translates a schema atom into the component it explains. 
% -----------------------------------------------------------------------------------
covers(label(L), lab(L)) :- opt(_, label(L)).
covers(prop(K,D), prop(K)) :- opt(_, prop(K, D)).
covers(labelopen, lab(L)) :- label(_, L).
covers(propopen, prop(K)) :- val(_, K, _).

covers(pos(P, A), pos(P, C)) :- covers(A, C), opt(_, pos(P, A)).
covers(label(L), lab(L)):- opt(_, pos(_, label(L))).
covers(prop(K, D), prop(K)) :- opt(_, pos(_, prop(K,D))).

% A component is covered if some chosen option explains it. The choice
% fails if a component of the node remains unexplained (it is not
% allowed by this alternative, because types are closed).
covered(X, Y, C) :- comp(X, C), pick(X, Y, _, A), covers(A,C).
fail(X, Y) :- cand(X,Y), comp(X, C), not covered(X, Y, C).

% -----------------------------------------------------------------------------------
% Typing: An element x conforms to a type t if some alternative of t survives pruning 
% and the chosen options cover all components of X. No constraint is used, so a failing
% pair does not eliminate the typing of the other pairs.
% -----------------------------------------------------------------------------------
conf(X,T) :- alt(T, Y), cand(X, Y), not fail(X, Y).

#show conf/2.