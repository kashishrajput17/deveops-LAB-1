#!/bin/bash
# usage: deploy.sh <build_number> <package.tar.gz>
set -e
BUILD=$1; PKG=$2; ROOT=deploy; REL=$ROOT/releases/$BUILD
mkdir -p $ROOT/releases
PREV=$(readlink $ROOT/current 2>/dev/null || true)
mkdir -p $REL && tar xzf $PKG -C $REL
ln -sfn releases/$BUILD $ROOT/current
echo "Switched current -> releases/$BUILD"
echo "Running health check..."
if (cd $ROOT/current && python3 train.py configs/production.yaml 0.95 >/dev/null 2>&1); then
  echo "Health check OK: build $BUILD is live"
  ls -1dt $ROOT/releases/* | tail -n +4 | xargs -r rm -rf   # keep last 3 releases
else
  echo "Health check FAILED: rolling back"
  if [ -n "$PREV" ]; then ln -sfn $PREV $ROOT/current; echo "Rolled back current -> $PREV"; fi
  exit 1
fi
