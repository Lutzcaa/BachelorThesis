edge(e1). src(e1, u1). tgt(e1, u2).
 label(e1, "WorksAt"). val(e1, since, date).

edge(e2). src(e2, u6). tgt(e2, u2).
 label(e2, "Buys"). val(e2, amount, int).

edge(e3). src(e3, u4). tgt(e3, u2).
    label(e3, "WorksAt"). val(e3, since, date).

edge(e7). src(e7, u3). tgt(e7, u2).
    label(e7, "WorksAt"). val(e7, since, date).

% Test edges for edge inheritance

edge(f1). src(f1, u1). tgt(f1, u3).
          label(f1, "Friend"). val(f1, since, date).
edge(f2). src(f2, u7). tgt(f2, u8).
          label(f2, "Friend"). label(f2, "Buddy"). val(f2, since, date).
edge(f3). src(f3, u7). tgt(f3, u8).
          label(f3, "Friend"). val(f3, since, date).
edge(f4). src(f4, u7). tgt(f4, u1).
          label(f4, "Friend"). label(f4, "Buddy"). val(f4, since, date).
edge(f5). src(f5, u7). tgt(f5, u8).
          label(f5, "Buddy").

edge(e8). src(e8, u1). tgt(e8, u2).
 label(e8, "WorksAt"). val(e8, since, date).

edge(e9). src(e9, u6). tgt(e9, u2).
 label(e9, "Buys"). val(e9, amount, int).

edge(e10). src(e10, u4). tgt(e10, u2).
    label(e10, "WorksAt"). val(e10, since, date).

edge(e11). src(e11, u3). tgt(e11, u2).
    label(e11, "WorksAt"). val(e11, since, date).

% Test edges for edge inheritance

edge(f6). src(f6, u1). tgt(f6, u3).
          label(f6, "Friend"). val(f6, since, date).
edge(f7). src(f7, u7). tgt(f7, u8).
          label(f7, "Friend"). label(f7, "Buddy"). val(f7, since, date).
edge(f8). src(f8, u7). tgt(f8, u8).
          label(f8, "Friend"). val(f8, since, date).
edge(f9). src(f9, u7). tgt(f9, u1).
          label(f9, "Friend"). label(f9, "Buddy"). val(f9, since, date).
edge(f10). src(f10, u7). tgt(f10, u8).
          label(f10, "Buddy").