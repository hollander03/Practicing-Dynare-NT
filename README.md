# Practicing Dynare: a fiscal policy focus

**02 November 2026 — Work-in-Progress — Not for Distribution**

This guide updates *Practicing Dynare* by Barillas et al. (2010), with fiscal-policy applications drawn from Ljungqvist and Sargent’s *Recursive Macroeconomic Theory*. The main document is [practice_dynare_FP.tex](practice_dynare_FP.tex).

- [Model files and run instructions](Code/README.md)
- [Participant command notes](notes/README.md)
- [Factor prices, returns and bond prices](notes/q_and_auxiliaries.md)
- [Figure map](notes/figure_map.md)

Sections 2–3 introduce stochastic growth, simulation and estimation. Sections 4–5 study fiscal transitions, anticipated policy and labour supply. Section 6 is reserved for a full-scale flexible-price fiscal model. The models include definitions, calibration values and matching code.

The guide uses PNG figures throughout. Saved simulation values and numerical teaching summaries are in `Code/full_replications/results_snapshot`. The simulation figures can be redrawn without solving models using `tools/redraw_saved_figures.m`; the three estimation-density PNGs are supplied in `figures/`. Figures not used by the current workbook are stored in `figures/archive/`.

The [Overleaf project](https://www.overleaf.com/read/cbpwghwvmyck#f1a82c) is linked to this GitHub repository. Its main document is `practice_dynare_FP.tex`.

The earlier NT-specific [2025 training collection](https://github.com/hollander03/dsge-training-nt/tree/main/training/2025) is maintained in the separate NT training repository. Use the model files linked above for the current workbook.
