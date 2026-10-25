import clingo;

dir = "testfiles/"

ctl = clingo.Control(["0", "--enum-mode=brave"])
ctl.load(dir + "daten.lp")
ctl.load(dir + "typen_open.lp")
ctl.load(dir + "typen_simple.lp")
ctl.load("simple_checkerV2.lp")
ctl.ground([("base", [])])

ctl.solve(on_model=lambda m: print(m))
