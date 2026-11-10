Historical review of an earlier private preparation snapshot. Release decisions recorded here describe that snapshot, not the current release. See the root README and release notes for current status.

# Private reproducibility package: independent QA

Reviewed 10 November 2026. **No blocking issue was found in the reviewed payload. This is private staging, not a submission-ready public deposit.**

## Verified

- A fresh Python execution reproduced the retained results byte-for-byte. Independent recalculation confirmed 562 dataset variants, 2,810 agreeing structure-preserving comparisons, 43 delimiter-model disagreements and two changed flags.
- Retained native observations match exact tuple references: 60 configurations per run, six frequency/global-score disagreements, 28 differing record frequencies and two changed flags, with no recorded errors or warnings. The two runs repeat the same 60 configurations; they are not 120 independent datasets. The separate uniqueness probe is correctly excluded.
- The assembled evidence checker passes. The 60 prepared files contain 54 distinct byte sequences, and the native package inventory has 165 Package/Version entries without private installation paths.
- Pinned upstream archive/source fingerprints match the manuscript evidence. Extracted upstream files match the unchanged archive. GPL-3 attribution and license text are retained without imposing a new license on the original study materials. JPC style files are excluded.
- Portable wrappers and documentation distinguish retained observations, fresh Python execution and future native reproduction. The native exporter preserves the original calculation logic; only its workspace-root input was adapted.
- A bounded inspection of payloads, including compressed source and result contents, found no credentials or private user/machine paths. Synthetic study records are distinct from public upstream attribution and examples. Standard system-library paths remain in environment records. This inspection is not a guarantee against every possible undiscovered secret.

## Remaining gates

**No new native R execution was performed. R is unavailable in the review environment.** The portable R wrapper passed shell syntax review but has not been executed end to end. Independently provisioned native reproduction and fresh dependency provisioning remain open; observed version inventories are not fully tested installation lockfiles.

Public release requires author approval, compatible licenses for original materials, final metadata and a real verified archival deposit. No publication, DOI creation or license selection is implied by this review. Novelty, current upstream status, editorial suitability and institutional declarations remain separate manuscript decisions.

Final archive-manifest verification is recorded separately after packaging; this report does not certify a checksum manifest that had not yet been generated.
