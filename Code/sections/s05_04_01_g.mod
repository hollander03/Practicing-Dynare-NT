// -------------------------------------------------------------------------
// Section 5.4.1 | Permanent g increase
// -------------------------------------------------------------------------
// 1. Variables and calibration
// c: consumption; k: capital chosen today. n: hours worked.
var
    c       // Consumption, c_t
    k       // Capital chosen during t, k_t (available in t+1)
    n       // Labour supplied, n_t
    r       // Current real rental yield, r_t (before depreciation)
    w       // Current real wage, w_t
    R       // Forward consumption-adjusted gross return, R_(t+1)
    s       // Current after-tax capital payoff, s_t
;
varexo
    g       // Government purchases
    tauc    // Consumption tax rate
    tauk    // Capital-income tax rate
    taun    // Labour-income tax rate
;

parameters beta delta A alpha gamma B;
beta  = 0.95;    // Discount factor
delta = 0.2;     // Depreciation rate
A     = 1;       // Productivity level
alpha = 0.33;    // Capital share
gamma = 1;       // Log-consumption utility
B     = 3;       // Weight on leisure

// 2. Equilibrium conditions: one equation per displayed condition.
// Text and code share Dynare timing: k(-1) is k_(t-1); k is k_t.
model;
    // (21) Resource constraint; k(-1) is capital available today.
    c = A*k(-1)^alpha*n^(1-alpha) + (1-delta)*k(-1) - k - g;

    // (22) Current real rental yield (before taxes and depreciation).
    r = A*alpha*k(-1)^(alpha-1)*n^(1-alpha);

    // (23) Current real wage; with n=1 it is also total labour income.
    w = A*(1-alpha)*k(-1)^alpha*n^(-alpha);

    // (24) Forward gross return R_(t+1) on saving at date t.
    // Capital chosen today earns the rental yield in period t+1.
    R = (1+tauc)/(1+tauc(+1))
        * (1-delta + (1-tauk(+1))*A*alpha*k^(alpha-1)*n(+1)^(1-alpha));

    // (25) Realized real capital payoff, distinct from forward R.
    s = (1-tauk)*r + 1-delta;

    // (26) Consumption Euler equation.
    c^(-gamma) = beta*c(+1)^(-gamma)*R;

    // (27) Consumption-leisure condition with the consumption-tax wedge.
    B*c*(1+tauc) = (1-taun)*w;
end;

// Eliminating r, w, R and s reduces this to the allocation model.
// The separate definitions also give the wages and returns to inspect.

// 3. Scenario | g rises permanently at text date t=0
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Initial steady state: guesses for c and k are refined by steady.
initval;
    g    = 0.2;
    tauc = 0;
    tauk = 0;
    taun = 0;
    k    = 1.5;
    c    = 0.4;
    n    = 0.4;
end;

steady;
check;

// Terminal steady state under the permanent new policy.
endval;
    g    = 0.4;
    tauc = 0;
    tauk = 0;
    taun = 0;
end;

steady;

// 4. Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;
