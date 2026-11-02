// -------------------------------------------------------------------------
// Section 5.3.6 | Permanent g increase
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

// 3. Scenario | g rises permanently at text date t=10
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

// Terminal steady state under the permanent new policy.
endval;
    g    = 0.4;
    tauc = 0;
    tauk = 0;
end;

steady;

// Keep the old policy through t=9; endval applies from t=10 onward.
shocks(overwrite);
    var g;
    periods 1:10;
    values 0.2;
end;

// 4. Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;


// Additional calculation for Section 5.3.6: dated prices and yields.
// This is MATLAB/Octave code, not another equilibrium equation.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
% M_.endo_names identifies the consumption row in Dynare's solution.
% Column 1 is the initial condition; columns 2:301 are simulated dates.
cons = oo_.endo_simul(strcmp(M_.endo_names, 'c'), 2:302);

% Parameters live in M_.params; select them by name rather than position.
discount = M_.params(strcmp(M_.param_names, 'beta'));
curvature = M_.params(strcmp(M_.param_names, 'gamma'));

% Normalize the date-zero Arrow-Debreu price to one, including tax wedges.
% The consumption tax is zero in this spending experiment; retaining it
% makes the pricing formula explicit if the scenario is later modified.
consumption_tax = oo_.exo_simul(2:302, strcmp(M_.exo_names, 'tauc'))';
q = discount.^(0:300) .* (cons/cons(1)).^(-curvature) ...
    .* (1+consumption_tax(1))./(1+consumption_tax);

% Each column is a date t=0,...,60; each row a maturity of 1,...,40.
% Continuously compounded yields; maturity zero would divide by zero.
yields = zeros(40, 61);
% Fixed dates and maturities only: each cell is assigned once.
% date+maturity is at most 101, within the 301-element price path.
for date = 1:61
    for maturity = 1:40
        yields(maturity, date) = -log(q(date+maturity)/q(date))/maturity;
    end
end
end;
