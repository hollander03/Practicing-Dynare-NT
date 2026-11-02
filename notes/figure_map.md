# Worksheet figure map

The image contents are unchanged. Only filenames, LaTeX references and subsection placement were updated. Generated output shares the same stem, without `_legacy`. Original OCR filenames and byte hashes are retained in `review/figure_renames.json`.

| Worksheet | Historical figure in `figures/` | Full file in `Code/full_replications/` | New local output |
|---|---|---|---|
| 2.2 | `s02_02_growth_irfs_legacy.jpg` | `s02_full_rep.mod` | `output/s02_02_growth_irfs.png` |
| 2.3 | `s02_03_priors_legacy.jpg` | `s02_full_rep.mod` | `output/s02_03_priors.pdf` |
| 2.3 | `s02_03_posterior_legacy.jpg` | `s02_full_rep.mod` | `output/s02_03_posterior.pdf` |
| 3.2 | `s03_02_twocountry_irfs_legacy.jpg` | `s03_full_rep.mod` | `output/s03_02_twocountry_irfs.png` |
| 3.3 | `s03_03_posterior_legacy.jpg` | `s03_full_rep.mod` | `output/s03_03_posterior.pdf` |
| 4.3.1 | `s04_03_01_g_legacy.jpg` | `s04_full_rep.mod` | `output/s04_03_01_g.png` |
| 4.3.2 | `s04_03_02_tauc_legacy.jpg` | `s04_full_rep.mod` | `output/s04_03_02_tauc.png` |
| 4.3.3 | `s04_03_03_taui_legacy.jpg` | `s04_full_rep.mod` | `output/s04_03_03_taui.png` |
| 4.3.4 | `s04_03_04_tauk_legacy.jpg` | `s04_full_rep.mod` | `output/s04_03_04_tauk.png` |
| 4.3.5 | `s04_03_05_g_legacy.jpg` | `s04_full_rep.mod` | `output/s04_03_05_g.png` |
| 4.3.6 | `s04_03_06_taui_legacy.jpg` | `s04_full_rep.mod` | `output/s04_03_06_taui.png` |
| 5.3.1 | `s05_03_01_g_legacy.jpg` | `s05_03_full_rep.mod` | `output/s05_03_01_g.png` |
| 5.3.2 | `s05_03_02_tauc_legacy.jpg` | `s05_03_full_rep.mod` | `output/s05_03_02_tauc.png` |
| 5.3.3 | `s05_03_03_tauk_legacy.jpg` | `s05_03_full_rep.mod` | `output/s05_03_03_tauk.png` |
| 5.3.4 | `s05_03_04_g_legacy.jpg` | `s05_03_full_rep.mod` | `output/s05_03_04_g.png` |
| 5.3.5 | `s05_03_05_g_gamma_comparison_legacy.jpg` | `s05_03_full_rep.mod` | `output/s05_03_05_g_gamma_comparison.png` |
| 5.3.6 | `s05_03_06_yields_legacy.jpg` | `s05_03_full_rep.mod` | `output/s05_03_06_yields.png` |
| 5.4.1 | `s05_04_01_g_legacy.jpg` | `s05_04_full_rep.mod` | `output/s05_04_01_g.png` |
| 5.4.2 | `s05_04_02_taun_legacy.jpg` | `s05_04_full_rep.mod` | `output/s05_04_02_taun.png` |
| 5.4.3 | `s05_04_03_taun_legacy.jpg` | `s05_04_full_rep.mod` | `output/s05_04_03_taun.png` |

Section 3 also exports `output/s03_03_priors.pdf`, although the worksheet has no separate historical prior-only image. Fiscal runs save same-stem MAT files containing the plotted paths and baseline; the yield MAT file contains dated prices, yields and short rates. Dynare prints policy coefficients, steady states and posterior summaries to its usual console/log output.

The full files do not overwrite the historical images or replace the worksheet’s historical tables. Naming alignment is not a claim of numerical replication. Unused legacy assets and the two pre-existing `figures/Section 4` PNGs are unchanged.
