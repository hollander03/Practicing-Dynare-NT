# Numerical values used for the workbook figures

These MAT files preserve the successful run results used for the supplied figures. Fiscal files contain the plotted `time`, `paths` and `baseline` arrays; the curvature-comparison file also contains `gamma2_paths`. The yield file contains `q`, `yields`, `short_rate` and `discount`. The two IRF files contain the saved stochastic impulse responses.

Source runs: `review/run_logs/equilibrium_alignment/sections_stochastic.log`, `full_stochastic.log`, `sections_fiscal.log` and `full_fiscal.log`. The values were copied from those runs, not simulated again for the participant-edition cleanup. Removing the unused `qtilde` definition does not change any allocation, real factor price or return used in these plots.

Run `tools/redraw_saved_figures.m` to draw the plots again from these files. The five full `.mod` files remain self-contained and produce the same panels when run with their stated calibration and seeds. They do not depend on this snapshot folder.
