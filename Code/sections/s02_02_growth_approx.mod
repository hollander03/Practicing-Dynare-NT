// -------------------------------------------------------------------------
// Section 2.2 | One-sector growth | Approximation
// -------------------------------------------------------------------------
// 1. Variables and parameters
// c: consumption; k: capital chosen today; lab: hours; z: log productivity.
var
    c      // Consumption
    k      // Physical capital chosen today for use next period
    lab    // Labour supplied (hours)
    z      // Log productivity
;
varexo
    e    // Standardized productivity innovation
;

parameters bet the del alp tau rho s;
bet = 0.987;    // Discount factor
the = 0.357;   // Consumption share in the consumption-leisure composite
del = 0.012;   // Depreciation rate
alp = 0.4;     // Capital share
tau = 2;       // Curvature of utility
rho = 0.95;    // Persistence of productivity
s   = 0.007;   // Scale multiplying the productivity innovation

// 2. Equilibrium conditions
// k(-1) is the capital available today; k is used in production tomorrow.
model;
    // Euler equation: today's marginal utility equals the expected
    // discounted marginal utility of next period's capital payoff.
    (c^the * (1-lab)^(1-the))^(1-tau) / c =
        bet * (c(+1)^the * (1-lab(+1))^(1-the))^(1-tau) / c(+1)
        * (1 + alp*exp(z(+1))*k^(alp-1)*lab(+1)^(1-alp) - del);

    // Intratemporal condition: consumption versus leisure.
    c = the/(1-the) * (1-alp) * exp(z) * k(-1)^alp
        * lab^(-alp) * (1-lab);

    // Resource constraint and capital accumulation.
    k = exp(z)*k(-1)^alp*lab^(1-alp) - c + (1-del)*k(-1);

    // Stationary log-productivity process.
    z = rho*z(-1) + s*e;
end;

// 3. Initial guesses; steady solves for the actual steady state.
initval;
    k   = 10;
    c   = 0.7;
    lab = 0.3;
    z   = 0;
end;

shocks;
    var e; stderr 1;
end;

steady;
check;

// 4. Approximation and artificial data
// Fixing the seed makes repeated runs use the same random innovations.
set_dynare_seed(2025);
// nograph suppresses figures; the computed IRFs remain in oo_.irfs.
stoch_simul(order=2, periods=1000, drop=100, irf=40, nograph);

// Export the observed series for the estimation example.
// verbatim passes ordinary MATLAB/Octave code through the Dynare parser.
// strcmp selects a row by name; the apostrophe makes a column of data.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
c = oo_.endo_simul(strcmp(M_.endo_names, 'c'), :)';
save('s02_simudata.mat', 'c');
end;
