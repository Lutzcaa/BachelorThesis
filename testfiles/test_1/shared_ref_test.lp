% Test for shared references on nodes

% ---------- Schema ----------

% s = A | B
nodeType(s).
root(s, s0).
    or(s0). child(s0, s1; s0, s2).
    atom(s1, label("A")).
    atom(s2, label("B")).

% ab = s & s

nodeType(ab).
root(ab, ab0).
    and(ab0). child(ab0, ab1; ab0, ab2).
        ref(ab1, s).
        ref(ab2, s).

% Graph

% ---------- Graph ----------
node(n1). label(n1, "A").
node(n2). label(n2, "B").
node(n3). label(n3, "A"). label(n3, "B").
node(n4). label(n4, "C").

% ---------- Expected typing ----------
% n1: s, ab
% n2: s, ab
% n3: ab only   <- shared-reference case: A goes through ab1, B through ab2
% n4: none