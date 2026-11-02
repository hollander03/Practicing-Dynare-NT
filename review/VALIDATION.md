# Execution validation — 2 November 2026

**Follow-up:** [TEACHING_ITERATION.md](TEACHING_ITERATION.md) records the participant-facing rewrite, full-output files, figure renames and current execution checks. The code/settings and validation hashes described below belong to the initial review pass; its hash register is preserved as `validated_sources_iteration1.json`.

Result: **19/19 reviewed section files executed successfully** using installed MATLAB R2024a Update 5 and Dynare 6.1 (arm64). This establishes execution, not numerical/textbook replication. Maintained-source hashes and associated execution logs are in [validated_sources.json](validated_sources.json).

| Checks | Result | Evidence |
|---|---|---|
| Section 2 approximation and simulated-data export | Pass | `run_logs/final_matlab.log` |
| Section 2 estimation, mode search and 1,000-draw MCMC | Pass | Same log, `NT_RUN_PASS s02_03_growth_estimate.mod` |
| Section 3 approximation and simulated-data export | Pass | Same log |
| Section 3 estimation, mode search and 1,000-draw MCMC | Pass | Same log, `NT_RUN_PASS s03_03_twocountry_estimate.mod` |
| All six Section 4 fiscal experiments | Pass | `run_logs/fiscal_final.log` |
| All six Section 5.3 examples, including gamma comparison and yield calculations | Pass | Same log |
| All three Section 5.4 labour experiments | Pass, labour in (0,1) | Same log |
| Independent resource/Euler equations over all 300 simulated periods | Pass, all 15 fiscal models | Same log, `PATH_PASS` entries |
| Labour first-order conditions and terminal convergence | Pass | Same log; verifier asserts these separately |
| All preserved source hashes; both former top-level repository models archived byte for byte | Pass | `source_manifest.json` checked against original files and Git HEAD |
| LaTeX syntax compilation, two passes | Pass, 46 pages generated under `/tmp/nt-tex-check` | `run_logs/latex_compile.log` |
| Visual inspection or historical/textbook replication | Not performed, as requested | Deferred |

Final fiscal files use `perfect_foresight_solver(tolf=1e-10,tolx=1e-10)`. The largest independently measured Euler residual is about 6.7e-11; the largest resource residual is about 5.5e-12. The separate verification requires every residual below 1e-6 and every last solved-period allocation within 1e-5 of its terminal steady state. Pulses also require identical initial and terminal steady states. Finite positive consumption/capital and interior labour are checked in the `.mod` files. The yield example checks that all computed yields are finite.

`final_matlab.log` includes all 19 successful runs at the earlier default fiscal tolerance. `fiscal_final.log` supersedes its fiscal entries with tighter-tolerance runs and independent checks, and is the evidence for the maintained fiscal source. `validated_sources.json` confirms that the exact maintained files match those final working copies.

Both estimation files use a fixed seed, bounded mode-search settings and one 1,000-draw chain. Dynare explicitly warns that the chains are too short for its MCMC convergence diagnostics. Posterior convergence, identification, reliable marginal likelihoods and equivalence to the historical posterior tables have **not** been established. Approximation data are generated at second order; estimation uses the default first-order likelihood. Existing worksheet numerical results were retained as historical material, not replaced with outputs from these short runs.

Octave was available but had no statistics package, so it could not run Dynare. MATLAB licensing required execution outside the filesystem sandbox; all review model outputs were directed to temporary directories. No software installations were made into the repository. PDF extraction used a temporary Python environment with PyMuPDF 1.26.5.

Earlier-attempt logs are retained for traceability: `initial_attempt.log` and `sections_matlab.log` record parser fixes and the superseded long mode search; `remaining_matlab.log` and `yields_matlab.log` capture the yield fix; `path_residuals.log` records the initial overly loose labour residual before solver tolerances were tightened. These are not final failure statuses.

The final LaTeX compile still reports float-placement adjustments and one overfull historical policy-function equation. These layout warnings were not visually assessed. Root-level LaTeX build artifacts appeared/changed during source editing; the explicit review compilation targeted `/tmp`, and no generated PDF is being certified or delivered as visually reviewed. The tracked build database and root-level generated artifacts were left alone.
