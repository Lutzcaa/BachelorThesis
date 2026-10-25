% =====================================================================
% typen_simple.lp  –  Typen in der Drei-Schichten-Form (alt / conj / opt)
% =====================================================================
% personType = Person {name STRING, OPTIONAL birthday DATE}
alt(personType,a1).
conj(a1,g1). opt(g1,label("Person")).
conj(a1,g2). opt(g2,prop(name,string)).
conj(a1,g3). opt(g3,prop(birthday,date)). opt(g3,blank).

% companyType = Company {name STRING, vat STRING}
alt(companyType,a2).
conj(a2,g4). opt(g4,label("Company")).
conj(a2,g5). opt(g5,prop(name,string)).
conj(a2,g6). opt(g6,prop(vat,string)).

% customerType = (Person | Company) & Customer {id INT}
alt(customerType,a3).
conj(a3,g7). opt(g7,label("Person")). opt(g7,label("Company")).
conj(a3,g8). opt(g8,label("Customer")).
conj(a3,g9). opt(g9,prop(id,int)).
