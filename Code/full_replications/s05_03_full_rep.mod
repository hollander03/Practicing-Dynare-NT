// -------------------------------------------------------------------------
// Section 5.3 | Anticipation, curvature and yields
// -------------------------------------------------------------------------
// Self-contained: run this file once; no helper .m files are needed.
// Outputs are written to output/ in the current working directory.

// 1. Variables and calibration
// c: consumption; k: capital chosen today.
// Every equilibrium price and return is explicit, as in the guide.
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

// Store scenario results in cells; each cell contains one solved path.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions = {};
policies = {};
end;

// -------------------------------------------------------------------------
// Example 5.3.1 | g permanent change
// -------------------------------------------------------------------------
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

// Remember the common starting point for the later experiments.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
initial_steady = oo_.steady_state;
initial_policy = oo_.exo_steady_state;
end;

// Terminal steady state under the permanent new policy.
endval;
    g    = 0.4;
    tauc = 0;
    tauk = 0;
end;

steady;

// Keep the old policy through t=9; endval applies from t=10 onward.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var g;
    periods 1:10;
    values 0.2;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;


// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{1} = oo_.endo_simul;
policies{1} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 5.3.2 | tauc permanent change
// -------------------------------------------------------------------------
// 4. Scenario | tauc rises permanently at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Start this experiment from the original baseline, not the last policy.
// Dynare does not allow another initval block after an endval block.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
oo_.steady_state = initial_steady;
oo_.exo_steady_state = initial_policy;
end;

steady;
check;

// Terminal steady state under the permanent new policy.
endval;
    g    = 0.2;
    tauc = 0.2;
    tauk = 0;
end;

steady;

// Keep the old policy through t=9; endval applies from t=10 onward.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var tauc;
    periods 1:10;
    values 0;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;


// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{2} = oo_.endo_simul;
policies{2} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 5.3.3 | tauk permanent change
// -------------------------------------------------------------------------
// 5. Scenario | tauk rises permanently at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Start this experiment from the original baseline, not the last policy.
// Dynare does not allow another initval block after an endval block.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
oo_.steady_state = initial_steady;
oo_.exo_steady_state = initial_policy;
end;

steady;
check;

// Terminal steady state under the permanent new policy.
endval;
    g    = 0.2;
    tauc = 0;
    tauk = 0.2;
end;

steady;

// Keep the old policy through t=9; endval applies from t=10 onward.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var tauk;
    periods 1:10;
    values 0;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;


// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{3} = oo_.endo_simul;
policies{3} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 5.3.4 | g pulse
// -------------------------------------------------------------------------
// 6. Scenario | g rises for one period at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Start this experiment from the original baseline, not the last policy.
// Dynare does not allow another initval block after an endval block.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
oo_.steady_state = initial_steady;
oo_.exo_steady_state = initial_policy;
end;

steady;
check;

// The pulse ends at the original steady state.
endval;
    g    = 0.2;
    tauc = 0;
    tauk = 0;
end;

steady;
// One-period increase; all other periods keep the baseline value.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var g;
    periods 11;
    values 0.4;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;


// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{4} = oo_.endo_simul;
policies{4} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 5.3.5 | g permanent change
// -------------------------------------------------------------------------
// 7. Scenario | g rises permanently at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
gamma = 0.2;

// Start this experiment from the original baseline, not the last policy.
// Dynare does not allow another initval block after an endval block.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
oo_.steady_state = initial_steady;
oo_.exo_steady_state = initial_policy;
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
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var g;
    periods 1:10;
    values 0.2;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;


// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{5} = oo_.endo_simul;
policies{5} = oo_.exo_simul;
end;

// Output panels: one common plotting block, with no custom functions.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
if ~exist('output', 'dir')
    mkdir('output');
end

time = (0:39)';
series = {'k', 'c', 'R', 'r'};
labels = {'Capital, k_{t-1}', 'Consumption, c_t', 'Gross return, R_{t+1}', 'Rental yield, r_t'};
filenames = {'s05_03_01_g', ...
             's05_03_02_tauc', ...
             's05_03_03_tauk', ...
             's05_03_04_g', ...
             's05_03_05_g_gamma_comparison'};
policy_names = {'g', 'tauc', 'tauk', 'g', 'g'};

