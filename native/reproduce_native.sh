#!/usr/bin/env bash
set -euo pipefail
# This script does not install anything or contact a network.
# Provision documented R/dependencies and pinned riskutility first.
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
OUT=${1:-"$ROOT/reproduction-native"}
if [[ -e "$OUT" ]]; then printf 'Output already exists. Choose a new directory.\n' >&2; exit 1; fi
command -v Rscript >/dev/null || { printf 'Rscript is required; no native test ran.\n' >&2; exit 1; }
mkdir -p "$OUT"
OUT=$(cd -- "$OUT" && pwd)
export LC_ALL=C.UTF-8 LANG=C.UTF-8
export JPC_ARCHIVE_ROOT="$ROOT" JPC_OUTPUT_ROOT="$OUT"
python3 "$ROOT/verification/check_results.py" > "$OUT/input-verification.json"
Rscript --vanilla - <<'R'
root<-Sys.getenv('JPC_ARCHIVE_ROOT');out<-Sys.getenv('JPC_OUTPUT_ROOT')
stopifnot(as.character(packageVersion('riskutility'))=='0.2.0')
e<-new.env(parent=baseenv());sys.source(file.path(root,'third_party/riskutility/R/attacker_risk.R'),e,keep.source=FALSE)
a<-get('attacker_risk.default',asNamespace('riskutility'));b<-get('attacker_risk.default',e)
stopifnot(identical(formals(a),formals(b)),identical(body(a),body(b)))
writeLines(capture.output(sessionInfo()),file.path(out,'Session_Info.txt'))
R
for run in run-1 run-2; do
  mkdir -p "$OUT/$run"
  cp -R "$ROOT/data/prepared" "$OUT/$run/fixtures"
  cp "$ROOT/data/expected.csv" "$OUT/$run/expected.csv"
  cp "$ROOT/native/run_native_pilot.R" "$OUT/$run/run_native_pilot.R"
  (cd "$OUT/$run" && Rscript --vanilla run_native_pilot.R > process.log 2>&1)
done
mkdir -p "$OUT/uniqueness-run"
(cd "$OUT/uniqueness-run" && Rscript --vanilla "$ROOT/native/plan_uniqueness_probe.R" > process.log 2>&1)
Rscript --vanilla "$ROOT/native/export_native.R" "$OUT" > "$OUT/export.log" 2>&1
Rscript --vanilla - <<'R'
o<-Sys.getenv('JPC_OUTPUT_ROOT');r<-Sys.getenv('JPC_ARCHIVE_ROOT')
stopifnot(identical(readRDS(file.path(o,'run-1/Native_Raw_Results.rds')),readRDS(file.path(o,'run-2/Native_Raw_Results.rds'))))
for(f in c('Dataset_Summary.csv','Per_Record_Native_And_Oracle.csv','Family_Summary.csv','Uniqueness_Summary.csv')) {
 a<-read.csv(file.path(o,f),check.names=FALSE,stringsAsFactors=FALSE);b<-read.csv(file.path(r,'results/native',f),check.names=FALSE,stringsAsFactors=FALSE)
 stopifnot(identical(a,b))
}
R
printf 'Native reproduction and retained-table comparison passed. Outputs: %s\n' "$OUT"
