# Code and synthetic data archive: release v0.3

Companion to **Testing Categorical Representation Invariance in Disclosure Risk Estimation**, Harish Kumar Mittal, author-review manuscript v0.5. Release prepared 10 November 2026 for Zenodo record https://zenodo.org/records/24110689 and DOI https://doi.org/10.5281/zenodo.24110689. The repository record is authoritative for publication and access status. This archive does not imply journal acceptance or submission. The manuscript and its declarations were not edited.

## What is included

- All 60 named prepared synthetic CSV configurations (54 byte-distinct files), expected frequencies, and the separate singleton-versus-class probe.
- All 562 Python dataset variants as UTF-8 JSON Lines, with retained complete result objects from two original runs.
- The original Python study and comment-cleaned R fixture/probe runners; portable wrappers and an offline evidence checker.
- Native raw RDS and readable text for both historical clean-process runs; 120 dataset and 440 per-record observations across the two runs, plus separate uniqueness results.
- Native dataset/family/record CSVs, exact-reference audit, source comparison and environment records.
- The unchanged hash-pinned riskutility 0.2.0 source archive, selected API/test/documentation files, GPL-3 notice and license text.
- Source fingerprints, data dictionary, claim-to-artifact map, verification receipts and release notes.

## Verified outcomes

Python: 562 variants, 2,810 structure-preserving frequency checks, 43 delimiter-model disagreement variants, two changed software flags. The fresh packaging reruns produced exactly the retained result bytes. Native: historical evidence records 60 successful configurations, six frequency/global-score disagreements, 28 per-record mismatches and two changed flags per run, with zero errors or warning datasets. The two flags are row-order versions of one witness. Both retained native raw objects have identical bytes.

The native result counts were independently recalculated from exported observations and fixture tuples. **R is absent from the packaging executor: the portable R wrapper is syntax-checked but has not been run end to end here.** Two original R processes shared one provisioned environment; they are repeatability evidence, not two independently provisioned replications. The original R runner's floating-point `flag_agrees` is not the exact-oracle flag statistic; use `exact_oracle_privacy_pass` and the verifier.

## Comment cleanup in v0.2

Four unnecessary preparation/process comment lines were removed from the two author-written R runners. Every non-comment line is identical to v0.1. Scientific comments, provenance explanations and all third-party source/notices remain unchanged. The code is not refactored. See `COMMENT_CLEANUP.md`.

## Start here

1. Read `REPRODUCING.md`, then run `python3 verification/check_results.py`.
2. Read `DATA_DICTIONARY.md` and `CLAIM_MAP.md` for interpretation.
3. Read `LICENSES.md` and `THIRD_PARTY_NOTICES.md` before reuse.
4. See `RELEASE_NOTES.md` and `CODE_DATA_AVAILABILITY.md` for release scope and archival details.

Original code is licensed GPL-3.0-only; original synthetic data, results and documentation are CC BY 4.0. Third-party riskutility content retains its existing GPL-3 terms. See the precise file scope in `LICENSES.md`. This package makes no novelty, present-upstream-status, real-world attack-success, privacy-safety or institutional-approval claim.

## Release v0.3

This release updates metadata, documentation and license scope from private preparation v0.2. All executable code, synthetic inputs, computational results and third-party source files remain byte-identical. Historical QA documents are retained as historical evidence, not current license or deposit status. No additional native execution is claimed.

## Source repository

The companion code repository is https://github.com/mittalberi-code/categorical-representation-invariance. Zenodo preserves the archival release; GitHub hosts the browsable source copy. The Zenodo DOI identifies the archived version.
