% =====================================================================
% daten.lp  –  Der Beispielgraph (derselbe wie in der Visualisierung)
% =====================================================================
node(u1). label(u1,"Person").  label(u1,"Customer").                     val(u1,id,int).
node(u2). label(u2,"Company").                    val(u2,name,string).  val(u2,vat,string).
node(u3). label(u3,"Person").                     val(u3,name,string).  val(u3,birthday,date).
node(u4). label(u4,"Person").                     val(u4,name,string).  val(u4,x,int).
node(u5). label(u5,"Person").  label(u5,"Company"). label(u5,"Customer"). val(u5,id,int).
