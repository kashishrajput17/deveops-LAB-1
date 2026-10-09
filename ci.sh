#!/bin/bash
# Local runner that executes the same commands as .github/workflows/ci.yml, stage by stage
run() { # name, command
  local s=$(date +%s.%N)
  echo "::group:: $1"; echo "\$ $2"
  if eval "$2"; then r=PASS; else r=FAIL; fi
  local e=$(date +%s.%N); printf "[%s] %s (%.1fs)\n" $r "$1" $(echo "$e - $s" | bc)
  echo "$1|$r|$(printf %.1f $(echo "$e - $s" | bc))" >> ci_summary.txt
  [ $r = PASS ]
}
rm -f ci_summary.txt
run "1. lint" "python3 lint.py" &&
run "2. test" "python3 -m unittest discover tests 2>&1 | tail -6; test \${PIPESTATUS[0]} -eq 0" &&
run "3. train-and-gate" "python3 train.py configs/production.yaml 0.95" &&
run "4. build" "tar czf model-package.tar.gz train.py configs && ls -l model-package.tar.gz" &&
run "5. deploy" "mkdir -p deploy && cp model-package.tar.gz deploy/ && echo 'deployed to ./deploy'"
status=$?
for s in "1. lint" "2. test" "3. train-and-gate" "4. build" "5. deploy"; do grep -q "^$s|" ci_summary.txt || echo "$s|SKIPPED|0.0" >> ci_summary.txt; done
exit $status
