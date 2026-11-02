// -------------------------------------------------------------------------
// Section 2 | Approximation, simulated data and estimation
// -------------------------------------------------------------------------
// Self-contained: the data are generated before estimation in this file.

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

// 5. Plot only the IRFs used in the worksheet.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
if ~exist('output', 'dir')
    mkdir('output');
end
series = {'c', 'k', 'lab', 'z'};
figure;
% Fixed list of variable names; row selection does not change the model.
for panel = 1:numel(series)
    subplot(2, 2, panel);
    % oo_.irfs fields combine the variable and innovation names.
    response = oo_.irfs.([series{panel} '_e']);
    plot(0:40, [0; response(:)], 'b', 'LineWidth', 1.2);
    title(series{panel}); xlabel('Periods (0 = pre-shock)');
end
print(gcf, fullfile('output', 's02_02_growth_irfs.png'), '-dpng', '-r150');
% Simulation used nograph. Enable Dynare's prior/posterior plots below.
options_.nograph = false;
end;

// 6. Bayesian estimation
// The data file was generated above in this same run.
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
           mh_nblocks=1, graph_format=(pdf), nodisplay);

// Dynare saves density panels in this model's graphs/ directory.
// Copy the principal panels to the same output/ naming scheme as the IRFs.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
copyfile(fullfile(M_.fname, 'graphs', [M_.fname '_Priors1.pdf']), ...
         fullfile('output', 's02_03_priors.pdf'));
copyfile(fullfile(M_.fname, 'graphs', [M_.fname '_PriorsAndPosteriors1.pdf']), ...
         fullfile('output', 's02_03_posterior.pdf'));
end;
