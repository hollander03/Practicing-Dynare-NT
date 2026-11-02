
// ----------------------------------------------------------------------------
// Practicing Dynare — Section 4 (cleaned & expanded)
// Full equilibrium system with taxes and government spending
// Compatible with recent Dynare versions (perfect_foresight_* workflow)
// 
// Model: Deterministic neoclassical growth with distorting taxes (τ_c, τ_i, τ_k)
// Reference equilibrium conditions (user-provided; see notes below).
// ----------------------------------------------------------------------------

// -----------------------------
// 1) Declarations
// -----------------------------

// Endogenous variables
var
    c   
    k   
    q   
    r   
    w   
    R   
    s   
    ;

// Exogenous (policy) processes — deterministic paths in perfect foresight sims
varexo
    g       
    tau_c   
    tau_i  
    tau_k  
    ;

// Parameters
parameters
    beta 
    delta
    A    
    alph
    gamma
    ;

// -----------------------------
// 2) Calibration (baseline)
// -----------------------------
beta  = 0.95;
delta = 0.2;
A     = 1.0;
alph = 0.33;
gamma = 2.0;

// Baseline exogenous levels (used via initval/endval below)
// g      = 0.2;
// tau_c  = 0.0;
// tau_i  = 0.0;
// tau_k  = 0.0;

// -----------------------------
// 3) Model block
// Notes on timing:
// - k is end-of-period capital (decided at t for t+1).
// - Equation numbering follows the user’s LaTeX list, with a recursive
//   definition for q to avoid explicit time index t in \\beta^t.
// -----------------------------
model;
    // (1) Resource constraint / feasibility
    // c_t = A k_t^α + (1-δ) k_t - k_{t+1} - g_t
    c = A*k^alph + (1 - delta)*k - k(+1) - g;

    // (2) Intertemporal price qt. From q_t = β^t c_t^{-γ} / (1+τ_{c,t}),
    //     we obtain the recursion:
    //     q_t / q_{t-1} = β * (c_t / c_{t-1})^{-γ} * (1+τ_{c,t-1})/(1+τ_{c,t}).
    //     Normalize q_0 > 0 in initval.
    q = q(-1) * beta * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);

    // (3) r_t / q_t = A α k_t^{α-1}  => r_t = q_t * A α k_t^{α-1}
    r = q * A * alph * k^(alph - 1);

    // (4) w_t / q_t = A k_t^{α} - k_t A α k_t^{α-1} = (1-α) A k_t^{α}
    //     (write as given to mirror the LaTeX expression)
    w = q * ( A * k^alph - k * A * alph * k^(alph - 1) );

    // (5) Gross return on saving (dated t+1 in the LaTeX; here R is at t)
    // R_{t+1}
    // = [(1+τ_{c,t})/(1+τ_{c,t+1})] * [ ((1+τ_{i,t+1})/(1+τ_{i,t}))(1-δ)
    //     + ((1-τ_{k,t+1})/(1-τ_{i,t})) A α k_{t+1}^{α-1} ]
    R = ((1 + tau_c) / (1 + tau_c(+1))) * ( ((1 + tau_i(+1)) / (1 + tau_i)) * (1 - delta)
        + ((1 - tau_k(+1)) / (1 - tau_i)) * A * alph * k(+1)^(alph - 1) );

    // (6) s_t / q_t = (1 - τ_{k,t}) A α k_t^{α-1} + (1 - δ)
    s = q * ( (1 - tau_k) * A * alph * k^(alph - 1) + (1 - delta) );

    // (7) Euler: c_t^{-γ} = β c_{t+1}^{-γ} R_{t+1}
    // In Dynare timing: R_{t+1} is R(+1)
    c^(-gamma) = beta * c(+1)^(-gamma) * R(+1);
end;

// -----------------------------
// 4) Steady state / initial & terminal values
// We use baseline constant taxes and g, and pick reasonable guesses.
// Perfect-foresight sims require initval (t=0) and endval (terminal SS).
// -----------------------------

// Baseline (t = 0) values
initval;
    // Exogenous policies
    g      = 0.2;
    tau_c  = 0.0;
    tau_i  = 0.0;
    tau_k  = 0.0;

    // Endogenous guesses
    // Choose k so that with A=1, alph=0.33, delta=0.2 we sit near SS.
    k = 1.5;
    c = A*k^alph + (1 - delta)*k - k - g;

    // Normalize q_0 > 0; with τ_c=0, set q consistent with c via (2)
    q = beta * (c/c)^(-gamma) * (1 + tau_c)/(1 + tau_c);  // = beta

    // r, w, s implied by definitions
    r = q * A * alph * k^(alph - 1);
    w = q * ( A * k^alph - k * A * alph * k^(alph - 1) );
    R = ((1 + tau_c) / (1 + tau_c)) * ( ((1 + tau_i) / (1 + tau_i)) * (1 - delta)
        + ((1 - tau_k) / (1 - tau_i)) * A * alph * k^(alph - 1) );
    s = q * ( (1 - tau_k) * A * alph * k^(alph - 1) + (1 - delta) );
end;

// Terminal (steady state) values under same policies
endval;
    g      = 0.2;
    tau_c  = 0.0;
    tau_i  = 0.0;
    tau_k  = 0.0;

    k = 1.5;
    c = A*k^alph + (1 - delta)*k - k - g;

    q = beta;
    r = q * A * alph * k^(alph - 1);
    w = q * ( A * k^alph - k * A * alph * k^(alph - 1) );
    R = ((1 + tau_c) / (1 + tau_c)) * ( ((1 + tau_i) / (1 + tau_i)) * (1 - delta)
        + ((1 - tau_k) / (1 - tau_i)) * A * alph * k^(alph - 1) );
    s = q * ( (1 - tau_k) * A * alph * k^(alph - 1) + (1 - delta) );
end;

// Compute steady states consistent with the above
steady;

// -----------------------------
// 5) Perfect foresight simulation scaffolding
// (uncomment and customize the shocks block to run experiments)
// -----------------------------

// Example: set up a 100-period horizon
perfect_foresight_setup(periods = 100);

// Example policy path (commented out):
 shocks;
     // One-time level increase in g at t=10 from 0.2 to 0.4
     var g;
     periods 1:10, 11:99;
     values 0.2, 0.4;
     %periods 11:100;
     %values 0.4;
 end;

// Solve
perfect_foresight_solver;

// -----------------------------
// 6) Notes
// - Equation (2) rewrites q_t = β^t c_t^{-γ}/(1+τ_{c,t}) in recursive form to 
//   avoid explicit time index t. This pins down q_t up to the normalization q_0.
// - Equations (3)–(6) define r_t, w_t, s_t, and R_{t+1} exactly as in the LaTeX.
// - Baseline calibration matches the table supplied by the user.
// - Use the shocks block to implement foreseen/unforeseen changes in g, τ_c, τ_i, τ_k.
// ----------------------------------------------------------------------------
