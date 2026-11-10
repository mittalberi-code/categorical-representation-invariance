"""Run the original Python study twice, in a separate output directory, without installing."""
from pathlib import Path
import shutil,subprocess,sys,json,hashlib
Q=Path(__file__).resolve().parents[1]
out=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Q/'reproduction-python'
if out.exists():raise SystemExit('Output already exists; choose a new directory to preserve prior results.')
out.mkdir(parents=True)
shutil.copy2(Q/'python/run_study.py',out/'run_study.py');shutil.copytree(Q/'python/inputs',out/'inputs')
for n in [1,2]:
 with (out/f'run{n}.log').open('w') as log:subprocess.run([sys.executable,str(out/'run_study.py'),f'results_run{n}.json'],check=True,stdout=log,stderr=subprocess.STDOUT,timeout=300)
a=(out/'results_run1.json').read_bytes();b=(out/'results_run2.json').read_bytes();assert a==b
r=json.loads(a);expected=json.loads((Q/'results/python/results_run1.json').read_text())
# Environment strings may differ; every record and source/fixture fingerprint must match.
for k in ['seed','alphabet','source_sha256','fixture_sha256','dataset_count','safe_method_agreement_checks','summary','records']: assert r[k]==expected[k],k
print(json.dumps({'repeat_identical':True,'full_result_matches_retained_bytes':a==(Q/'results/python/results_run1.json').read_bytes(),'all_records_and_inputs_match':True,'sha256':hashlib.sha256(a).hexdigest(),'python':r['python'],'pandas':r['pandas'],'sqlite':r['sqlite']},indent=2))
