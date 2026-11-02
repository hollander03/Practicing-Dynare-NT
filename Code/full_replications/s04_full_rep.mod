// -------------------------------------------------------------------------
// Section 4 | All six fiscal transitions
// -------------------------------------------------------------------------
// Self-contained: run this file once; no helper .m files are needed.
// Outputs are written to output/ in the current working directory.

// 1. Variables and calibration
// c: consumption; k: capital chosen today.
// Every equilibrium price and return is explicit, as in the guide.
var
    c       // Consumption, c_t
    k       // Capital chosen today (textbook k_(t+1))
    qtilde  // Detrended price c_t^(-gamma)/(1+tauc_t)
    r       // Current real rental yield, r_t (before depreciation)
    w       // Current real wage, w_t
    R       // Forward consumption-adjusted gross return, R_(t+1)
    s       // Current after-tax capital payoff, s_t
;
varexo
    g       // Government purchases
    tauc    // Consumption tax rate
    taui    // Investment subsidy rate (purchase price is 1-taui)
    tauk    // Capital-income tax rate
;

parameters beta delta A alpha gamma;
beta  = 0.95;    // Discount factor
delta = 0.2;     // Depreciation rate
A     = 1;       // Productivity level
alpha = 0.33;    // Capital share
gamma = 2;       // CRRA consumption curvature
// taui is an investment subsidy: the investment purchase price is 1-taui.

// 2. Equilibrium conditions: one equation per displayed condition.
// Code k is chosen at t and becomes textbook k_(t+1); k(-1) is textbook k_t.
model;
    // (7) Resource constraint; k(-1) is capital available today.
    c = A*k(-1)^alpha + (1-delta)*k(-1) - k - g;

    // (8) Detrended marginal-utility price; dated q_t = beta^t*qtilde_t.
    // This algebraic definition fixes the level; it is not a q recursion.
    qtilde = c^(-gamma)/(1+tauc);

    // (9) Current real rental yield (before taxes and depreciation).
    r = A*alpha*k(-1)^(alpha-1);

    // (10) Current real wage; with n=1 it is also total labour income.
    w = A*(1-alpha)*k(-1)^alpha;

    // (11) Forward gross return R_(t+1) on saving at date t.
    // Expand the future rental yield to retain dependence on today's k
    // even at the final simulated date (where future r is a boundary value).
    R = (1+tauc)/(1+tauc(+1))
        * ((1-taui(+1))*(1-delta) + (1-tauk(+1))*A*alpha*k^(alpha-1))/(1-taui);

    // (12) Realized real capital payoff, distinct from forward R.
    s = (1-tauk)*r + 1-delta;

    // (13) Consumption Euler equation.
    c^(-gamma) = beta*c(+1)^(-gamma)*R;
end;

// Store scenario results in cells; each cell contains one solved path.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions = {};
policies = {};
end;

// -------------------------------------------------------------------------
// Example 4.3.1 | g permanent change
// -------------------------------------------------------------------------
// Eliminating qtilde, r, w, R and s reduces this to the allocation model.
// They remain explicit here so the code matches the displayed conditions.

// 3. Scenario | g rises permanently at text date t=10
// Policy is known at t=0. Simulation period 1 corresponds to text t=0.
// Initial steady state: guesses for c and k are refined by steady.
initval;
    g    = 0.2;
    tauc = 0;
    taui = 0;
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
    taui = 0;
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

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{1} = oo_.endo_simul;
policies{1} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 4.3.2 | tauc permanent change
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
    taui = 0;
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

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{2} = oo_.endo_simul;
policies{2} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 4.3.3 | taui permanent change
// -------------------------------------------------------------------------
// 5. Scenario | taui rises permanently at text date t=10
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
    taui = 0.2;
    tauk = 0;
end;

steady;

// Keep the old policy through t=9; endval applies from t=10 onward.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var taui;
    periods 1:10;
    values 0;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{3} = oo_.endo_simul;
policies{3} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 4.3.4 | tauk permanent change
// -------------------------------------------------------------------------
// 6. Scenario | tauk rises permanently at text date t=10
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
    taui = 0;
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

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{4} = oo_.endo_simul;
policies{4} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 4.3.5 | g pulse
// -------------------------------------------------------------------------
// 7. Scenario | g rises for one period at text date t=10
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
    taui = 0;
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

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{5} = oo_.endo_simul;
policies{5} = oo_.exo_simul;
end;

// -------------------------------------------------------------------------
// Example 4.3.6 | taui pulse
// -------------------------------------------------------------------------
// 8. Scenario | taui rises for one period at text date t=10
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
    taui = 0;
    tauk = 0;
end;

steady;
// One-period increase; all other periods keep the baseline value.
// overwrite clears the previous shock schedule in multi-example files.
shocks(overwrite);
    var taui;
    periods 11;
    values 0.2;
end;

// Solve the transition; a long horizon lets the path settle down.
perfect_foresight_setup(periods=300);
perfect_foresight_solver;

// Optional accuracy settings for numerical residual comparisons:
// perfect_foresight_solver(tolf=1e-10, tolx=1e-10);

// Keep this solution; all panels are drawn together at the end.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
solutions{6} = oo_.endo_simul;
policies{6} = oo_.exo_simul;
end;


// Output panels: one common plotting block, with no custom functions.
// verbatim copies this block unchanged into the generated MATLAB/Octave
// program. It is not a Dynare equilibrium block; use % comments inside.
verbatim;
if ~exist('output', 'dir')
    mkdir('output');
end

time = (0:39)';
series = {'k', 'c', 'R', 'w', 's', 'r'};
labels = {'Capital available, k_t', 'Consumption, c_t', 'Saving return, R_{t+1}', 'Real wage, w_t', 'Realized capital payoff, s_t', 'Rental yield, r_t'};
filenames = {'s04_03_01_g', ...
             's04_03_02_tauc', ...
             's04_03_03_taui', ...
             's04_03_04_tauk', ...
             's04_03_05_g', ...
             's04_03_06_taui'};

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
