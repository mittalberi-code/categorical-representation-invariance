# Historical comment cleanup in v0.2

Four unnecessary full-line comments were removed: two introductory preparation/process lines in `native/run_native_pilot.R` and two in `native/plan_uniqueness_probe.R`. They included stale “not executed” preparation labels; historical run status remains in the documentation and retained evidence.

Every non-comment line in both files is identical to v0.1. No executable statement, parameter, seed, calculation, output, fixture or dependency was changed. Comments explaining the direct equality oracle, source verification, exact versus floating-point arithmetic, and uniqueness denominator ambiguity were kept. Python already has only concise scientific/reproducibility comments, so none were removed there. Third-party code and all license/attribution notices are byte-identical.

This is cosmetic cleanup, not a new experiment or a repair of riskutility. Original v0.1 remains preserved separately. Fresh Python reruns, independent review and archive integrity checks are recorded in `verification/`. Native R remains unavailable here: no fresh R run is claimed. Exact equality of all non-comment lines provides evidence that the R program text is unchanged apart from comments, but does not substitute for an independently provisioned native reproduction.
