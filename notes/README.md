# Participant notes: running and reading the examples

Start with `Code/sections`: each `.mod` file contains one example, its equations and its policy scenario. These files do not create figures. Run a file from MATLAB/Octave with Dynare on the path, for example `dynare s05_03_01_g.mod`.

For the complete set of outputs from a section, run the corresponding file in `Code/full_replications`. Each is self-contained: it includes the model, scenarios and plotting commands, without helper scripts. Sections 2 and 3 generate their own estimation data. Outputs are saved locally in `output/`; Dynare also creates its usual model, graphs and results folders.

| Worksheet | Short examples | Full-output file | What to notice |
|---|---|---|---|
| 2.2–2.3 | `s02_02_growth_approx`, then `s02_03_growth_estimate` | `s02_full_rep.mod` | One productivity innovation; artificial consumption data; priors/posteriors |
| 3.2–3.3 | `s03_02_twocountry_approx`, then `s03_03_twocountry_estimate` | `s03_full_rep.mod` | Log variables; two country shocks; two observed series |
| 4.3.1–4.3.6 | `s04_03_01` through `s04_03_06` | `s04_full_rep.mod` | Permanent changes versus one-period pulses; investment subsidy |
| 5.3.1–5.3.4 | `s05_03_01` through `s05_03_04` | `s05_03_full_rep.mod` | Anticipated g, consumption tax, capital tax, and a spending pulse |
| 5.3.5 | `s05_03_05_g_gamma02` and `s05_03_01_g` | Same Section 5.3 file | gamma=0.2 versus gamma=2, on the same panels |
| 5.3.6 | `s05_03_06_yields` | Same Section 5.3 file | Dated prices and yields; the full file reuses the spending solution |
| 5.4.1–5.4.3 | `s05_04_01` through `s05_04_03` | `s05_04_full_rep.mod` | Log consumption utility, labour supply, immediate versus anticipated policy |

Filenames in the short-example column omit `.mod`. Run the approximation before estimation in Sections 2 and 3, in the same folder. These are the only short examples with a data dependency. Section 6 remains reserved for the separate NT model.

## Reading the model and scenario

`k(-1)` is the capital available today; `k` is chosen today for use tomorrow. `c(+1)` is next-period consumption. In stochastic Euler equations Dynare supplies the conditional-expectation interpretation. In deterministic perfect foresight the announced future policy is known.

In Sections 4–5, simulation period 1 denotes text date t=0. A policy change at t=10 therefore starts in simulation period 11. `initval` provides the starting policy and guesses; `steady` computes the actual equilibrium. `endval; steady;` computes the terminal equilibrium for a permanent change. A one-period pulse keeps the original terminal equilibrium. `shocks` specifies the temporary exceptions to those baseline or terminal policy levels; `values` are **levels**, not innovations or percentage changes here.

`taui` in Section 4 is an investment **subsidy**, with purchase price `1-taui`. Section 5 omits that instrument. Section 5.4 uses gamma=1 and B=3 for log consumption and linear leisure.

## Commands beyond the basic model block

| Command or object | Where | Purpose |
|---|---|---|
| `check` | All sections | Checks local roots/rank around the steady state; not a replication test |
| `set_dynare_seed(2025)` | 2–3 | Repeats the same random-number sequence |
| `stoch_simul(order=2, periods=1000, drop=100, irf=40, nograph)` | 2.2, 3.2 | Second-order approximation, artificial data and 40-period IRFs; `nograph` suppresses figure creation |
| `drop=100` | 2.2, 3.2 | Discards initial observations for simulated moment reporting; it does not trim the saved `oo_.endo_simul` array |
| `varobs` / `estimated_params` | 2.3, 3.3 | Declares observations, starting values and prior distributions |
| `mode_compute=4` / `mh_replic=1000` | 2.3, 3.3 | Posterior-mode search followed by a short MCMC teaching run |
| `perfect_foresight_setup` / `perfect_foresight_solver` | 4–5 | Builds the announced policy path and solves the transition |
| Commented `tolf`, `tolx` settings | 4–5 | Optional tighter equation and step tolerances for numerical comparisons; ordinary runs use defaults |
| `shocks(overwrite)` | 4–5 | Clears any previous shock schedule; important when running several scenarios in one file |
| `verbatim; ... end;` | Data exports, 5.3.6, full files | Passes ordinary MATLAB/Octave commands through Dynare; use `%` comments inside this block |
| `M_.endo_names`, `M_.exo_names`, `M_.param_names` | Exports/full files | Names used to locate the desired series or parameter with `strcmp` |
| `oo_.endo_simul` / `oo_.exo_simul` | 2–5 | Solved/simulated paths; endogenous variables are rows, exogenous variables are columns |
| `oo_.irfs` | Full 2–3 | IRF fields combine a variable and a shock, e.g. `c_e` |
| `save`, transpose `'` | 2–3, full files | Saves named data series as columns in MAT files |
| Cells `{...}`, `for`, `subplot` | Full files | Stores scenario paths and draws the same panels without repeating the plotting code or introducing custom functions |
| `print`, `copyfile`, `fullfile` | Full files | Exports plots and gives Dynare density panels consistent output names |

For the fiscal files here, endogenous column 1 is the initial condition, columns 2:301 are the 300 simulated dates, and column 302 is the terminal condition. To plot capital **available** at t, use column 1 for the first date; to plot current consumption use column 2. The plotted saving return is explicitly labelled R_(t+1). The full files restore the original `oo_.steady_state` and `oo_.exo_steady_state` between experiments: Dynare does not permit another `initval` after an `endval`. Each subsequent `endval` then defines that scenario's terminal state.

The yield example normalizes q_0=1 and uses `-log(q_(t+i)/q_t)/i`, for maturities i=1,...,40. The full file's short rate uses the same continuously compounded convention. In stochastic IRF panels, period 0 is the pre-shock reference point.

A 1,000-draw chain demonstrates the estimation workflow; it does not establish convergence or identification. Approximation data are generated at second order and estimation uses the default first-order likelihood. The full-output files produce the section's exercises; agreement with the old worksheet figures is for the next replication review.

See [figure_map.md](figure_map.md) for the historical image → code → new output mapping. A historical `*_legacy.jpg` is preserved source material; the corresponding new `output/*.png` or density `.pdf` is generated by code. They have not yet been declared numerically equivalent.

See [dated prices and optional auxiliary calculations](q_and_auxiliaries.md) for the corrected 2025 `q` explanation, the `r/q`, `w/q`, `s/q`, `R` and `RBIG` mapping, and how to activate the commented fiscal epilogues.
