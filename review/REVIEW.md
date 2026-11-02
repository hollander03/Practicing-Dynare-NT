# Worksheet and code review — 2 November 2026

**Follow-up:** [TEACHING_ITERATION.md](TEACHING_ITERATION.md) records the participant-facing rewrite, full-output files, figure renames and current execution checks. The code/settings and validation hashes described below belong to the initial review pass; its hash register is preserved as `validated_sources_iteration1.json`.

Scope: `practice_dynare_NT.tex`, original annotated 2010 PDF, all hand-authored fiscal `.mod` variants in the supplied 2025 folder, and the adjacent presentation folder. Source material was read locally; external originals were not edited. Visual checks and numerical/textbook replication are excluded by request. A successful run establishes executability, not agreement with historical figures.

## Corrections applied

- Registered all 27 original PDF annotations, including highlights, comments and strikethroughs, in [ANNOTATIONS.md](ANNOTATIONS.md), with complete extraction metadata in [annotations.json](annotations.json). Scope highlights were not treated as automatic edits. Several deprecated-command removals were already partly applied in the existing LaTeX; the register records the resulting disposition.
- Replaced fragmented/outdated inline programs with complete, labelled section `.mod` files. LaTeX uses `lstinputlisting` to include the actual runnable source. Listings wrap long lines without inserting fake MATLAB continuation ellipses into equations. All 19 example files have consistent names, calibration, timing comments and section references.
- Section 2: corrected stochastic Euler timing to next-period productivity, labour and marginal product of today's capital choice. Corrected the printed Euler equation's labour exponent and time subscripts. The old estimation resource equation multiplied by `lab*(1-alp)` instead of `lab^(1-alp)`; both examples now share the correct production function.
- Sections 2–3: replaced old `dr_algo`, standalone `periods`, obsolete save helpers and typographic exponent characters. Explicit second-order approximations save named observed series in separate MAT files. Estimation has bounded parameter priors, finite shock-prior spreads, fixed seeds, and short teaching chains. These are documented calibration/prior choices, not exact copies of the old posterior exercise. No double estimation of the Section 2 shock scale: fix s=.007, estimate stderr(e).
- Sections 4–5: Euler return uses next-period tax wedges and rental return, matching consumption at t+1. Investment expenditure `(1-taui)*i` is consistently a subsidy; corrected the mixed plus/minus signs in the printed return equation. Policy text date t=10 means simulation period 11; no plotting shift is used to repair equation timing.
- Permanent changes compute terminal steady states with `endval; steady;`; pulse experiments retain the initial terminal steady state. This avoids a spurious policy reversal at the finite simulation boundary. All fiscal simulations use 300 periods.
- Removed recursive, unnormalised `q` from the solved allocation system. Dropping beta from the recursion still leaves its level undetermined; it does not provide a unique price steady state. Section 5.3.6 constructs dated normalized prices after solving and computes continuously compounded yields with strictly positive maturities.
- Section 5.4 follows the stated log-consumption utility: gamma=1, B=3, the consumption-tax wedge in the labour condition, future labour in future marginal product, and interior labour checks. The 2025 gamma=2 / alternative-B variants are preserved but not silently substituted for the worksheet model.
- Corrected missing consumption expenditure in household budgets, missing employment in wage income in the labour version, and wage income incorrectly counted as government tax revenue in Section 4. Added residual lump-sum financing T_t to household/government budgets: zero distorting taxes cannot otherwise finance positive baseline spending. This makes the stated fiscal closure explicit without changing allocation first-order conditions. Parenthesized the full discounted log/leisure felicity expression.
- Repaired malformed math/caption braces that prevented LaTeX compilation; updated the duplicate posterior caption. Replaced nonexistent `examples.zip` guidance, fictional README directory layout, and unsupported claims that Section 6 is implemented. Resolved third-edition 20XX placeholders to 2012, with exact figure/chapter correspondences left for replication.

## Sources and archives

[Source manifest](source_manifest.json) records SHA-256 checksums and original paths for every copied code/log file. Generated Dynare `+model` directories, binary outputs, checksums and model caches were not copied as hand-authored source. The original 2025 run logs are evidence of historical attempts, not evidence that the revised source has been tested now.

`Code/training_2025/fiscal` contains all seven fiscal source variants and the runner. The November labour and October presentation variants are preserved under `Code/training_2025/presentations`. `RMT_FP_final.mod` and `RMT_FP_exercises_k_pred_clean.mod` are exact duplicate source versions. The historical `RMT_FP_exercises.log` records a macro-lexer error. Other variants retain problematic return/price equations even where a solver reported success.

`Code/archive/rbc_tax_model.mod` is the former repository file, preserved byte for byte. It ends at `t = tau_k_`, with an unfinished initial-value block and no solve instruction. It is a stochastic TFP model with fixed capital/labour tax rates and a spending share, not the deterministic worksheet model; its origin as an NT-DSGE implementation cannot be established. The old top-level `RMT_FP_final.mod` is also preserved in the archive. Other RBC and MIU training exercises that do not match worksheet Sections 2–5 are archived under `Code/archive/training_2025`; see the manifest and [Code guide](../Code/README.md).

## Presentations

[PRESENTATIONS.md](PRESENTATIONS.md) records page-specific findings and which proposed changes were accepted, rejected, or left unresolved. No embedded comments were present in the five supplied presentation PDFs or two PPTX decks; extracted slide text and notes are in `extracted_text`. Flattened/image-only corrections remain outside this no-visual pass. The source decks remain untouched, with proposed corrections logged rather than inferred from unidentified participant changes.

## Validation

Validation results and limits are recorded in [VALIDATION.md](VALIDATION.md); complete final console output and independent residual checks are in `run_logs`. Models run in temporary working directories, keeping generated Dynare code and simulated data outside the maintained source tree. The LaTeX syntax compilation also writes only to a temporary output directory. No rendered-page inspections were performed.

## Explicitly deferred

- Reproduce textbook/2010/2025 numerical results and historical figure mappings, policies, coefficients and posteriors.
- Review IRF/transition visual shapes and presentation image-only annotations or tables.
- Identify and integrate the separate full-scale NT-DSGE flexible-price model for Section 6; none of the generic archived RBC files is a substitute.
- Certify posterior identification, optimisation quality or MCMC convergence. The bounded searches and short chains are execution checks and teaching examples.
- Run every historical revision as a certified alternative: they are preserved development evidence, not maintained entry points.

Sources for version/reference corrections: [Dynare manual](https://www.dynare.org/manual/the-model-file.html) (`simul` is a deprecated alias, not necessarily an execution failure); [MIT Press third edition, 2012](https://mitpress.mit.edu/9780262018746/recursive-macroeconomic-theory/). The mathematical corrections above are derived from the equations and household objectives printed in the worksheet, not from unverified slide output.

Reproducibility tooling: `tools/extract_review_annotations.py` uses PyMuPDF (1.26.5 in this pass) and Python's built-in ZIP/XML readers for PPTX comments. Run it from the repository root; its source directory is declared at the top. Annotation text matched to highlight quadrilaterals can include adjacent words, so the original page, geometry and PDF annotation metadata are retained in `annotations.json`. `tools/verify_fiscal_paths.m` checks saved allocations against the resource, Euler and labour equations and terminal convergence, independently of the solver's success flag. The original 2025 variants are copied with SHA-256 provenance rather than normalised or auto-fixed.
