# Rights and third-party notices

Original code is GPL-3.0-only and original synthetic data, results and documentation are CC BY 4.0. These grants apply only to original material as scoped in `LICENSES.md`; no blanket relicensing of the archive is intended.

## riskutility 0.2.0 (included)

The unchanged source archive's DESCRIPTION declares `License: GPL-3`. It credits Matthias Templ (author/maintainer) and Oscar Thees (contributor). Original attribution, package metadata and source remain in the archive. The selected extracted API, test and Rd documentation are byte copies from that same archive, not original study code. `python/inputs/attacker_risk.R` is also an unchanged upstream copy and carries the same provenance. `results/native/Installed_Attacker_Function.txt` is a preserved printout of the installed upstream function; it also retains the upstream GPL-3 terms.

- Source: https://cran.r-project.org/src/contrib/riskutility_0.2.0.tar.gz
- Upstream: https://github.com/matthias-da/riskutility
- Exact fingerprints: `provenance/SOURCE_PIN.json`
- GPL version 3 text: `third_party/COPYING.GPL-3.txt` (system-distributed standard license text; canonical reference https://www.gnu.org/licenses/gpl-3.0.html).

Retain source, notices and GPL rights on redistribution. Do not relicense upstream material under the original-study licenses. Any distribution of modified/combined covered work must be assessed for GPL obligations. This inventory is a practical attribution record, not a legal opinion or blanket clearance.

## Runtime dependencies (not redistributed)

Python, pandas, NumPy, SQLite, date/time support packages, R and the native R dependencies are not vendored as executable/runtime distributions. Their observed versions appear in `environment/` and `python/requirements.observed.txt`. Obtain them from their official distribution sources and preserve applicable licenses when redistributing environments. No claim is made that all future dependency versions or distribution builds have identical terms.

## Excluded materials

The JPC class file, manuscript PDFs/LaTeX, external article full texts, account/browser artifacts, machine installation paths, software installers and credentials are not part of this archive. The already-saved manuscript/supplement remain separate. Their hashes identify the v0.5 snapshot used for alignment. Excluding JPC style assets avoids implying that this code/data package grants rights in those materials.
