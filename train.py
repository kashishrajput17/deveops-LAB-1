import sys, yaml, json, time
from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score

cfg = yaml.safe_load(open(sys.argv[1]))
X, y = load_digits(return_X_y=True)
Xtr, Xte, ytr, yte = train_test_split(X, y, test_size=cfg["data"]["test_size"], random_state=cfg["seed"])
t = time.time()
m = RandomForestClassifier(**cfg["model"], random_state=cfg["seed"]).fit(Xtr, ytr)
p = m.predict(Xte)
res = {"experiment": cfg["name"], "accuracy": round(accuracy_score(yte, p), 4),
       "f1_macro": round(f1_score(yte, p, average="macro"), 4), "train_time_s": round(time.time()-t, 3)}
print(json.dumps(res, indent=2))
json.dump(res, open(f"logs/{cfg['name']}_metrics.json", "w"))
