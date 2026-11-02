# Dated-price and auxiliary alignment — 2 November 2026

Agreed follow-up: correct the 2025 `q` explanation, add commented optional fiscal epilogues, label every maintained endogenous/exogenous declaration, explain the bounds and role of output loops, then publish the complete reviewed update to GitHub and use the existing Overleaf GitHub connection.

The dated recursion with beta is not a unit root; imposing a constant level at a constant allocation yields q=0. Removing beta detrends the price but leaves a scale-free recursive level/unit root. The LaTeX and [participant note](../notes/q_and_auxiliaries.md) distinguish dated prices, real payoff ratios, normalization and the one-period pricing factor. Yield calculations retain beta and now write the consumption-tax normalization explicitly (it equals one in the spending example).

All 15 short fiscal files have a commented optional epilogue that computes `r_over_q`, `w_over_q`, `s_over_q` and the Euler-implied `RBIG` after solving allocations. No model declarations/equations need editing to activate it. The full files retain active `R`, `rental`, `wage` and `saving_return` equations; `RBIG` is redundant with `R` in equilibrium. Every maintained `var`/`varexo` has an individual meaning/timing comment. The preserved 2025 sources are unchanged, with an erratum in `Code/training_2025/fiscal/README.md`.

Loop comments identify the fixed lists, dimensions and yield index bounds. Policy scenarios remain explicit; plotting loops only read stored solutions. No blanket guarantee is made for arbitrary edits.

Validation with MATLAB R2024a Update 5 / Dynare 6.1, using temporary working folders:

- All 19 final short files pass: `run_logs/q_alignment/simple.log`.
- All five final full-output files pass, including plot exports: `full.log`.
- All 15 optional epilogues also pass when their comment markers are removed in temporary copies: `epilogues.log`.
- Independent residual and terminal checks pass for all 15 fiscal examples; all 15 short/full allocation/output comparisons pass; both stochastic data sets match; all 15 activated epilogues agree with the corresponding full-model payoff/return panels within default solver tolerance: `checks.log`.
- Two-pass LaTeX syntax compilation passes: `latex.log` (69 pages, without visual inspection).
- All preserved training/archive file hashes and the 20 historical image hashes remain unchanged. Current maintained source hashes are in `validated_sources.json`; the preceding teaching-pass register is preserved as `validated_sources_teaching_iteration.json`.

The short MCMC chains still do not establish convergence. Visual inspection, historical/textbook replication and Section 6 remain deferred. Generated local LaTeX/Dynare files are ignored; the previously tracked LaTeX build database is removed from version control while retaining its local copy.

Overleaf's existing integration was confirmed linked to `hollander03/Practicing-Dynare-NT`. Sync uses that integration rather than uploads or project replacement. The canonical filename is `practice_dynare_FP.tex`, matching the existing Overleaf main document. The repository source and README have been aligned to this filename; no change of Overleaf main document is needed.
