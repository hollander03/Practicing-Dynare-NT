// -------------------------------------------------------------------------
// Section 3 | Approximation, simulated data and estimation
// -------------------------------------------------------------------------
// Self-contained: the data are generated before estimation in this file.

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
c1 = oo_.endo_simul(strcmp(M_.endo_names, 'c1'), :)';
k2 = oo_.endo_simul(strcmp(M_.endo_names, 'k2'), :)';
save('s03_simudata.mat', 'c1', 'k2');
end;

// 5. Plot only the IRFs used in the worksheet.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
if ~exist('output', 'dir')
    mkdir('output');
end
series = {'c1', 'c2', 'k1', 'k2', 'a1', 'a2'};
labels = {'Log consumption, c_{1,t}', 'Log consumption, c_{2,t}', ...
          'Log capital, k_{1,t}', 'Log capital, k_{2,t}', ...
          'Log productivity, a_{1,t}', 'Log productivity, a_{2,t}'};
figure('Position', [100 100 1000 600]);
% Fixed list of variable names; row selection does not change the model.
for panel = 1:numel(series)
    subplot(2, 3, panel);
    % oo_.irfs fields combine the variable and innovation names.
    response = oo_.irfs.([series{panel} '_e1']);
    plot(0:40, [0; response(:)], 'b', 'LineWidth', 1.2);
    title(labels{panel}); xlabel('Periods (0 = pre-shock)');
end
print(gcf, fullfile('output', 's03_02_twocountry_irfs.png'), '-dpng', '-r150');
% Simulation used nograph. Enable Dynare's prior/posterior plots below.
options_.nograph = false;
end;

// 6. Bayesian estimation
// The data file was generated above in this same run.
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
           mh_nblocks=1, graph_format=(png), nodisplay);

// Dynare saves density panels in this model's graphs/ directory.
// Copy the principal panels to the same output/ naming scheme as the IRFs.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
copyfile(fullfile(M_.fname, 'graphs', [M_.fname '_Priors1.png']), ...
         fullfile('output', 's03_03_priors.png'));
copyfile(fullfile(M_.fname, 'graphs', [M_.fname '_PriorsAndPosteriors1.png']), ...
         fullfile('output', 's03_03_posterior.png'));
end;
