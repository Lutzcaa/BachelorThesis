% ==========================================================================
% Property Graph Example Data in clingo ready format
% ==========================================================================

node(u1). label(u1, "Person"). val(u1, name, string). % type: Person

node(u2). label(u2, "Company"). val(u2, name, string). val(u2, vat, string). % type: Company

node(u3). label(u3, "Person"). val(u3, name, string). val(u3, birthday, date). % type Person

node(u4). label(u4, "Person"). val(u4, name, string). val(u4, x, int). % no type

node(u5). label(u5, "Person"). label(u5, "Company"). label(u5, "Customer"). val(u5, id, int). % no type

% type Customer
node(u6). label(u6, "Person"). label(u6, "Customer"). val(u6, name, string). val(u6, birthday, date). val(u6, id, int).