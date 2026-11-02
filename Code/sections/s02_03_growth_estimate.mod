// -------------------------------------------------------------------------
// Section 2.3 | Bayesian estimation
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

// 4. Bayesian estimation
// First run s02_02_growth_approx.mod in this folder.
// Each row gives a starting value, prior family, prior mean and prior SD.
// Section 2 fixes s=0.007 and estimates stderr(e), not both shock scales.
varobs c;

estimated_params;
    stderr e, 1, inv_gamma_pdf, 1, 0.2;
    rho, 0.95, beta_pdf, 0.93, 0.02;
    the, 0.357, beta_pdf, 0.3, 0.05;
    tau, 2, normal_pdf, 2.1, 0.3;
end;

set_dynare_seed(2025);
// mode_compute=4 searches for the posterior mode before sampling.
// A short teaching chain; increase mh_replic for empirical inference.
estimation(datafile=s02_simudata, mode_compute=4, mh_replic=1000,
           mh_nblocks=1, nograph, nodisplay);
