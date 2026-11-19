% ========================================================================================
% PG-Types formalized in DAG Format for pg_types_checker
% ----------------------------------------------------------------------------------------
%      

% personType = Person {name STRING, OPTIONAL birthday DATE}

nodeType(person).
root(person, p0).
    and(p0). child(p0, p1; p0, p2; p0, p3).
        atom(p1, label("Person")). 
        atom(p2,prop(name, string)). 
        or(p3). child(p3, p4; p3, p5).
            atom(p4, prop(birthday, date)).
            atom(p5, blank).

% companyType = Company {name STRING, vat STRING}

nodeType(company).
root(company, c0).
    and(c0).
    child(c0, c1; c0, c2; c0, c3).
        atom(c1, label("Company")). 
        atom(c2, prop(name, string)). 
        atom(c3, prop(vat, string)).

% customerType = Customer & (person | company) {id INT}

nodeType(customer).
root(customer, k0).
    and(k0). child(k0, k1; k0, k2; k0, k3).
        atom(k1, label("Customer")).
        or(k2). child(k2, k4; k2, k5).
            ref(k4, person).
            ref(k5, company).
        atom(k3, prop(id, int)).