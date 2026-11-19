import clingo;

test = "test_1"
dir = "testfiles/" + test + "/"


ctl = clingo.Control(["0", "--enum-mode=brave"])
#ctl.load(dir + "data.lp")
#ctl.load(dir + "types.lp")

ctl.load(dir + "shared_ref_test.lp")

ctl.load("pg_types_checker.lp")
ctl.ground([("base", [])])

ergebnis = []
ctl.solve(on_model=lambda m: ergebnis.__setitem__(slice(None), m.symbols(shown=True)))
print(" ".join(str(s) for s in ergebnis))
