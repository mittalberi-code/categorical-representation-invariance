# Reproduction instructions and limits

Run commands from the extracted package root. Paths with spaces are supported. Nothing in the checking or reproduction wrappers installs software, reads credentials, uses a browser, contacts a server or changes the target package.

## 1. Integrity and retained evidence (Python standard library only)

`python3 verification/check_results.py`

This validates every payload SHA-256 when the manifest is present; all fixture/result records; the exact G/n oracle; native observation counts; actual binary64 threshold decisions; and native raw-byte repeatability. It does not execute or deserialize R. A passing result validates retained evidence, not a fresh native replication.

## 2. Python experiment

Original observed environment: Python 3.12.14, pandas 2.2.3, SQLite 3.53.1. Observed installed dependency versions are recorded in `python/requirements.observed.txt`; this is a version inventory, not a tested fresh-install lockfile with transitive artifact hashes. Python's SQLite version comes from its runtime and is not installed by pandas. An independently rebuilt environment has not been provisioned here.

Use a separately provisioned environment containing those versions, or document every deviation, then:

`python3 python/reproduce_python.py /path/to/a/new/output-directory`

The wrapper copies the unchanged original study and inputs, runs two fresh processes, checks byte equality between them, and checks every computed record/input fingerprint against the retained result. Environment string differences are reported separately. The original study seed is 20261109; the full alphabet and generated rows are retained. It writes only to the chosen new directory, refuses an existing output directory, and applies a 300-second timeout per study. On this packaging executor it completed in seconds, not a portable runtime guarantee.

To inspect a single raw run directly: copy `python/run_study.py` and its adjacent `inputs` directory to a scratch directory, then run `python3 run_study.py results.json`. Do not overwrite the retained evidence.

## 3. Native R experiment

Historical environment: R 4.3.3, x86_64 Linux, Ubuntu 24.04.2 LTS (WSL2), C.UTF-8 locale. Inspect `environment/native_package_versions.csv` and the native session files. Direct Imports include ggplot2, data.table, MASS, VIM, randomForest, ranger and reshape2, with standard R packages. The package requires R >=4.1.0, but a different R/dependency environment is a variation, not an exact reconstruction.

Before executing the wrapper, separately provision R and dependencies from their official sources and install the included, unchanged `third_party/riskutility_0.2.0.tar.gz` into an isolated library. Verify its SHA-256 in `provenance/SOURCE_PIN.json`. Example after prerequisites exist:

`mkdir -p /path/to/isolated-R-library`

`R CMD INSTALL --library=/path/to/isolated-R-library third_party/riskutility_0.2.0.tar.gz`

`R_LIBS_USER=/path/to/isolated-R-library bash native/reproduce_native.sh /path/to/a/new/native-output-directory`

Installation is a separate deliberate setup action. No install was performed during packaging. The wrapper verifies the package version and installed function formals/body against the preserved source before running. It then executes the original 60-fixture runner twice and the separate uniqueness probe, exports tables, checks the two new raw objects with R's `identical`, and compares the new parsed tables to the retained tables. Keep the generated session/log records for deviations and failures.

**Not yet verified end to end:** the new portable native wrapper/export path, dependency provisioning on a clean second machine, and retained-RDS deserialization in this cloud environment. Shell syntax passed. R is unavailable here. Do not call this an independent native reproduction until these commands succeed in a documented second environment.

## 4. Which code changed

`python/run_study.py` and all input CSVs are byte-preserved. The two native study/probe runners differ only by removal of four unnecessary full-line preparation/process comments in v0.2; every non-comment line is unchanged. The portable wrappers and `verification/check_results.py` are new orchestration/checking code. `native/export_native.R` retains original arithmetic and CSV export logic; only its hard-coded workspace root was replaced with a required command-line root argument. No change was made to riskutility. See `provenance/CURATION_NOTES.md`.
