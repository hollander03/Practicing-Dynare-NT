# Practicing Dynare (Updated for Dynare 6)
Fiscal-Policy-Focused Training Exercises based on Ljungqvist & Sargent

This repository provides an updated and streamlined version of the original Practicing Dynare worksheet (Barillas et al., 2010). It modernises the codebase for Dynare v6, removes outdated syntax, and refocuses the material entirely on fiscal policy in deterministic and stochastic growth models.

It is designed for researchers, graduate students, and policymakers who want hands-on practice implementing fiscal instruments (taxes, government spending, anticipated vs. unanticipated policy) in simple DSGE/RBC environments.

The accompanying teaching document is available here:
👉 Overleaf: ([View Only](https://www.overleaf.com/read/cbpwghwvmyck#f1a82c)). Only collaborators have editing rights.

⸻

## 1. Overview

The repository contains a curated set of minimal, transparent Dynare examples that illustrate:
	•	How to approximate and estimate simple DSGE/RBC models.
	•	How to analyse permanent and temporary fiscal policy shocks.
	•	How to simulate foreseen and unforeseen changes in taxes and government spending.
	•	How to reproduce the main transition paths and diagrams from
Ljungqvist & Sargent (2004, 20XX), Chapter 11.

All examples have been rewritten for Dynare v6 to ensure reliable execution, modern syntax, and clean plotting.

⸻

## 2. Repository Structure (example)

/Practicing-Dynare/
│
├── README.md
├── docs/
│   └── Practicing_Dynare.pdf  (export from Overleaf)
│
├── section2_one_sector_growth/
│   ├── growth_approx.mod
│   └── growth_estimate.mod
│
├── section3_two_country_growth/         (optional extension)
│   ├── twocountry_approx.mod
│   └── twocountry_estimate.mod
│
├── section4_fiscal_policy_LS2004/       (core exercises)
│   ├── fig_11_3_1_g_increase.mod
│   ├── fig_11_3_2_tau_c_increase.mod
│   ├── fig_11_5_1_tau_i_increase.mod
│   ├── fig_11_5_2_tau_k_increase.mod
│   ├── fig_11_7_1_temp_g_shock.mod
│   └── fig_11_7_2_temp_tau_i_shock.mod
│
├── section5_fiscal_policy_LS20XX/       (updated/extended version)
│   ├── fig_11_6_1_foreseen_g.mod
│   ├── fig_11_6_4_foreseen_tau_c.mod
│   ├── fig_11_6_5_foreseen_tau_k.mod
│   ├── fig_11_6_6_foreseen_temp_g.mod
│   ├── fig_11_6_2_two_gamma_comparison.mod
│   └── yield_curve_experiments.mod
│
└── utils/
    ├── plotting.m
    └── helper_functions.m


⸻

## 3. Getting Started with Dynare 6

Before running any .mod file, ensure that Dynare v6 is correctly installed.

Step 1 — Install Dynare 6

Download from: (dynare.org)[https://www.dynare.org/download/]

Step 2 — Add Dynare to MATLAB/Octave Path

In MATLAB:

addpath /path/to/dynare/6.x/matlab
savepath

Step 3 — Verify Installation

dynare --version

Step 4 — Run an Example

In MATLAB:

cd section4_fiscal_policy_LS2004
dynare fig_11_3_1_g_increase.mod

Dynare will:
	1.	parse the model,
	2.	compute steady state(s),
	3.	run deterministic simulations,
	4.	produce transition paths and figures.

Step 5 — Working with Deterministic Transitions

Sections 4 and 5 rely heavily on:
	•	initval (initial steady state)
	•	endval (post-policy steady state)
	•	shocks … periods … values … end; (timing of policy changes)
	•	simul(periods = T); (deterministic transition)

These blocks are central to replicating the L&S Chapter 11 diagrams.

⸻

## 4. Contents by Section

Section 2 — One-Sector Stochastic Growth Model

Updates the classic stochastic neoclassical growth model with leisure.

Includes:
	•	linear and second-order approximations
	•	simulation of artificial data
	•	Bayesian or ML estimation of selected parameters

Purpose: provide the modelling and estimation basics before turning to fiscal policy.

⸻

Section 3 — Two-Country Growth Model (Optional)

Modernised version of the Kim & Kim (2003) two-country RBC example.

Not part of the core fiscal-policy teaching path, but included for completeness.

⸻

Section 4 — Fiscal Policy in LS (2004): Deterministic Growth Model

Main teaching module.
Implements the transition experiments from Recursive Macroeconomic Theory, Ch. 11 (2nd edition).

Exercises include:
	•	Permanent ↑ in government spending (g)
	•	Permanent ↑ in consumption tax (τc)
	•	Permanent ↑ in investment tax (τi)
	•	Permanent ↑ in capital tax (τk)
	•	One-time/pulse shocks (g and τi)

All timing conventions are adjusted for Dynare 6
(e.g., capital chosen at t−1 but used in t, tax policies treated as jump variables).

⸻

## Section 5 — Fiscal Policy in LS (20XX): Updated Version

Extends Section 4 to match the revised Chapter 11.

Additions include:
	•	foreseen (news) fiscal changes
	•	elastic labour supply
	•	yield curve responses
	•	comparisons across preference parameters
	•	richer visualisations

This section is ideal for illustrating policy anticipation, news shocks, and general equilibrium dynamics.

⸻

## Section 6 - National Treasury DSGE model 

Provides an introduction to the flexible price - i.e., real business cycle - version of the NT-DSGE model
