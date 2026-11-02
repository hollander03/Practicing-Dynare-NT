# Preserved 2025 fiscal sources

These files are historical copies, not the maintained participant entry points. Their original bytes and hashes are preserved.

**Erratum for `RMT_FP_final.mod` and `RMT_FP_exercises_k_pred_clean.mod`:** the comment beside the recursive `q` equation reverses the steady-state/unit-root diagnosis. With beta, dated prices decline at a constant allocation and forcing a constant level gives q=0. Without beta, the recursive level is undetermined and has a unit root unless normalized. Removing beta alone does not resolve the normalization problem.

See [dated prices and auxiliary quantities](../../../notes/q_and_auxiliaries.md) for the corrected derivation and mapping to the maintained code. Use `Code/sections` for short participant examples and `Code/full_replications` for section outputs.
