# Running the workbook examples

The `.mod` files in `sections/` each contain one model and one exercise. They calculate consumption, capital, real factor prices and returns without creating figures. The five files in `full_replications/` run the section exercises and produce the figures used in the workbook.

| Workbook | Individual files in `sections/` | Full-output file |
|---|---|---|
| 2.2–2.3 | `s02_02_growth_approx.mod`, `s02_03_growth_estimate.mod` | `s02_full_rep.mod` |
| 3.2–3.3 | `s03_02_twocountry_approx.mod`, `s03_03_twocountry_estimate.mod` | `s03_full_rep.mod` |
| 4.3.1–4.3.6 | `s04_03_01_g.mod`, `s04_03_02_tauc.mod`, `s04_03_03_taui.mod`, `s04_03_04_tauk.mod`, `s04_03_05_g.mod`, `s04_03_06_taui.mod` | `s04_full_rep.mod` |
| 5.3.1–5.3.5 | `s05_03_01_g.mod`, `s05_03_02_tauc.mod`, `s05_03_03_tauk.mod`, `s05_03_04_g.mod`, `s05_03_05_g_gamma02.mod` | `s05_03_full_rep.mod` |
| 5.3.6 | `s05_03_06_yields.mod` | `s05_03_full_rep.mod` |
| 5.4.1–5.4.3 | `s05_04_01_g.mod`, `s05_04_02_taun.mod`, `s05_04_03_taun.mod` | `s05_04_full_rep.mod` |

Add your Dynare installation to the MATLAB/Octave path, change to the directory containing the example, and run it:

```matlab
addpath('/Applications/Dynare/6.1-arm64/matlab');
dynare s05_03_01_g.mod
```

For the individual estimation examples in Sections 2 and 3, run the corresponding approximation file first, in the same directory. It saves the artificial observations used in estimation. Each full-output file generates its own required data and needs no helper script.

The fiscal models use `k(-1)` for beginning-of-period capital and `k` for the capital choice made during the current period. `r` is the real rental yield, `w` the real wage, `s` the current capital payoff and `R` the forward gross return. They are calculated directly in goods units. The price `q` is calculated from the solved consumption path only for the yield exercise in 5.3.6. It is not an additional model variable.

Full-output files save figures and plotted values under local `output/`. The workbook uses the same section-based figure names. The estimation examples use 1,000 MCMC draws to demonstrate the workflow; assess convergence and use longer chains before empirical interpretation.

`results_snapshot/` contains the saved numerical values used for the supplied figures. To redraw those plots without solving models, add the repository's `tools` folder to the MATLAB path and run `redraw_saved_figures`. The density PDFs are saved directly in `figures/`.

See [participant notes](../notes/README.md), [prices and returns](../notes/q_and_auxiliaries.md), and the [figure map](../notes/figure_map.md).
