
// ----------------------------------------------------------------------------
// Section 4 Replication — CLEAN exercises (k predetermined)
// Permanent & Once-off for each of: g, tau_c, tau_i, tau_k
// No macros; standard Dynare/Matlab only
// ----------------------------------------------------------------------------

// -----------------------------
// 1) Model (self-contained)
// -----------------------------
var
    c
    k
    q
    r
    w
    R
    s
    w_over_q
    s_over_q
    r_over_q
    RBIG
    ;

varexo
    g
    tau_c
    tau_i
    tau_k
    ;

parameters beta delta A alpha gamma;
beta  = 0.95;
delta = 0.2;
A     = 1.0;
alpha = 0.33;
gamma = 2.0;

model;
    // Resource constraint (k predetermined)
    c = A*k(-1)^alpha + (1 - delta)*k(-1) - k - g;

    // Recursive price of claim 
    % NOTE: using the equation as stated implies a unit root for "q" -> model still solves fine since q not necessary for core solution, but ...
    % it gives a warning in Newton solver before successfully converging the SS value for q to numerically zero...
    % we can avoid this by redefining "q" as a stationary kernal simply by dropping beta
    % q = q(-1) * beta * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);
    q = q(-1) * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);

    // Marginals with k(-1)
    r = q * A * alpha * k(-1)^(alpha - 1);
    w = q * ( A * k(-1)^alpha - k(-1) * A * alpha * k(-1)^(alpha - 1) );

    // Return (Section 4 timing)
    R = ((1 + tau_c(-1)) / (1 + tau_c)) * ( ((1 - tau_i) / (1 - tau_i(-1))) * (1 - delta)
        + ((1 - tau_k) / (1 - tau_i(-1))) * A * alpha * k(-1)^(alpha - 1) );

    // Saving return
    s = q * ( (1 - tau_k) * A * alpha * k(-1)^(alpha - 1) + (1 - delta) );

    // Euler
    c^(-gamma) = beta * c(+1)^(-gamma) * R;

    // Auxiliaries for plotting
    w_over_q = w / q;
    s_over_q = s / q;
    r_over_q = r / q;
    RBIG     = c^(-gamma) / ( beta * c(+1)^(-gamma) ); // equals R in equilibrium
end;

initval;
    g     = 0.2;
    tau_c = 0.0;
    tau_i = 0.0;
    tau_k = 0.0;

    k     = 1.5;
    c     = 0.6;
    q     = beta;
    r     = 0.1;
    w     = 0.5;
    R     = 1/beta;
    s     = 1.0;

    w_over_q = w/q;
    s_over_q = s/q;
    r_over_q = r/q;
    RBIG     = R;
end;

/*
endval;
    g     = 0.4;
    tau_c = 0.0;
    tau_i = 0.0;
    tau_k = 0.0;

    k     = 1.5;
    c     = 0.6;
    q     = beta;
    r     = 0.1;
    w     = 0.5;
    R     = 1/beta;
    s     = 1.0;

    w_over_q = w/q;
    s_over_q = s/q;
    r_over_q = r/q;
    RBIG     = R;
end;
*/

steady;
check;

// Indices (robust to order)
ik  = strmatch('k',        M_.endo_names, 'exact');
ic  = strmatch('c',        M_.endo_names, 'exact');
iR  = strmatch('RBIG',     M_.endo_names, 'exact');
iwq = strmatch('w_over_q', M_.endo_names, 'exact');
isq = strmatch('s_over_q', M_.endo_names, 'exact');
irq = strmatch('r_over_q', M_.endo_names, 'exact');

// Baseline steady values for overlay
k0  = oo_.steady_state(ik);
c0  = oo_.steady_state(ic);
R0  = oo_.steady_state(iR);
wq0 = oo_.steady_state(iwq);
sq0 = oo_.steady_state(isq);
rq0 = oo_.steady_state(irq);

// Horizon and event time
H  = 100; % # of periods for plotting
T0 = 10;  % redundant -> dynare does not allow non-integers in var shock block

