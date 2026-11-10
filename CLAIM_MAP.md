# v0.5 claim-to-artifact map

| Claim or boundary | Archive evidence |
|---|---|
| 562 Python variants and 2,810 safe frequency comparisons | `results/python/results_run1.json`, `data/python_dataset_variants.jsonl`, `verification/check_results.py` |
| 43 delimiter-model disagreements; two flag changes | Python results `summary` plus all per-method records; exact recalculation in checker |
| 60 named native configurations, 12 families, 54 byte-distinct CSVs | `data/prepared/`, `results/native/Dataset_Summary.csv`, checker |
| 220 records and 28 frequency mismatches per native run | `results/native/Per_Record_Native_And_Oracle.csv` |
| Six native frequency/global-score discrepancies and two flags per run | `results/native/Dataset_Summary.csv`, exact-reference calculations |
| Zero native errors/warning datasets in retained runs | Native raw text, process logs and Dataset_Summary status/error/warnings fields |
| Two native clean-process raw objects identical | Both raw RDS/text files; historical `Repeat_Comparison.txt`; byte identity rechecked |
| Installed API formals/body matched pinned source | Historical curated comparison receipt; preserved source and installed function evidence in original native bundle; portable wrapper checks anew when run |
| Native 0.1 witness equals binary64 literal, actual flag TRUE | 17-digit and hexadecimal fields in Dataset_Summary; flags preserved separately |
| Uniqueness u/n=1/10 vs u/G=1/2 | Separate probe CSV/RDS/text and upstream maintained test/Rd documentation |
| Fresh Python repeatability | `verification/fresh_python_rerun.json`; independent QA report |
| New native replication remains open | `REPRODUCING.md` and release checklist; R absent during packaging |

The metadata fingerprints in `provenance/INPUT_HASHES.json` identify the exact v0.5 manuscript, supplement and LaTeX source ZIP used. The manuscript is not included or altered. Dataset variants, record evaluations, distinct input bytes and distinct defects are different counting units.
