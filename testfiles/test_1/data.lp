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

% edge type test
node(u7). label(u7, "Person"). label(u7, "Employee").
          val(u7, name, string). val(u7, salary, int).
node(u8). label(u8, "Person"). label(u8, "Employee").
          val(u8, name, string). val(u8, salary, int). val(u8, birthday, date).

node(u9). label(u9, "Person"). val(u9, name, string). % type: Person

node(u10). label(u10, "Company"). val(u10, name, string). val(u10, vat, string). % type: Company

node(u11). label(u11, "Person"). val(u11, name, string). val(u11, birthday, date). % type Person

node(u12). label(u12, "Person"). val(u12, name, string). val(u12, x, int). % no type

node(u13). label(u13, "Person"). label(u13, "Company"). label(u13, "Customer"). val(u13, id, int). % no type

% type Customer
node(u14). label(u14, "Person"). label(u14, "Customer"). val(u14, name, string). val(u14, birthday, date). val(u14, id, int).

% edge type test
node(u15). label(u15, "Person"). label(u15, "Employee").
          val(u15, name, string). val(u15, salary, int).
node(u16). label(u16, "Person"). label(u16, "Employee").
          val(u16, name, string). val(u16, salary, int). val(u16, birthday, date).
