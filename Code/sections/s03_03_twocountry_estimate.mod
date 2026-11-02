// -------------------------------------------------------------------------
// Section 3.3 | Bayesian estimation
// -------------------------------------------------------------------------
// 1. Variables and parameters
// All endogenous variables are logs. Countries share consumption under
// complete markets; each country has its own capital and productivity.
var
    c1    // Log consumption in country 1
    c2    // Log consumption in country 2
    k1    // Log capital chosen in country 1
    k2    // Log capital chosen in country 2
    a1    // Log productivity in country 1
    a2    // Log productivity in country 2
;
varexo
    e1    // Productivity innovation in country 1
    e2    // Productivity innovation in country 2
;

parameters gamma delta alpha beta rho;
gamma = 2;       // Consumption curvature
delta = 0.05;   // Depreciation rate
alpha = 0.4;    // Capital share
beta  = 0.98;   // Discount factor
rho   = 0.85;   // Productivity persistence

// 2. Equilibrium conditions
// exp(k1(-1)) and exp(k2(-1)) are the capital stocks used today.
model;
    // Complete risk sharing between identical households.
    c1 = c2;

    // Euler equations for investment in each country.
    exp(c1)^(-gamma) = beta * exp(c1(+1))^(-gamma)
        * (alpha*exp(a1(+1))*exp(k1)^(alpha-1) + 1-delta);

    exp(c2)^(-gamma) = beta * exp(c2(+1))^(-gamma)
        * (alpha*exp(a2(+1))*exp(k2)^(alpha-1) + 1-delta);

    // World output finances consumption and net capital accumulation.
    exp(c1) + exp(c2) + exp(k1) - (1-delta)*exp(k1(-1))
        + exp(k2) - (1-delta)*exp(k2(-1)) =
        exp(a1)*exp(k1(-1))^alpha + exp(a2)*exp(k2(-1))^alpha;

    // Country-specific productivity processes.
    a1 = rho*a1(-1) + e1;
    a2 = rho*a2(-1) + e2;
end;

// 3. Initial guesses in logs, and innovation standard deviations.
initval;
    k1 = 2.8;
    k2 = 2.8;
    c1 = 0.8;
    c2 = 0.8;
    a1 = 0;
    a2 = 0;
end;

shocks;
    var e1; stderr 0.08;
    var e2; stderr 0.08;
end;

steady;
check;

// 4. Bayesian estimation
// First run s03_02_twocountry_approx.mod in this folder.
// Each row gives a starting value, prior family, prior mean and prior SD.
varobs c1 k2;

estimated_params;
    rho, 0.85, beta_pdf, 0.84, 0.05;
    alpha, 0.4, beta_pdf, 0.38, 0.03;
    stderr e1, 0.08, inv_gamma_pdf, 0.078, 0.02;
    stderr e2, 0.08, inv_gamma_pdf, 0.082, 0.02;
end;

set_dynare_seed(2025);
// mode_compute=4 searches for the posterior mode before sampling.
// A short teaching chain; increase mh_replic for empirical inference.
estimation(datafile=s03_simudata, mode_compute=4, mh_replic=1000,
           mh_nblocks=1, nograph, nodisplay);
