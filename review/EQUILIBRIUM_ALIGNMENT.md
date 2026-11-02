# Complete equilibrium conditions and standalone models

The maintained fiscal participant models now contain the complete displayed equilibrium systems. The guide and code use `qtilde`, `r`, `w`, `R` and `s` explicitly, with equation-number comments. The prior optional factor-price epilogues are superseded by active equations. Algebraic elimination still recovers the reduced two-equation allocation model, or three equations with endogenous labour.

## Notation and definitions

- `r` is the real rental yield before capital tax and depreciation, consistently replacing the former Section 5 `eta`. It is not itself the net interest rate.
- `w` is the real wage per unit of labour; wage income is w*n, with n=1 in the fixed-labour models.
- `R` is the forward consumption-adjusted gross saving return; code `R` denotes textbook R_(t+1). MATLAB/Octave distinguishes it from `r`, so the bar notation has been removed from current equations.
- `s` is the current capital payoff `(1-tauk)*r+1-delta`, not interchangeable with the forward return when policy wedges change.
- `qtilde=c^(-gamma)/(1+tauc)` is an algebraic detrended marginal-utility price, with its level fixed directly. Dated prices are recovered by q_t=beta^t*qtilde_t and normalized separately for yields. No free recursive q level is introduced.

The original Section 4 divisions by q converted dated factor payoffs to consumption-good units. The guide now explains those original quantities as dated payoffs and uses real r/w/s in both fiscal sections and their budget constraints. Historical figure labels are mapped to the current notation in caption notes; image bytes are unchanged.

Conditions (7)–(13), (14)–(19a), and (22)–(24), including lettered price definitions, correspond to active model equations in the section files. The full files use the same systems. The future rental payoff in the R equation is expanded in current chosen capital and future labour, preserving the terminal-period capital dependence; see the boundary diagnosis in the run-log folder. The reviewer runner now explicitly checks perfect-foresight solver status instead of treating normal program completion alone as success.

## Standalone teaching material

Models 2.1, 3.1, 4.1, 5.1 and 5.4 each have a local table defining their variables, parameters, shocks/policy instruments, units, code names and baseline calibrations. Local text explains capital timing, endogenous versus exogenous quantities, and the distinction between calibration and numerical initial guesses. Each fiscal model explains its own dated/detrended-price convention and reduction.

Every active `verbatim` block in the maintained code explains that it is copied unchanged into the generated MATLAB/Octave program, is separate from a Dynare equilibrium block, and uses `%` comments internally.

Appendix A explicitly lists all 24 maintained `.mod` files with section/purpose descriptions, followed by the 17 preserved training/archive versions. It does not imply that historical or truncated archived files are certified executable alternatives.

All 20 figure captions explain the relevant variables and historical status; fiscal captions also identify the policy size/date/information set and baseline calibration. Existing numeric tables and the formerly bare fiscal calibration tables have standalone explanatory notes. Historical numerical results and plotted timing are not certified by these notes. `xurl` allows the explicit appendix paths to wrap without introducing new overfull lines.

## Validation

Environment: MATLAB R2024a Update 5 and Dynare 6.1 arm64; generated files are isolated in temporary directories.

| Check | Result / log in `run_logs/equilibrium_alignment` |
|---|---|
| Four Section 2–3 participant approximation/estimation files | Pass: `sections_stochastic.log` |
| Two Section 2–3 full-output files | Pass: `full_stochastic.log` |
| All 15 final fiscal participant files, solver status checked | Pass: `sections_fiscal.log` |
| All three final fiscal full-output files, every scenario solved | Pass: `full_fiscal.log` |
| Independent resource, Euler, labour, qtilde, r, w, R and s equations over all 300 simulated dates | Pass at default-solver residual threshold 1e-5: `checks.log` |
| Terminal convergence | Pass: scale-normalized gap below 1e-5; scale is max(1, absolute terminal value) |
| All 15 participant/full comparisons | Pass: `checks.log`; largest displayed c/k difference about 5.6e-7 |
| Section 2–3 artificial observations identical across participant/full files | Pass: `checks.log` |
| Appendix inventory, model tables, explicit equation tags and preserved-source/image hashes | Pass: checked from source |
| Two-pass LaTeX syntax compilation | Pass: `latex.log`, 73 pages |

The default numerical settings are retained. Tight tolerances remain optional comments. Short MCMC chains still do not establish convergence. Compilation retains the pre-existing historical policy-function overfull line and float-placement warnings; no rendered pages or plots were visually inspected. Historical/textbook replication and the separate NT-DSGE Section 6 implementation remain deferred.

Current exact source hashes are in `validated_sources.json`; the preceding q-alignment register is preserved as `validated_sources_q_alignment.json`.

## Capital-timing notation follow-up

The guide now uses Dynare dates directly: k_(t-1) is beginning-of-period capital at t, while k_t is chosen during t for use in t+1. The two-country equations use the same convention for K_i. Five local footnotes introduce this at the first capital mention in each model; notation tables, resource/Euler equations, budgets, code comments and fiscal plot labels are aligned. Historical coefficient values and image bytes are unchanged.

A source comparison confirms that all 24 models have unchanged numerical code; only comments and plot-label text changed. No numerical models were rerun and no visual checks were performed. The revised LaTeX passed two-pass syntax compilation; evidence is in `run_logs/capital_timing`. The current source-hash register identifies the executed source hashes separately where comments/labels changed.