% All policy paths have already been solved in the explicit blocks above.
% This loop only reads saved paths and draws one figure per scenario.
for example = 1:numel(solutions)
    solution = solutions{example};
    paths = zeros(40, 5);
    baseline = zeros(1, size(paths, 2));

    % Select each variable by name, not its declaration position.
    % Fixed list of variable names; row selection does not change the model.
    for panel = 1:numel(series)
        row = strcmp(M_.endo_names, series{panel});
        baseline(panel) = solution(row, 1);
        if strcmp(series{panel}, 'k')
            % Use yesterday's capital choice: capital available at date t.
            paths(:, panel) = solution(row, 1:40)';
        else
            % Column 2 is the first simulated date, t=0.
            paths(:, panel) = solution(row, 2:41)';
        end
    end

    % Exogenous series also include one initial-condition row here.
    column = strcmp(M_.exo_names, policy_names{example});
    paths(:, end) = policies{example}(2:41, column);
    baseline(end) = policies{example}(1, column);
    labels{5} = policy_names{example};

    if example == 1
        gamma2_paths = paths;
        gamma2_baseline = baseline;
    end

    figure('Position', [100 100 1000 600]);
    % One column per labelled panel; no parameters or policy paths change.
    for panel = 1:size(paths, 2)
        subplot(2, 3, panel);
        if example == 5
            % Compare both curvature values in the same panel.
            plot(time, baseline(panel)*ones(40, 1), '--k', ...
                 time, gamma2_paths(:, panel), 'b', ...
                 time, paths(:, panel), '-.r', 'LineWidth', 1.2);
        else
            plot(time, baseline(panel)*ones(40, 1), '--k', ...
                 time, paths(:, panel), 'b', 'LineWidth', 1.2);
        end
        title(labels{panel});
        xlabel('Time t');
    end
    if example == 5
        legend('Initial steady state', 'gamma=2', 'gamma=0.2');
    end

    % Save the figure and the plotted values using the same filename.
    print(gcf, fullfile('output', [filenames{example} '.png']), ...
          '-dpng', '-r150');
    save(fullfile('output', [filenames{example} '.mat']), ...
         'time', 'paths', 'baseline');
end
% Also retain both economies in the comparison data file.
save(fullfile('output', 's05_03_05_g_gamma_comparison.mat'), ...
     'time', 'gamma2_paths', 'paths', 'baseline');
gamma2_solution = solutions{1};
gamma2_beta = M_.params(strcmp(M_.param_names, 'beta'));
end;

// -------------------------------------------------------------------------
// Example 5.3.6 | Yield curves for the gamma=2 spending change
// -------------------------------------------------------------------------
// Reuse Example 5.3.1 rather than solving the same experiment again.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
cons = gamma2_solution(strcmp(M_.endo_names, 'c'), 2:302);
% Retain the tax wedge explicitly; it is constant in this g experiment.
consumption_tax = policies{1}(2:302, strcmp(M_.exo_names, 'tauc'))';
q = gamma2_beta.^(0:300) .* (cons/cons(1)).^(-2) ...
    .* (1+consumption_tax(1))./(1+consumption_tax);
q_baseline = gamma2_beta.^(0:39);
short_rate = -log(q(2:end)./q(1:end-1));
short_baseline = -log(gamma2_beta);

yields = zeros(40, 61);
% Fixed dates and maturities only: each cell is assigned once.
% date+maturity is at most 101, within the 301-element price path.
for date = 1:61
    for maturity = 1:40
        yields(maturity, date) = -log(q(date+maturity)/q(date))/maturity;
    end
end

figure('Position', [100 100 1000 600]);
subplot(2, 3, 1);
plot(time, gamma2_baseline(2)*ones(40, 1), '--k', time, cons(1:40), 'b');
title('Consumption'); xlabel('Time t');

subplot(2, 3, 2);
plot(time, q_baseline, '--k', time, q(1:40), 'b');
title('Dated price, q_t'); xlabel('Time t');

subplot(2, 3, 3);
plot(time, short_baseline*ones(40, 1), '--k', time, short_rate(1:40), 'b');
title('Continuously compounded short rate'); xlabel('Time t');

subplot(2, 3, 4);
% Columns 1, 11 and 61 correspond to dates t=0, 10 and 60.
plot(1:40, yields(:, 1), 'b', 1:40, yields(:, 11), '-.r', ...
     1:40, yields(:, 61), '--k');
title('Yield curves'); xlabel('Maturity');
legend('t=0', 't=10', 't=60');

subplot(2, 3, 5);
plot(time, gamma2_baseline(5)*ones(40, 1), '--k', ...
     time, gamma2_paths(:, 5), 'b');
title('Government spending'); xlabel('Time t');

print(gcf, fullfile('output', 's05_03_06_yields.png'), '-dpng', '-r150');
save(fullfile('output', 's05_03_06_yields.mat'), 'q', 'yields', 'short_rate');
end;
