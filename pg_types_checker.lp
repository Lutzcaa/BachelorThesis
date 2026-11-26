% ========================================================================================
% PG-Types conformance checker (general, V1)
% ----------------------------------------------------------------------------------------
% Checks the nodes of a property graph against the node types of a PG-Schema graph type and
% computes a possible typing: every pair (node, type) such that the node conforms to the type.
%
% Version: 12.11.2026
% Author:  Luca Bauer
%
% Input:
%  - Graph data (a property graph in clingo format):
%       node(id). label(id, L). val(id, K, D).
%  - A schema, one DAG per type:
%    - for nodes:
%       nodeType(tName).
%       root(tName, dagId).
%       and(dagId). or(dagId). child(dagId, dagId).
%       atom(dagId, label(L)). atom(dagId, prop(K, D)).
%       atom(dagId, blank). atom(dagId, labelopen). atom(dagId, propopen).
%       ref(dagId, tName).
%    - for edges: WIP
%
% Known limitation: the or-node check is only correct if no or-node is
% reached twice by the same element (shared references, e.g. ab = s & s).
% ========================================================================================

% elements to be typed (later also edges)
elem(X) :- node(X).
elem(X) :- edge(X).

fits(X, T) :- node(X), nodeType(T).
fits(X, T) :- edge(X), edgeType(T).

% -----------------------------------------------------------------------------------
% 1. Components: every label and every property key of a node
% -----------------------------------------------------------------------------------
comp(X, lab(L))  :- node(X), label(X, L).
comp(X, prop(K)) :- node(X), val(X, K, _).

comp(E, pos(P, lab(L))) :- edge(E), at(E, P, X), label(X, L).
comp(E, pos(P, prop(K))) :- edge(E), at(E, P, X), val(X, K, _).

% -----------------------------------------------------------------------------------
% DAG helpers
% -----------------------------------------------------------------------------------
% successors: children, or the root of a referenced type
succ(N, M) :- child(N, M).
succ(N, R) :- ref(N, T), root(T, R).

% inner nodes (everything that is not a leaf)
inner(N) :- and(N). inner(N) :- or(N). inner(N) :- ref(N, _).

% positions in edge types
at(E, src, Z) :- src(E, Z).
at(E, edge, E) :- edge(E).
at(E, tgt, Z) :- tgt(E, Z).

% Copy node type references from edge types to positioned node type copies

copy(P, R) :- ref(_, T, P), root(T, R).
copy(P, M) :- copy(P, R), child(R, M).
copy(P, M) :- copy(P, R), ref(R, T), root(T, M).

and(cp(P, N)) :- copy(P, N), and(N).
or(cp(P, N)) :- copy(P, N), or(N).
child(cp(P, N1), cp(P, N2)) :- copy(P, N1), copy(P, N2), child(N1, N2). 
atom(cp(P,N), pos(P, label(L))) :- copy(P, N), atom(N, label(L)).
atom(cp(P, N), pos(P, prop(K, D))) :- copy(P, N), atom(N, prop(K, D)).
atom(cp(P, N), blank) :- copy(P, N), atom(N, blank).
root(T, R) :- copy(P, R), root(T, R).
and(N) :- ref(N, _, _).
child(N, cp(P, R)) :- ref(N, T, P), root(T, R).
and(cp(P, N)) :- copy(P, N), ref(N, _).
child(cp(P, N), cp(P, R)) :- copy(P, N), ref(N, T), root(T, R).

%#show and/1. #show child/2. #show atom/2.

% -----------------------------------------------------------------------------------
% 2. Pruning: compat(X, N) = element X can match the sub-DAG below N
% -----------------------------------------------------------------------------------
compat(X, N) :- atom(N, label(L)), elem(X), label(X, L).
compat(X, N) :- atom(N, prop(K, D)), elem(X), val(X, K, D).
compat(X, N) :- atom(N, blank), elem(X).
compat(X, N) :- atom(N, labelopen), elem(X).
compat(X, N) :- atom(N, propopen), elem(X).

compat(X, N):- atom(N, pos(P, label(L))), at(X, P, Y), label(Y, L).
compat(X, N):- atom(N, pos(P, prop(K, D))), at(X, P, Y), val(Y, K, D).


% or: at least one child is compatible
compat(X, N) :- or(N), child(N, C), compat(X, C).

% and: no child is incompatible
compat(X, N) :- and(N), elem(X), not failchild(X, N).
failchild(X, N) :- and(N), child(N, C), elem(X), not compat(X, C).

% ref: compatible if the referenced type's root is compatible
compat(X, N) :- ref(N, T), root(T, R), compat(X, R).

% candidate types: the root is compatible
cand(X, T) :- fits(X, T), root(T, R), compat(X, R).

% -----------------------------------------------------------------------------------
% 3. Choice: every component walks one path from the root to a leaf
% -----------------------------------------------------------------------------------
% start: every component is at the root
on(X, T, C, R) :- cand(X, T), comp(X, C), root(T, R).

% at every inner node, pick exactly one compatible successor
1 { next(X, T, C, N, M) : succ(N, M), compat(X, M) } 1 :- on(X, T, C, N), inner(N).

% move the component to the chosen successor
on(X, T, C, M) :- on(X, T, C, N), next(X, T, C, N, M).

% -----------------------------------------------------------------------------------
% 4. Coverage: which component a leaf can describe
% -----------------------------------------------------------------------------------
covers(N, lab(L))  :- atom(N, label(L)).
covers(N, prop(K)) :- atom(N, prop(K, _)).
covers(N, lab(L))  :- atom(N, labelopen), label(_, L).   % OPEN: any label
covers(N, prop(K)) :- atom(N, propopen), val(_, K, _).   % OPEN: any property

covers(N, pos(P, lab(L))) :- atom(N, pos(P, label(L))).
covers(N, pos(P, prop(K))) :- atom(N, pos(P, prop(K, _))).

% a component ends at a leaf that does not describe it
fail(X, T) :- on(X, T, C, N), not inner(N), not covers(N, C).

% two components take different branches at the same or-node
fail(X, T) :- or(O), next(X, T, C1, O, M1), next(X, T, C2, O, M2), M1 != M2.

% -----------------------------------------------------------------------------------
% 5. Typing: X conforms to T if some choice of paths does not fail
% -----------------------------------------------------------------------------------
conf(X, T) :- cand(X, T), not fail(X, T).

#show conf/2.