// Helper for plotting a 2x3 grid
function plot6(name, H, endo_sim, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0)
figure('Name', name);
subplot(2,3,1); plot([k0*ones(H,1)  endo_sim(ik,1:H)']);   title('k');
subplot(2,3,2); plot([c0*ones(H,1)  endo_sim(ic,2:H+1)']); title('c');
%subplot(2,3,2); plot([c0*ones(H,1)  endo_sim(ic,1:H)']); title('c');
subplot(2,3,3); plot([R0*ones(H,1)  endo_sim(iR,1:H)']);   title('R');
%subplot(2,3,4); plot([wq0*ones(H,1) endo_sim(iwq,1:H)']);  title('w/q');
subplot(2,3,4); plot([wq0*ones(H,1) endo_sim(iwq,2:H+1)']);  title('w/q');
subplot(2,3,5); plot([sq0*ones(H,1) endo_sim(isq,1:H)']);  title('s/q');
%subplot(2,3,6); plot([rq0*ones(H,1) endo_sim(irq,1:H)']);  title('r/q');
subplot(2,3,6); plot([rq0*ones(H,1) endo_sim(irq,2:H+1)']);  title('r/q');
end

// -----------------------------
// 2) Experiments
// -----------------------------

// ===== g: Permanent =====
shocks;
    var g;
    %periods 1:(T0-1)  T0:H;
    periods 1:9 10:200; % also set to length of periods
    values  0.2 0.4;
end;

perfect_foresight_setup(periods=200); % set # of periods to 200 to ensure the “bend toward terminal SS” happens out of view.
perfect_foresight_solver;
%perfect_foresight_solver(stack_solve_algo=0, maxit=80, tolf=1e-12, tolx=1e-12); % Default Newton + sparse LU (algorithm 0)
%perfect_foresight_solver(stack_solve_algo=1, maxit=80, tolf=1e-12, tolx=1e-12); % LBJ (algorithm 1) — often robust for PF paths

plot6('g — Permanent increase', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

// ===== g: Once-off =====
shocks;
    var g;
    %periods 1:(T0-1)  T0:H;
    periods 1:9  10 11:200; % also set to length of periods
    values  0.2  0.4  0.2;
end;
perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('g — Once-off spike', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);


%/*

// Reset to baseline for tax experiments
shocks;
    var g;     periods 1:200;     values 0.2;
    var tau_c; periods 1:200;     values 0.0;
    var tau_i; periods 1:200;     values 0.0;
    var tau_k; periods 1:200;     values 0.0;
end;

// ===== tau_c: Permanent =====
shocks;
    var tau_c;
    %periods 1:(T0-1)  T0:H;
    periods 1:9  10:200;
    values  0.0       0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('tau_c — Permanent increase', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

// ===== tau_c: Once-off =====
shocks;
    var tau_c;
%periods 1:(T0-1)  T0  (T0+1):H;
    periods 1:9  10 11:200;
    values  0.0  0.2 0.0;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('tau_c — Once-off spike', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

// Reset baseline
shocks;
    var g;     periods 1:200;     values 0.2;
    var tau_c; periods 1:200;     values 0.0;
    var tau_i; periods 1:200;     values 0.0;
    var tau_k; periods 1:200;     values 0.0;
end;

// ===== tau_i: Permanent =====
shocks;
    var tau_i;
    %periods 1:(T0-1)  T0:H;
    periods 1:9  10:200;
    values  0.0       0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('tau_i — Permanent increase', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

// ===== tau_i: Once-off =====
shocks;
    var tau_i;
%periods 1:(T0-1)  T0  (T0+1):H;
    periods 1:9  10 11:200;
    values  0.0       0.2 0.0;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('tau_i — Once-off spike', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

// Reset baseline
shocks;
    var g;     periods 1:200;     values 0.2;
    var tau_c; periods 1:200;     values 0.0;
    var tau_i; periods 1:200;     values 0.0;
    var tau_k; periods 1:200;     values 0.0;
end;

// ===== tau_k: Permanent =====
shocks;
    var tau_k;
    %periods 1:(T0-1)  T0:H;
    periods 1:9  10:200;
    values  0.0       0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('tau_k — Permanent increase', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

// ===== tau_k: Once-off =====
shocks;
    var tau_k;
    %periods 1:(T0-1)  T0  (T0+1):H;
    periods 1:9  10 11:200;
    values  0.0       0.2 0.0;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot6('tau_k — Once-off spike', H, oo_.endo_simul, ik, ic, iR, iwq, isq, irq, k0, c0, R0, wq0, sq0, rq0);

%*/