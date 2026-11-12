% ========================================================================================
% types_edges.lp - edges displayed in three layer form (alt, conj, opt)
%
% The difference to nodes is that we also have to check if the source and endnode conform to
% the given edge types decsription, which brings the complexity more near to &|& structures.
% Since the checker needs to know what its looking at (Source, Edge, Target), we have
% to add a position predicate which takes the option and a one of three position arguments:
%   - Source -> src
%   - Edge -> edge
%   - Target -> tgt
% ========================================================================================

%(:personType)-[worksAtType : WorksAt { since DATE }]->(:companyType)

alt(worksAtType, w1).
edgeType(worksAtType).
conj(w1, h1). opt(h1, pos(src, label("Person"))).
conj(w1, h2). opt(h2, pos(src, prop(name,string))).
conj(w1, h3). opt(h3, pos(src, prop(birthday,date))). opt(h3, pos(src, blank)).
conj(w1, h4). opt(h4, pos(edge, label("WorksAt"))).
conj(w1, h5). opt(h5, pos(edge, prop(since, date))).
conj(w1, h6). opt(h6, pos(tgt, label("Company"))).
conj(w1, h7). opt(h7, pos(tgt, prop(name, string))).
conj(w1, h8). opt(h8, pos(tgt, prop(vat, string))).