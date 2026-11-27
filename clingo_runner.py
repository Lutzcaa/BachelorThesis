import clingo;
import time;

test = "test_1"
dir = "testfiles/" + test + "/"


ctl = clingo.Control(["0", "--enum-mode=brave", "--stats"])
#ctl.load(dir + "data.lp")
#ctl.load(dir + "types.lp")
#ctl.load(dir + "edges.lp")
#ctl.load(dir + "edgeTypes.lp")

ctl.load(dir + "shared_ref_test.lp")

ctl.load("pg_types_checker.lp")
t0 = time.perf_counter()
ctl.ground([("base", [])])
t_ground = time.perf_counter() - t0

ergebnis = []
ctl.solve(on_model=lambda m: ergebnis.__setitem__(slice(None), m.symbols(shown=True)))
print(" ".join(str(s) for s in ergebnis))

stats = ctl.statistics
print(f"ground time : {t_ground:.3f} s")
print(f"solve time  : {stats['summary']['times']['solve']:.3f} s")
print(f"total time  : {stats['summary']['times']['total']:.3f} s")
print(f"models      : {stats['summary']['models']['enumerated']}")
print(f"rules       : {stats['problem']['lp']['rules']}")
print(f"atoms       : {stats['problem']['lp']['atoms']}")
