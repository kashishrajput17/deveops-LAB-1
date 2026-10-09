import sys, glob, py_compile
bad = 0
for f in glob.glob("**/*.py", recursive=True):
    py_compile.compile(f, doraise=True)
    for n, line in enumerate(open(f), 1):
        if len(line.rstrip("\n")) > 120:
            print(f"{f}:{n}: line too long"); bad += 1
        if line.rstrip("\n") != line.rstrip("\n").rstrip():
            print(f"{f}:{n}: trailing whitespace"); bad += 1
print(f"lint: {bad} problem(s)")
sys.exit(1 if bad else 0)
