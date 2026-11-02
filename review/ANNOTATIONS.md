# Annotation register

Extracted from the original fiscal PDF without rendering. IDs follow PDF annotation iteration order. Plain highlights are navigation/scope marks, not automatic correction instructions. Full metadata and selected text are in `annotations.json`.

| ID | PDF page | Type | Marked text / comment | Disposition |
|---|---|---|---|---|
| A01 | 1 | Highlight | Section 4 follows chapter 11 of Ljungqvist and Sargent (2004) in studying the eﬀects of foreseen ﬁscal policy in a non-stochastic growth model. | Scope retained: Section 4 fiscal experiments. |
| A02 | 1 | Highlight | permanent tax shocks (transitions to different steady states / init_val to end_values) | Implemented explicit endval steady states for permanent changes. |
| A03 | 1 | Highlight | This paper describes nine examples or types of examples that illustrate how Dynare can approximate the solutions of dynamic rational expectations models, simulate them, and estimate them by maximum likelihood and Bayesian methods. | Replaced obsolete nine-example introduction with actual repository scope. |
| A04 | 1 | Highlight | Section 2 approximates and estimates a one-sector stochastic growth model. Section 3 approximates and estimates a two-country stochastic growth model. | Created Section 2 and 3 approximation and estimation files. |
| A05 | 1 | Text | Work up to the end of Section 5 | Scope checked through Section 5; Section 6 remains explicitly unimplemented. |
| A06 | 1 | Highlight | Appendix A tells how the reader can obtain the ﬁle examples.zip that contain the *.mod and data ﬁles that we used to generate these examples. | Removed nonexistent examples.zip instructions; added local inventory. |
| A07 | 1 | Highlight | be cautious: because this is an old tutorial, in some cases, code may be deprecated which may lead to errors. Learning to bug fix on these small examples is a good practice though ;-) | Modernised commands; execution evidence recorded separately. |
| A08 | 1 | Underline | This application is interesting, among other reasons, for the way that it illustrates how Dynare can implement the ‘diﬀuse Kalman ﬁlter’ needed in situations in which an initial endogenous state variable is unknown and the model has a unit root. | Outside Sections 2–5: no diffuse-filter example added. |
| A09 | 2 | StrikeOut | periods 1000; | Removed standalone periods statement; periods is a stoch_simul option. |
| A10 | 3 | StrikeOut | stoch_simul(dr_algo=0,periods=1000); | Retained simulation, removed dr_algo; explicit order=2. |
| A11 | 3 | StrikeOut | save simudata | Saved named observable c in section-specific MAT file, rather than a whole workspace. |
| A12 | 4 | StrikeOut | periods 1000; | Removed standalone periods statement. |
| A13 | 8 | StrikeOut | periods 1000; | Removed standalone periods statement. |
| A14 | 9 | StrikeOut | stoch_simul(dr_algo=0,periods=1000); | Retained simulation, removed dr_algo; explicit order=2. |
| A15 | 9 | StrikeOut | save simudata | Saved named c1 and k2 observables to section-specific MAT file. |
| A16 | 9 | StrikeOut | periods 1000; | Removed standalone periods statement. |
| A17 | 11 | Highlight | Fiscal policies in the growth model | Retained Section 4. |
| A18 | 11 | Highlight | This section describes a suite of Dynare programs that replicate the transition experiments performed in chapter 11 of Ljungqvist and Sargent (2004). | Retained experiment set; numerical replication deferred. |
| A19 | 11 | Highlight | chapter 11 of Ljungqvist and Sargent (2004). | Retained second-edition reference for Section 4. |
| A20 | 12 | Highlight | 4.3 Transition experiments | Created all six Section 4 transition files. |
| A21 | 12 | Highlight | −τit) | Interpreted 1-taui consistently as investment subsidy; fixed return signs to match household expenditure. |
| A22 | 12 | Highlight | + wt} | Removed wage income from government tax revenue (no labour tax in Section 4). |
| A23 | 15 | Highlight | A permanent increase in τc | Created consumption-tax experiment. |
| A24 | 16 | Highlight | A permanent increase in τi | Created investment-subsidy experiment; terminology clarified. |
| A25 | 18 | Highlight | One time increase in g | Created one-period spending pulse with unchanged terminal steady state. |
| A26 | 21 | Highlight | 5. Fiscal policies in the growth model | Created all Section 5.3 and 5.4 examples. |
| A27 | 38 | Highlight | The demand for money during hyperinﬂations | Outside worksheet scope; no hyperinflation section added. |
