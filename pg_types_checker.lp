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

% -----------------------------------------------------------------------------------
% 1. Components: every label and every property key of a node
% -----------------------------------------------------------------------------------
comp(X, lab(L))  :- node(X), label(X, L).
comp(X, prop(K)) :- node(X), val(X, K, _).

% -----------------------------------------------------------------------------------
% DAG helpers
% -----------------------------------------------------------------------------------
% successors: children, or the root of a referenced type
succ(N, M) :- child(N, M).
succ(N, R) :- ref(N, T), root(T, R).

% inner nodes (everything that is not a leaf)
inner(N) :- and(N). inner(N) :- or(N). inner(N) :- ref(N, _).

% -----------------------------------------------------------------------------------
% 2. Pruning: compat(X, N) = element X can match the sub-DAG below N
% -----------------------------------------------------------------------------------
% leaves
compat(X, N) :- atom(N, label(L)), elem(X), label(X, L).
compat(X, N) :- atom(N, prop(K, D)), elem(X), val(X, K, D).
compat(X, N) :- atom(N, blank), elem(X).
compat(X, N) :- atom(N, labelopen), elem(X).
compat(X, N) :- atom(N, propopen), elem(X).

% or: at least one child is compatible
compat(X, N) :- or(N), child(N, C), compat(X, C).

% and: no child is incompatible
compat(X, N) :- and(N), elem(X), not failchild(X, N).
failchild(X, N) :- and(N), child(N, C), elem(X), not compat(X, C).

% ref: compatible if the referenced type's root is compatible
compat(X, N) :- ref(N, T), root(T, R), compat(X, R).

% candidate types: the root is compatible
cand(X, T) :- node(X), nodeType(T), root(T, R), compat(X, R).

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

% a component ends at a leaf that does not describe it
fail(X, T) :- on(X, T, C, N), not inner(N), not covers(N, C).

% two components take different branches at the same or-node
fail(X, T) :- or(O), next(X, T, C1, O, M1), next(X, T, C2, O, M2), M1 != M2.

% -----------------------------------------------------------------------------------
% 5. Typing: X conforms to T if some choice of paths does not fail
% -----------------------------------------------------------------------------------
conf(X, T) :- cand(X, T), not fail(X, T).

#show conf/2.