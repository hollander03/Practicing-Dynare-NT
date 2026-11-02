// ----------------------------------------------------------------------------
// Section 5 Replication — CLEAN exercises (k predetermined)
// Permanent & Once-off for each of: g, tau_c, tau_k
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
    q = q(-1) * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);

    // Marginals with k(-1)
    r = q * A * alpha * k(-1)^(alpha - 1);
    w = q * ( A * k(-1)^alpha - k(-1) * A * alpha * k(-1)^(alpha - 1) );

    // Return (Section 4 timing)
    R = ((1 + tau_c(-1)) / (1 + tau_c)) * ((1 - delta)
        + (1 - tau_k) * A * alpha * k(-1)^(alpha - 1));

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
ik     = strmatch('k',        M_.endo_names, 'exact');
ic     = strmatch('c',        M_.endo_names, 'exact');
iR     = strmatch('RBIG',     M_.endo_names, 'exact');
irq    = strmatch('r_over_q', M_.endo_names, 'exact');
ig     = strmatch('g',        M_.exo_names, 'exact');
itau_c = strmatch('tau_c',    M_.exo_names, 'exact');
itau_k = strmatch('tau_k',    M_.exo_names, 'exact');

// Baseline steady values for overlay
k0     = oo_.steady_state(ik);
c0     = oo_.steady_state(ic);
R0     = oo_.steady_state(iR);
rq0    = oo_.steady_state(irq);
g0     = 0.2;   // Use initval value for exogenous g
tau_c0 = 0.0;   // Use initval value for exogenous tau_c
tau_k0 = 0.0;   // Use initval value for exogenous tau_k

// Horizon and event time
H  = 40; % # of periods for plotting
T0 = 10; % redundant -> dynare does not allow non-integers in var shock block

// Helper for plotting a 2x3 grid (generalized for any exogenous policy variable)
function plot5(name, H, endo_sim, exo_sim, ik, ic, iR, irq, i_exo, k0, c0, R0, rq0, exo0, exo_name)
    figure('Name', name);
    subplot(2,3,1); plot([k0*ones(H,1)  endo_sim(ik,1:H)']);   title('k');
    subplot(2,3,2); plot([c0*ones(H,1)  endo_sim(ic,2:H+1)']); title('c');
    subplot(2,3,3); plot([R0*ones(H,1)  endo_sim(iR,1:H)']);   title('R');
    subplot(2,3,4); plot([rq0*ones(H,1) endo_sim(irq,2:H+1)']); title('r/q');
    subplot(2,3,5); plot([exo0*ones(H,1)  exo_sim(1:H,i_exo)]);    title(exo_name);
end

// -----------------------------
// 2) Experiments
// -----------------------------

// ===== g: Permanent =====
shocks;
    var g;
    periods 1:9 10:200;
    values  0.2 0.4;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot5('g — Permanent increase', H, oo_.endo_simul, oo_.exo_simul, ik, ic, iR, irq, ig, k0, c0, R0, rq0, g0, 'g');

// ===== g: Once-off =====
shocks;
    var g;
    periods 1:9 10 11:200;
    values  0.2 0.4 0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot5('g — Once-off spike', H, oo_.endo_simul, oo_.exo_simul, ik, ic, iR, irq, ig, k0, c0, R0, rq0, g0, 'g');

// ===== tau_c: Permanent =====
shocks;
    var tau_c;
    periods 1:9 10:200;
    values  0.0 0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot5('tau_c — Permanent increase', H, oo_.endo_simul, oo_.exo_simul, ik, ic, iR, irq, itau_c, k0, c0, R0, rq0, tau_c0, 'tau_c');

// ===== tau_c: Once-off =====
shocks;
    var tau_c;
    periods 1:9 10 11:200;
    values  0.0 0.2 0.0;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot5('tau_c — Once-off spike', H, oo_.endo_simul, oo_.exo_simul, ik, ic, iR, irq, itau_c, k0, c0, R0, rq0, tau_c0, 'tau_c');

// ===== tau_k: Permanent =====
shocks;
    var tau_k;
    periods 1:9 10:200;
    values  0.0 0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot5('tau_k — Permanent increase', H, oo_.endo_simul, oo_.exo_simul, ik, ic, iR, irq, itau_k, k0, c0, R0, rq0, tau_k0, 'tau_k');

// ===== tau_k: Once-off =====
shocks;
    var tau_k;
    periods 1:9 10 11:200;
    values  0.0 0.2 0.0;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
plot5('tau_k — Once-off spike', H, oo_.endo_simul, oo_.exo_simul, ik, ic, iR, irq, itau_k, k0, c0, R0, rq0, tau_k0, 'tau_k');