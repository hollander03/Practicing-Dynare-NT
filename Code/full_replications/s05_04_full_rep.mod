// -------------------------------------------------------------------------
// Section 5.4 | All three labour-supply experiments
// -------------------------------------------------------------------------
// Self-contained: run this file once; no helper .m files are needed.
// Outputs are written to output/ in the current working directory.

// 1. Variables and calibration
// c: consumption; k: capital chosen today. n: hours worked.
// Extra variables record returns and factor prices for the output panels.
var
    c                // Consumption
    k                // Physical capital chosen today for use next period
    n                // Labour supplied (hours)
    R                // Consumption-adjusted return on saving today, R_(t+1)
    rental           // Current real rental rate, r_t/q_t
    wage             // Current real wage, w_t/q_t
    saving_return    // Realized real capital payoff, s_t/q_t
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
    c^(-gamma) = beta*c(+1)^(-gamma)*R;

    // R is the consumption-adjusted return on saving today.
    // The Euler-implied RBIG is identical in equilibrium, so no duplicate
    // endogenous equation/variable is needed (see the optional short-file epilogue).
    R = (1+tauc)/(1+tauc(+1))
        * (1-delta + (1-tauk(+1))*A*alpha*k^(alpha-1)*n(+1)^(1-alpha));

    // Labour condition: marginal disutility equals after-tax real wage.
    B*c^gamma*(1+tauc) = (1-taun)*(1-alpha)*A*k(-1)^alpha*n^(-alpha);

    // Current rental and wage in consumption-good units (r/q and w/q).
    // Calculate the ratios directly; no recursive q state or division by q.
    rental = A*alpha*k(-1)^(alpha-1)*n^(1-alpha);
    wage = A*(1-alpha)*k(-1)^alpha*n^(-alpha);

    // Realized payoff on capital, before any investment-price adjustment.
    saving_return = (1-tauk)*rental + 1-delta;
end;

// Store scenario results in cells; each cell contains one solved path.
verbatim;
solutions = {};
policies = {};
end;

// -------------------------------------------------------------------------
// Example 5.4.1 | g permanent change
// -------------------------------------------------------------------------
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

// Remember the common starting point for the later experiments.
verbatim;
initial_steady = oo_.steady_state;
initial_policy = oo_.exo_steady_state;
end;

// Terminal steady state under the permanent new policy.
endval;
    g    = 0.4;
    tauc = 0;
    tauk = 0;
    taun = 0;
end;

steady;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
verbatim;
solutions{1} = oo_.endo_simul;
policies{1} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 5.4.2 | taun permanent change
// -------------------------------------------------------------------------
// 4. Scenario | taun rises permanently at text date t=0
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Start this experiment from the original baseline, not the last policy.
// Dynare does not allow another initval block after an endval block.
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
    tauk = 0;
    taun = 0.2;
end;

steady;

// Immediate change: clear any earlier anticipated shock schedule.
shocks(overwrite);
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
verbatim;
solutions{2} = oo_.endo_simul;
policies{2} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 5.4.3 | taun permanent change
// -------------------------------------------------------------------------
// 5. Scenario | taun rises permanently at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Start this experiment from the original baseline, not the last policy.
// Dynare does not allow another initval block after an endval block.
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
    tauk = 0;
    taun = 0.2;
end;

steady;

// Keep the old policy through t=9; endval applies from t=10 onward.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var taun;
    periods 1:10;
    values 0;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
verbatim;
solutions{3} = oo_.endo_simul;
policies{3} = oo_.exo_simul;
end;


// Output panels: one common plotting block, with no custom functions.
verbatim;
if ~exist('output', 'dir')
    mkdir('output');
end

time = (0:39)';
series = {'k', 'c', 'R', 'wage', 'n'};
labels = {'Capital available, k_t', 'Consumption, c_t', 'Saving return, R_{t+1}', 'Real wage', 'Hours worked, n_t'};
filenames = {'s05_04_01_g', ...
             's05_04_02_taun', ...
             's05_04_03_taun'};
policy_names = {'g', 'taun', 'taun'};

% All policy paths have already been solved in the explicit blocks above.
% This loop only reads saved paths and draws one figure per scenario.
for example = 1:numel(solutions)
    solution = solutions{example};
    paths = zeros(40, 6);
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
    labels{6} = policy_names{example};

    figure;
    % One column per labelled panel; no parameters or policy paths change.
    for panel = 1:size(paths, 2)
        subplot(2, 3, panel);
        plot(time, baseline(panel)*ones(40, 1), '--k', ...
             time, paths(:, panel), 'b', 'LineWidth', 1.2);
        title(labels{panel});
        xlabel('Time t');
    end

    % Local output names match the worksheet's historical figure stems.
    print(gcf, fullfile('output', [filenames{example} '.png']), ...
          '-dpng', '-r150');
    save(fullfile('output', [filenames{example} '.mat']), ...
         'time', 'paths', 'baseline');
end
end;

