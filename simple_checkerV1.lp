% ========================================================================================
% PG-Types conformance checker (simple version, V2)
% ----------------------------------------------------------------------------------------
% Checks the nodes of a property graph against the node types of a PG-Schema graph type and
% computes a possible typing: every pair(node, type) such that the node conforms to the type
%
% Input
%   Graph:  node(X)   X is a node
%           label(X, L) node X has label L
%           val(X, K, D)  node X has property K with a value of datatype D
%   Schema: node types in three-layer form
%           alt(T, Y)      type T has alternative Y
%           conj(Y, G)     alternative Y has conjunct G
%           opt(G, A)      conjunct G has option A
%   Atoms A: 
%           label(L)   label L
%           prop(K, D)  property K of datatype D
%           blank       empty type (used for OPTIONAL properties)
%           labelopen   label wildcard (OPEN on Labels)
%           propopen    property wildcard (OPEN on properties)
%
%   Output:
%       conf(X, T)  node X conforms to type T
%       Run with --enum-mode=brave: X conforms to T as soon as SOME choice of option works. The
%       last model printed is the final typing
%              


elem(X) :- node(X).

% -----------------------------------------------------------------------------------
% Components: we select everything the node has (labels and properties). Each component
% must be covered by a chosen option at the end ("may" direction). The Datatype is not needed here, so
% properties are identified by their key only.
% -----------------------------------------------------------------------------------
comp(X, lab(L))  :- label(X,L).
comp(X, prop(K)) :- val(X,K,_).

% -----------------------------------------------------------------------------------
% Compatibility: select which schema atoms the node SATISFIES. Only these may be chosen 
% ("must" direction). blank (the empty type used for OPTIONAL) is satisfied by every node
%
% Changes in V2: Add OPEN for Labels and Properties to the compatibility layer.
% -----------------------------------------------------------------------------------
compat(X, blank) :- elem(X).
compat(X, labelopen) :- elem(X).
compat(X, propopen) :- elem(X).
compat(X, label(L))  :- label(X,L).
compat(X, prop(K,D)) :- val(X,K,D).

% -----------------------------------------------------------------------------------
% Pruning: an alternative is dead for a node if one of its conjuncts has no option the
% node satisfies, i.e. something required is missing. Only the remaining alternatives 
% (candidates) are considered further
% -----------------------------------------------------------------------------------
usable(X, G, A) :- opt(G, A), compat(X, A).
hasusable(X, G) :- usable(X, G, _).
dead(X, Y) :- alt(_, Y), elem(X), conj(Y, G), not hasusable(X, G).
cand(X, Y) :- alt(_, Y), elem(X), not dead(X, Y).

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