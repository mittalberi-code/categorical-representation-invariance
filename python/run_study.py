"""Synthetic Python representation study. Never imports or executes R/riskutility."""
from collections import Counter
from fractions import Fraction
from pathlib import Path
from itertools import product
import csv, hashlib, json, platform, random, sqlite3, sys
import pandas as pd
P = Path(__file__).resolve().parent
SEED = 20261109
ALPHABET = ['', 'a', 'b', '|', 'a|', '|a', 'a|b', 'b|a', 'α', 'हिंदी']

def grouped(keys):
    counts = Counter(keys)
    return [counts[k] for k in keys]

def pairwise(rows):
    return [sum(all(a == b for a,b in zip(x,y)) for y in rows) for x in rows]

def sql_frequency(rows):
    con = sqlite3.connect(':memory:')
    columns = [f'k{i}' for i in range(len(rows[0]))]
    con.execute('CREATE TABLE t (id INTEGER, ' + ','.join(c+' TEXT COLLATE BINARY' for c in columns)+')')
    con.executemany('INSERT INTO t VALUES ('+','.join('?' for _ in range(len(columns)+1))+')', [(i,*row) for i,row in enumerate(rows)])
    result = [v[0] for v in con.execute('SELECT COUNT(*) OVER (PARTITION BY '+','.join(columns)+') FROM t ORDER BY id')]
    con.close()
    return result

def score(f):
    return sum((Fraction(1,v) for v in f), Fraction()) / len(f)

def evaluate(identifier, rows, family):
    assert rows and rows[0] and all(len(r)==len(rows[0]) for r in rows)
    assert all(type(v) is str for r in rows for v in r)
    truth = pairwise(rows)
    frame = pd.DataFrame(rows, columns=[f'k{i}' for i in range(len(rows[0]))])
    frame['_row'] = range(len(rows))
    methods = {
        'tuple_counter': grouped([tuple(row) for row in rows]),
        'pandas_groupby': frame.groupby(list(frame.columns[:-1]), sort=False, dropna=False)['_row'].transform('size').tolist(),
        'sqlite_partition': sql_frequency(rows),
        'json_array': grouped([json.dumps(row, ensure_ascii=False, separators=(',',':')) for row in rows]),
        'length_prefix': grouped([''.join(str(len(v))+':'+v for v in row) for row in rows]),
        'delimiter_expression_model': grouped(['|'.join(row) for row in rows]),
    }
    for name, f in methods.items():
        if name != 'delimiter_expression_model': assert f == truth, (identifier,name)
    return {'id':identifier,'family':family,'rows':rows,'n':len(rows),'arity':len(rows[0]),'oracle_frequencies':truth,'oracle_score_exact':str(score(truth)), 'methods':{name:{'frequencies':f,'matches_oracle':f==truth,'score_exact':str(score(f)),'threshold_flag_changes':(score(f)<=Fraction(1,10)) != (score(truth)<=Fraction(1,10))} for name,f in methods.items()}}

def variants(rows):
    safe = [{v:f'C{j}V{i}' for i,v in enumerate(dict.fromkeys(c))} for j,c in enumerate(zip(*rows))]
    delimited = [{v:f'|C{j}|V{i}|' for i,v in enumerate(dict.fromkeys(c))} for j,c in enumerate(zip(*rows))]
    return {'original':rows, 'reverse_rows':rows[::-1], 'reverse_columns':[r[::-1] for r in rows], 'safe_relabel':[[safe[j][v] for j,v in enumerate(r)] for r in rows], 'delimiter_relabel':[[delimited[j][v] for j,v in enumerate(r)] for r in rows]}

def main():
    records=[]
    fixture_dir=P/'inputs'/'fixtures'
    fixture_hashes={}
    for path in sorted(fixture_dir.glob('*.csv')):
        fixture_hashes[path.name]=hashlib.sha256(path.read_bytes()).hexdigest()
        with path.open(newline='',encoding='utf-8') as f:
            rows=list(csv.reader(f))[1:]
        records.append(evaluate(path.stem,rows,'prepared_fixture'))
    rng=random.Random(SEED)
    for i in range(100):
        arity=rng.randint(1,4); n=rng.randint(2,40)
        rows=[[rng.choice(ALPHABET) for _ in range(arity)] for _ in range(n)]
        base = pairwise(rows)
        for variant,values in variants(rows).items():
            f=pairwise(values)
            assert (f[::-1] if variant=='reverse_rows' else f)==base
            # Check complete equivalence relation, not just frequency equality.
            aligned=values[::-1] if variant=='reverse_rows' else values
            assert [[x==y for y in rows] for x in rows] == [[x==y for y in aligned] for x in aligned]
            records.append(evaluate(f'random_{i:03d}__{variant}',values,'seeded_synthetic'))
    for arity in [2,3]:
        records.append(evaluate(f'exhaustive_arity_{arity}',[list(r) for r in product(ALPHABET,repeat=arity)],'finite_domain_exhaustive'))
    source=P/'inputs'/'attacker_risk.R'
    assert hashlib.sha256(source.read_bytes()).hexdigest() == '761095b1affa2aa67be75c9e0fa0d2369138497d53d87b8b11807a372b4da237'
    summary={family:{'datasets':len(rs),'delimiter_model_disagreements':sum(not r['methods']['delimiter_expression_model']['matches_oracle'] for r in rs),'delimiter_model_flag_changes':sum(r['methods']['delimiter_expression_model']['threshold_flag_changes'] for r in rs)} for family in sorted(set(r['family'] for r in records)) for rs in [[r for r in records if r['family']==family]]}
    output={'scope':'Executed Python grouping experiment, NOT riskutility/R execution or full API emulation','python':platform.python_version(),'pandas':pd.__version__,'sqlite':sqlite3.sqlite_version,'seed':SEED,'alphabet':ALPHABET,'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'fixture_sha256':fixture_hashes,'dataset_count':len(records),'safe_method_agreement_checks':len(records)*5,'summary':summary,'records':records}
    out=P/(sys.argv[1] if len(sys.argv)>1 else 'results.json')
    out.write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k not in ['records','fixture_sha256']},indent=2,ensure_ascii=False))

if __name__=='__main__':main()
