# Data dictionary and provenance

## Synthetic study inputs

`data/prepared/*.csv`: 60 named configurations in 12 families. Each row is a record; columns are selected categorical keys. Every value is a nonmissing string. Preserve UTF-8, literal empty strings, whitespace, vertical bars, row order and column order. Do not apply numeric inference, trimming, Unicode normalization or NA conversion. CSV names identify `<family>__<variant>`; the variants are original, reverse_rows, reverse_columns, safe_relabel and delimiter_relabel. Across all 60 names there are 220 rows and 54 byte-distinct CSV files. Repeated representations are not independent samples.

`data/expected.csv`: one row per prepared record; `id` identifies the configuration, `freq` the complete-tuple equivalence-class size and `score` a decimal reference. Exact score comparisons should be recomputed as G/n from the original strings instead of treating decimal text as exact.

`data/python_dataset_variants.jsonl`: 562 objects, each with `id`, `family` and `rows`. These comprise 60 prepared configurations, 500 representations of 100 seeded base datasets, and two finite Cartesian domains. `rows` preserves ordered arrays of strings. JSON avoids CSV type inference for generated datasets. The two exhaustive configurations use arities 2 and 3 over the retained ten-string alphabet.

`data/singleton_plus_nine.csv`: separate ten-record, two-class probe, one singleton and nine repeated records. It is outside the 60-configurations experiment. The probe script constructs exactly these strings directly.

These study inputs are deliberately constructed strings, not observations, de-identified personal records or samples of an actual population. All original labels and seed are retained. Upstream package contents are separately identified under `third_party`; its bundled examples/tests are not study participants or additional study datasets.

## Outcomes

`results/python/results_run*.json`: all inputs, exact rational frequency/score outputs, method comparisons, seed and runtime versions. Five methods are tuple counting, pandas grouping, SQLite partitioning, JSON-array keys and length-prefix keys. `delimiter_expression_model` is a Python expression model, not native R execution.

`results/native/Dataset_Summary.csv`: one row per run/configuration; actual native scores include 17-digit decimal and hexadecimal binary64 strings. `exact_oracle_privacy_pass` is the G/n <= 1/10 reference. `actual_privacy_pass` is the stored package Boolean. Score agreement columns use 1e-12 tolerance; the flag comparison does not. `runner_flag_agrees` preserves the original floating-mean diagnostic, which is distinct from exact-oracle comparison.

`Per_Record_Native_And_Oracle.csv`: 440 rows across both runs; row numbers are one-based within the fixture. Actual and exact frequencies are separate. `Family_Summary.csv` aggregates configurations, not independent defects. `Uniqueness_Summary.csv` distinguishes singleton-record proportion u/n=1/10 from singleton-class proportion u/G=1/2; actual pct_uniques=0.5 matches the latter. This is a documented-denominator ambiguity, not a demonstrated arithmetic failure.

Readable R `dput` and raw RDS outputs preserve original observations. Binary RDS requires R; the offline Python checker compares byte identity without decoding it. The synthetic threshold is a software comparison only and is not a real-world release recommendation.
