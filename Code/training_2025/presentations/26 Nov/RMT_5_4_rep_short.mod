// ----------------------------------------------------------------------------
// Section 5 Replication — CLEAN exercises (k predetermined)
// Permanent & Once-off for g and tau_n
// ----------------------------------------------------------------------------

// -----------------------------
// 1) Model
// -----------------------------
var
    c
    k
    q
    r
    w
    n
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
    tau_n
    ;

parameters beta delta A alpha gamma B;
beta  = 0.95;
delta = 0.2;
A     = 1.0;
alpha = 0.33;
gamma = 2.0;
B = 3;

model;

    // Resource constraint
    c = A*k(-1)^alpha * n^(1-alpha) + (1 - delta)*k(-1) - k - g;

    // q recursion
    q = q(-1) * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);

    // Returns
    r = q * A * alpha * k(-1)^(alpha - 1) * n^(1-alpha);
    w = q * A * (1 - alpha) * (k(-1)/n)^alpha;

    // Gross return R
    R = ((1 + tau_c(-1)) / (1 + tau_c)) *
        ((1 - delta) + (1 - tau_k)*A*alpha*k(-1)^(alpha - 1)*n(1)^(1-alpha));

    // Labour-leisure
    B / c^(-gamma) = (1 - tau_n) * ((1 - alpha)*A*k(-1)^alpha * n^(-alpha));

    // Saving return
    s = q * ((1 - tau_k)*A*alpha*k(-1)^(alpha - 1)*n^(1-alpha) + (1 - delta));

    // Euler
    c^(-gamma) = beta * c(+1)^(-gamma) * R;

    // Aux variables
    w_over_q = w / q;
    s_over_q = s / q;
    r_over_q = r / q;
    RBIG     = c^(-gamma) / (beta * c(+1)^(-gamma));

end;

initval;
    g     = 0.2;
    tau_c = 0.0;
    tau_k = 0.0;
    tau_n = 0.0;

    k     = 1.5;
    c     = 0.6;
    n     = 1.02;
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

steady;
check;

// Indices
ik     = strmatch('k',        M_.endo_names, 'exact');
ic     = strmatch('c',        M_.endo_names, 'exact');
in     = strmatch('n',        M_.endo_names, 'exact');
iR     = strmatch('RBIG',     M_.endo_names, 'exact');
iwq    = strmatch('w_over_q', M_.endo_names, 'exact');

ig     = strmatch('g',        M_.exo_names, 'exact');
itau_n = strmatch('tau_n',    M_.exo_names, 'exact');

// Baseline steady-state values for overlays
k0     = oo_.steady_state(ik);
c0     = oo_.steady_state(ic);
n0     = oo_.steady_state(in);
R0     = oo_.steady_state(iR);
wq0    = oo_.steady_state(iwq);
g0     = 0.2;
tau_n0 = 0.0;

// Horizon
H = 40;

// -------------------------------------------------------------------
// 2) PLOTTING FUNCTION — 6 variables: k, c, R, w/q, n, policy shock
// -------------------------------------------------------------------
function plot6(name, H, endo_sim, exo_sim, ik, ic, in, iR, iwq, i_exo, ...
               k0, c0, n0, R0, wq0, exo0, exo_name)

    figure('Name', name);

    subplot(2,3,1); plot([k0*ones(H,1) endo_sim(ik,1:H)']);    title('k');
    subplot(2,3,2); plot([c0*ones(H,1) endo_sim(ic,2:H+1)']);  title('c');
    subplot(2,3,3); plot([R0*ones(H,1) endo_sim(iR,1:H)']);    title('R');

    subplot(2,3,4); plot([wq0*ones(H,1) endo_sim(iwq,2:H+1)']); title('w/q');
    subplot(2,3,5); plot([n0*ones(H,1) endo_sim(in,2:H+1)']);   title('n');

    subplot(2,3,6); plot([exo0*ones(H,1) exo_sim(1:H,i_exo)]); title(exo_name);

end;

// -------------------------------------------------------------------
// 3) Experiments
// -------------------------------------------------------------------

// ===== g: Permanent =====
shocks;
    var g;
    periods 1:9 10:200;
    values  0.2 0.4;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

plot6('g — Permanent increase', H, oo_.endo_simul, oo_.exo_simul, ...
      ik, ic, in, iR, iwq, ig, ...
      k0, c0, n0, R0, wq0, g0, 'g');

// ===== g: Once-off =====
shocks;
    var g;
    periods 1:9 10 11:200;
    values  0.2 0.4 0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

plot6('g — Once-off spike', H, oo_.endo_simul, oo_.exo_simul, ...
      ik, ic, in, iR, iwq, ig, ...
      k0, c0, n0, R0, wq0, g0, 'g');

// ===== tau_n: Permanent =====
shocks;
    var tau_n;
    periods 1:9 10:200;
    values  0.0 0.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

plot6('tau_n — Permanent increase', H, oo_.endo_simul, oo_.exo_simul, ...
      ik, ic, in, iR, iwq, itau_n, ...
      k0, c0, n0, R0, wq0, tau_n0, 'tau_n');

// ===== tau_n: Once-off =====
shocks;
    var tau_n;
    periods 1:9 10 11:200;
    values  0.0 0.2 0.0;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

plot6('tau_n — Once-off spike', H, oo_.endo_simul, oo_.exo_simul, ...
      ik, ic, in, iR, iwq, itau_n, ...
      k0, c0, n0, R0, wq0, tau_n0, 'tau_n');
