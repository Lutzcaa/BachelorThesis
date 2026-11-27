

% worksAtType = (:personType)-[WorksAt {since DATE}]->(:companyType)

edgeType(worksAt).
root(worksAt, w0).
    and(w0). child(w0, w1; w0, w2; w0, w3; w0, w4).
        ref(w1, person, src).
        atom(w2, pos(edge, label("WorksAt"))).
        atom(w3, pos(edge, prop(since, date))).
        ref(w4, company, tgt).
        
% buysType = (:customerType)-[Buys {amount INT}]->(:companyType)

edgeType(buys).
root(buys, b0).
    and(b0). child(b0, b1; b0, b2; b0, b3; b0, b4).
        ref(b1, customer, src).
        atom(b2, pos(edge, label("Buys"))).
        atom(b3, pos(edge, prop(amount, int))).
        ref(b4, company, tgt).

% Test Types for edge type inheritance

%(:person)-[friend : Friend {since DATE}]->(:person)

edgeType(friend).
root(friend, fr0).
    and(fr0). child(fr0, fr1; fr0, fr2; fr0, fr3; fr0, fr4).
        ref(fr1, person, src).
        atom(fr2, pos(edge, label("Friend"))).
        atom(fr3, pos(edge, prop(since, date))).
        ref(fr4, person, tgt).

% (:employee)-[buddy : friend & Buddy]->(:employee)

edgeType(buddy).
root(buddy, bu0).
    and(bu0). child(bu0, bu1; bu0, bu2; bu0, bu3; bu0, bu4).
        ref(bu1, employee, src).
        ref(bu2, friend).
        atom(bu3, pos(edge, label("Buddy"))).
        ref(bu4, employee, tgt).