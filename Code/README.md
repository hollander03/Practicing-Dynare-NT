# Participant examples and full section outputs

`sections/` contains the short participant examples: one scenario per file, complete displayed equilibrium conditions, spaced equations, concise explanatory comments, and no figure creation. `full_replications/` contains five self-contained `.mod` files that run the corresponding section exercises and produce their outputs; they require no helper scripts. `training_2025/` preserves hand-authored source versions and adjacent historical logs byte for byte. `archive/` preserves unmatched models and the repository's former top-level model files. None of the historical variants is endorsed merely because a 2025 log reports a successful solve. SHA-256 hashes and original absolute source paths are in `../review/source_manifest.json`.

| Worksheet | File in `sections/` | Purpose |
|---|---|---|
| 2.2 | `s02_02_growth_approx.mod` | Second-order approximation; generates consumption data |
| 2.3 | `s02_03_growth_estimate.mod` | Bayesian estimation using Section 2 data |
| 3.2 | `s03_02_twocountry_approx.mod` | Two-country second-order approximation; generates data |
| 3.3 | `s03_03_twocountry_estimate.mod` | Bayesian estimation using Section 3 data |
| 4.3.1–4.3.4 | `s04_03_01_g.mod`, `s04_03_02_tauc.mod`, `s04_03_03_taui.mod`, `s04_03_04_tauk.mod` | Permanent spending/tax/subsidy changes |
| 4.3.5–4.3.6 | `s04_03_05_g.mod`, `s04_03_06_taui.mod` | One-period pulses |
| 5.3.1–5.3.4 | `s05_03_01_g.mod`, `s05_03_02_tauc.mod`, `s05_03_03_tauk.mod`, `s05_03_04_g.mod` | Anticipated spending/consumption tax/capital tax and spending pulse |
| 5.3.5 | `s05_03_05_g_gamma02.mod` | Low-curvature economy; compare with 5.3.1 gamma=2 |
| 5.3.6 | `s05_03_06_yields.mod` | Normalized dated prices and 1–40-period yields, without plots |
| 5.4.1–5.4.3 | `s05_04_01_g.mod`, `s05_04_02_taun.mod`, `s05_04_03_taun.mod` | Log utility and elastic labour; immediate g/labour tax and anticipated labour tax |
| 6 | No file | Separate NT-DSGE model not supplied or inferred from generic RBC files |

Run from `Code/sections` in MATLAB, adding your installed Dynare `matlab` directory to the path:

```matlab
addpath('/Applications/Dynare/6.1-arm64/matlab');
dynare s02_02_growth_approx.mod
dynare s02_03_growth_estimate.mod
```

To produce the complete set of outputs for a section, run one of the following files from `Code/full_replications`:

| File | Exercises and output |
|---|---|
| `s02_full_rep.mod` | One-sector IRFs, artificial data, prior/posterior panels and estimation summaries |
| `s03_full_rep.mod` | Two-country IRFs, artificial data, prior/posterior panels and estimation summaries |
| `s04_full_rep.mod` | All six Section 4 transitions, with six panels per scenario |
| `s05_03_full_rep.mod` | Four anticipated policy changes, two-curvature comparison and yield curves |
| `s05_04_full_rep.mod` | All three labour-supply transitions |

The full files write PNG plots (and Dynare density PDFs) to local `output/` with section-based filenames. Fiscal plots also have same-stem MAT files. They use explicit scenario blocks and one common plotting loop; no custom plotting functions, include files or helper scripts are needed. Section 2 and 3 full files generate estimation data themselves. See [participant command notes](../notes/README.md) and the [figure map](../notes/figure_map.md).

Run Section 3 approximation before Section 3 estimation as well. Use separate working copies to keep generated Dynare files outside the source tree. `tools/run_sections.m` runs all 19 files sequentially in a directory containing copies of them. Its `noclearall` preserves the runner variables between models. The reviewer-only tools are separate from the participant workflow. See [this iteration’s checks](../review/TEACHING_ITERATION.md) for the validation outcomes.

Timing: textbook date t=0 is simulation period 1; a t=10 policy change uses period 11. The guide follows Dynare directly: `k(-1)` is beginning-of-period capital k_(t-1), while `k` is chosen during t as k_t for use in t+1. Permanent changes have a new terminal steady state; pulses retain the initial terminal state. `taui` is a subsidy with purchase price `1-taui`, not an investment tax surcharge. Section 5 omits that instrument. Section 5.4 uses gamma=1 and B=3 to match log-consumption utility. The algebraic detrended price `qtilde` and real `r`, `w`, `R`, `s` are explicit in every fiscal model. Dated prices for yields are recovered after solving; no unnormalised recursive price state is introduced.

Estimation uses the standard `mode_compute=4` posterior-mode search and 1,000 MCMC draws for a runnable teaching example, not posterior accuracy certification. Standard deviation priors have finite spread, economically bounded share/persistence parameters use beta priors, and Section 2 fixes s=.007 while estimating stderr(e). Observations are named variables saved in section-specific MAT files, not an entire MATLAB workspace. Historical posterior tables and policy coefficients are not automatically regenerated.

Historical files: `RMT_FP_final.mod` and `RMT_FP_exercises_k_pred_clean.mod` have identical source hashes. The several `fullsystem`, `clean`, `exercises`, and section-specific versions are development alternatives rather than independent validated replications. The November labour versions change timing, gamma/B, and auxiliary prices; consult `review/PRESENTATIONS.md` before choosing among them.

Archived unmatched code: `rbc_tax_model.mod` is truncated at `t = tau_k_`, so it cannot run; its fixed-rate stochastic TFP model is not the worksheet fiscal-transition model. `RBC_nonlinear.mod`, `basicrbc2015_g_added.mod`, and `MIU.mod` belong to other training exercises; the last is a flexible-price money-growth model rather than evidence for the six-rule NK slide exercise. The old repository `RMT_FP_final.mod` is also preserved in `archive/` for provenance; the new section files are the maintained entry points.

The ordinary solver settings are active. Tighter `tolf`/`tolx` values are left commented out with their purpose explained. Runtime assertions belong to the reviewer tools, rather than the student examples. Historical images used by the worksheet now have section-based `*_legacy.jpg` names; matching code output has the same stem. Numerical replication remains a separate next step.

All maintained `var` and `varexo` declarations now label each variable individually. Every fiscal participant file now contains the complete equilibrium conditions, matching the guide equation by equation. The earlier optional factor-price epilogues are superseded by active `qtilde`, `r`, `w`, `R` and `s` equations. Algebraic elimination of these definitions recovers the reduced two/three-equation allocation model. See [the q and auxiliaries note](../notes/q_and_auxiliaries.md). The preserved training source has a linked erratum rather than rewritten historical comments.

Each of Models 2.1, 3.1, 4.1, 5.1 and 5.4 has its own variable/parameter/calibration table in the guide. Appendix A explicitly lists all 24 maintained `.mod` files and the preserved historical/archive versions. Every active `verbatim` block explains its pass-through role; ordinary `%` comments are used inside.
