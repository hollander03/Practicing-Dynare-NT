// -------------------------------------------------------------------------
// Section 5.3.4 | One-period g increase
// -------------------------------------------------------------------------
// 1. Variables and calibration
// c: consumption; k: capital chosen today.
var
    c       // Consumption, c_t
    k       // Capital chosen during t, k_t (available in t+1)
    r       // Current real rental yield, r_t (before depreciation)
    w       // Current real wage, w_t
    R       // Forward consumption-adjusted gross return, R_(t+1)
    s       // Current after-tax capital payoff, s_t
;
varexo
    g       // Government purchases
    tauc    // Consumption tax rate
    tauk    // Capital-income tax rate
;

parameters beta delta A alpha gamma;
beta  = 0.95;    // Discount factor
delta = 0.2;     // Depreciation rate
A     = 1;       // Productivity level
alpha = 0.33;    // Capital share
gamma = 2;       // CRRA consumption curvature

// 2. Equilibrium conditions: one equation per displayed condition.
// Text and code share Dynare timing: k(-1) is k_(t-1); k is k_t.
model;
    // (13) Resource constraint; k(-1) is capital available today.
    c = A*k(-1)^alpha + (1-delta)*k(-1) - k - g;

    // (14) Current real rental yield (before taxes and depreciation).
    r = A*alpha*k(-1)^(alpha-1);

    // (15) Current real wage; with n=1 it is also total labour income.
    w = A*(1-alpha)*k(-1)^alpha;

    // (16) Forward gross return R_(t+1) on saving at date t.
    // Capital chosen today earns the rental yield in period t+1.
    R = (1+tauc)/(1+tauc(+1))
        * (1-delta + (1-tauk(+1))*A*alpha*k^(alpha-1));

    // (17) Consumption Euler equation.
    c^(-gamma) = beta*c(+1)^(-gamma)*R;

    // (18) Realized real capital payoff, distinct from forward R.
    s = (1-tauk)*r + 1-delta;
end;

// Eliminating r, w, R and s reduces this to the allocation model.
// The separate definitions also give the wages and returns to inspect.

// 3. Scenario | g rises for one period at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Initial steady state: guesses for c and k are refined by steady.
initval;
    g    = 0.2;
    tauc = 0;
    tauk = 0;
    k    = 1.5;
    c    = 0.4;
end;

steady;
check;

// No endval block: the pulse returns to the initial steady state.
// One-period increase; all other periods keep the baseline value.
shocks(overwrite);
    var g;
    periods 11;
    values 0.4;
end;

// 4. Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;
