# Overleaf GitHub reconciliation — 2 November 2026

Overleaf is already linked to `hollander03/Practicing-Dynare-NT`. Its canonical main filename is `practice_dynare_FP.tex`; the repository and README now use that name as well.

The first pull created branch `overleaf-2026-11-02-0730` because Overleaf had previously renamed both `practice_dynare_NT.tex` and its generated build database to the FP suffix. Comparing that branch with its merge base showed two exact renames (R100), with no additional source-text edits.

The reconciliation therefore keeps the reviewed, validated `practice_dynare_FP.tex` from main, accepts the FP naming, and keeps the generated build database out of version control. This preserves Overleaf's naming correction and the complete reviewed worksheet/code update. The merge records the Overleaf branch as a parent so the existing integration can continue the pull. Local generated build files are preserved/ignored.

Code execution, optional epilogue checks and local LaTeX compilation are recorded in `Q_ALIGNMENT.md` and `run_logs/q_alignment`. No visual or historical replication review is implied by synchronization.
