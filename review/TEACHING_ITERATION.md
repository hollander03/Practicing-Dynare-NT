# Participant code and full section outputs

Follow-up: [Q_ALIGNMENT.md](Q_ALIGNMENT.md) records the subsequent dated-price explanation, optional interpretation epilogues, variable labels and current checks. Its source register supersedes this iteration’s register, preserved as `validated_sources_teaching_iteration.json`.

This iteration implements the requested teaching structure. It does not start the previously deferred historical replication or visual review.

## Delivered structure

- `Code/sections`: 19 short `.mod` files, one experiment per file. Equations, parameters, guesses, policy dates and data exports have consistent spacing and concise comments. The files contain no figure creation, runtime assertions or active custom solver tolerances. Section 5 omits the unused investment-subsidy instrument; non-labour models omit labour-only parameters. The Section 5.3.6 price/yield calculation remains because it is the subject of that example, with comments explaining the MATLAB block.
- `Code/full_replications`: five independently runnable `.mod` files covering Sections 2, 3, 4, 5.3 and 5.4. Each includes its model, scenarios and outputs. There are no custom plotting functions, external helper scripts, macro includes or calls to other section models. Sections 2 and 3 generate their own artificial observations before estimation. Fiscal examples retain explicit scenario blocks and share one short plotting loop per file; the Section 5.3 spending solution is reused for the curvature comparison and yields.
- `notes/README.md`: participant note explaining less common commands and objects, mapped to sections. `notes/figure_map.md` maps the 20 historical figures to the full code and new output names.
- Estimation uses the standard `mode_compute=4` command in place of the long optimiser-configuration string. Both short and full examples retain fixed seeds, the same priors and short 1,000-draw teaching chains. Optional tighter deterministic tolerances are commented out with a concise explanation.

The full fiscal files use one `initval` block, remember the initial steady state/policy, and restore it between scenarios before defining each terminal policy. This is necessary because Dynare disallows `initval` after `endval`. `shocks(overwrite)` prevents earlier shock schedules carrying into later examples. These commands are explained where used and in the participant note.

## Figures and worksheet

All 20 images used in `practice_dynare_NT.tex` were renamed to section/scenario stems, such as `s05_03_01_g_legacy.jpg`. Image bytes are unchanged. The LaTeX and the archived LaTeX's corresponding references were updated. Figures previously sitting under the following subsection were moved alongside the example named in their own captions; figure contents and captions' numerical claims were not revalidated.

New full-code output uses the matching stem, e.g. `output/s05_03_01_g.png`. Density panels are PDF because that format is supported by the installed Dynare 6.1 graph export. Section 3 additionally produces a prior-only panel. The 21 explicit plot outputs comprise 17 PNGs and four density PDFs; fiscal runs also save 15 same-stem MAT files. Dynare retains its own logs, parameter/steady-state/policy-function summaries, posterior summaries and native graph outputs. These outputs were exercised in temporary work folders; generated plots have not replaced the historical worksheet images.

[figure_renames.json](figure_renames.json) preserves original filenames, new names, SHA-256 checksums and producing model/output paths. [validated_sources.json](validated_sources.json) records the exact 24 maintained model files and their current execution logs. Original 2025 training/archive code is unchanged.

## Checks completed

Environment: MATLAB R2024a Update 5, Dynare 6.1 arm64. Runs took place in temporary directories; figure visibility was disabled externally for batch execution. No rendered images/pages were inspected.

| Check | Result / evidence |
|---|---|
| All 19 short participant examples | Pass, `run_logs/teaching_iteration/simple.log` |
| Section 2 and 3 self-contained full files, including estimation and exports | Pass, `run_logs/teaching_iteration/full.log` |
| Final compact Section 4, 5.3 and 5.4 full files | Pass, `run_logs/teaching_iteration/full_fiscal_final.log` |
| Independent equations, labour conditions and terminal convergence for all 15 short fiscal models at ordinary solver settings | Pass at 1e-5 residual threshold, `residual_checks.log` |
| Full versus short fiscal capital/consumption paths, policy-date alignment and yield-price paths | Pass, `output_checks.log`; maximum plotted allocation difference about 5.1e-6 |
| Identical artificial observations in short/full Sections 2 and 3 | Pass, `residual_checks.log` |
| All 20 renamed historical images retain their original bytes; all mapped output files exist | Pass; rename manifest/hash and output file checks |
| Two-pass LaTeX syntax compilation with renamed assets and revised listings | Pass, `latex.log`; 55 pages in temporary output directory |

The reviewer-only `tools/verify_fiscal_paths.m` accepts Section 5's omitted investment subsidy as zero and uses a threshold appropriate to default solver accuracy. `tools/check_teaching_outputs.m` compares the executed short/full outputs; it is not a dependency of any teaching file. Initial failed full-file attempts are retained in `full_initial_attempt.log`; the final logs above supersede those attempts. The earlier successful uncondensed fiscal runs in `full.log` are superseded by `full_fiscal_final.log`.

As expected, Dynare warns that 1,000 draws are insufficient for its MCMC convergence diagnostics. Successful execution does not establish posterior convergence, identification or equivalence to historical numerical results. The LaTeX compilation retains an overfull historical policy-function equation and float-placement warnings; no visual checks were undertaken. The existing root-level generated LaTeX artifacts were left alone; the explicit compilation used a temporary output directory.

Next iteration: the previously listed deferred work remains deferred, including historical/textbook replication, visual review, and the separate NT-DSGE Section 6 model.
