% custOpenType = Customer OPEN {id INT}          (zusätzliche Labels erlaubt)
alt(custOpenType,a4).
conj(a4,g10). opt(g10,label("Customer")).
conj(a4,g11). opt(g11,labelopen).
conj(a4,g12). opt(g12,prop(id,int)).

% compOpenType = Company {vat STRING, OPEN}      (zusätzliche Properties erlaubt)
alt(compOpenType,a5).
conj(a5,g13). opt(g13,label("Company")).
conj(a5,g14). opt(g14,prop(vat,string)).
conj(a5,g15). opt(g15,propopen).
