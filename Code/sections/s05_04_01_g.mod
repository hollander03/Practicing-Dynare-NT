// -------------------------------------------------------------------------
// Section 5.4.1 | Permanent g increase
// -------------------------------------------------------------------------
// 1. Variables and calibration
// c: consumption; k: capital chosen today. n: hours worked.
var
    c    // Consumption
    k    // Physical capital chosen today for use next period
    n    // Labour supplied (hours)
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

// 2. Equilibrium conditions
// k(-1) is used today; k earns its rental return next period.
model;
    // Resource constraint: output plus undepreciated capital.
    c = A*k(-1)^alpha*n^(1-alpha) + (1-delta)*k(-1) - k - g;

    // Euler equation: taxes and the capital payoff are dated t+1.
    c^(-gamma) = beta*c(+1)^(-gamma) * (1+tauc)/(1+tauc(+1))
        * (1-delta + (1-tauk(+1))*A*alpha*k^(alpha-1)*n(+1)^(1-alpha));

    // Labour condition: marginal disutility equals after-tax real wage.
    B*c^gamma*(1+tauc) = (1-taun)*(1-alpha)*A*k(-1)^alpha*n^(-alpha);
end;

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

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);


// 5. Optional interpretation epilogue (commented out)
// Keep the two/three-equation model above for the first exercise.
// To calculate plotting quantities, remove the block-comment markers below.
// These are ordinary MATLAB/Octave calculations, not extra model equations.
// The full files declare the corresponding observables inside model instead.
/*
verbatim;
% Locate simulated dates after the initial-condition padding.
% Each row below is aligned to current text dates t=0,...,T-1.
dates = (1:options_.periods) + M_.maximum_lag;
c_path = oo_.endo_simul(strcmp(M_.endo_names, 'c'), dates);
c_next = oo_.endo_simul(strcmp(M_.endo_names, 'c'), dates+1);
k_used = oo_.endo_simul(strcmp(M_.endo_names, 'k'), dates-1);
n_path = oo_.endo_simul(strcmp(M_.endo_names, 'n'), dates);

% Dynare stores parameter values in M_.params; select them by name.
productivity = M_.params(strcmp(M_.param_names, 'A'));
capital_share = M_.params(strcmp(M_.param_names, 'alpha'));
depreciation = M_.params(strcmp(M_.param_names, 'delta'));
discount = M_.params(strcmp(M_.param_names, 'beta'));
curvature = M_.params(strcmp(M_.param_names, 'gamma'));
capital_tax = oo_.exo_simul(dates, strcmp(M_.exo_names, 'tauk'))';

% Real factor prices: the dated-price factor q cancels analytically.
r_over_q = productivity*capital_share .* k_used.^(capital_share-1) ...
           .* n_path.^(1-capital_share);
w_over_q = productivity*(1-capital_share) .* k_used.^capital_share ...
           .* n_path.^(-capital_share);
s_over_q = (1-capital_tax).*r_over_q + 1-depreciation;

% Euler-implied saving return R_(t+1), called RBIG in the 2025 code.
% It equals the full file's R; do not add a second equilibrium restriction.
RBIG = (c_path./c_next).^(-curvature) / discount;
% No plots are created here; these aligned series are ready for inspection.
end;
*/
