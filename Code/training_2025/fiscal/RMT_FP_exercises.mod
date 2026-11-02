
// ----------------------------------------------------------------------------
// Section 4 Replication — 8 Experiments (k predetermined)
// Permanent & Once-off for each of: g, tau_c, tau_i, tau_k
// Uses auxiliaries (w_over_q, s_over_q, r_over_q, RBIG) for clean plotting
// ----------------------------------------------------------------------------

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
beta=0.95; delta=0.2; A=1; alpha=0.33; gamma=2;

// Model (same as fullsystem)
model;
    c = A*k(-1)^alpha + (1 - delta)*k(-1) - k - g;
    q = q(-1) * beta * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);
    r = q * A * alpha * k(-1)^(alpha - 1);
    w = q * ( A * k(-1)^alpha - k(-1) * A * alpha * k(-1)^(alpha - 1) );
    R = ((1 + tau_c(-1)) / (1 + tau_c)) * ( ((1 - tau_i) / (1 - tau_i(-1))) * (1 - delta)
        + ((1 - tau_k) / (1 - tau_i(-1))) * A * alpha * k(-1)^(alpha - 1) );
    s = q * ( (1 - tau_k) * A * alpha * k(-1)^(alpha - 1) + (1 - delta) );
    c^(-gamma) = beta * c(+1)^(-gamma) * R;

    w_over_q = w / q;
    s_over_q = s / q;
    r_over_q = r / q;
    RBIG     = c^(-gamma) / ( beta * c(+1)^(-gamma) );
end;

// Horizon & event time
@#define H=100
@#define T0=10

// Helper macro for a baseline block
@#define BASE_INIT 
initval; 
    g=0.2; tau_c=0; tau_i=0; tau_k=0; 
    k=1.5; c=0.6; q=beta; r=0.1; w=0.5; R=1/beta; s=1.0; 
    w_over_q = w/q; s_over_q = s/q; r_over_q = r/q; RBIG=R; 
end; 
steady; 
k0 = k; c0 = c; q0 = q; R0 = R; wq0 = w_over_q; sq0 = s_over_q; rq0 = r_over_q;

// -------- Plotting helper (MATLAB after-solver) --------
@#define PLOT_FIG(NAME)
figure('Name', NAME); 
subplot(2,3,1); plot([k0*ones(@{H},1)  oo_.endo_simul(get_index('k'),1:@{H})']);        title('k'); 
subplot(2,3,2); plot([c0*ones(@{H},1)  oo_.endo_simul(get_index('c'),2:@{H}+1)']);      title('c'); 
subplot(2,3,3); plot([R0*ones(@{H},1)  oo_.endo_simul(get_index('RBIG'),1:@{H})']);     title('R'); 
subplot(2,3,4); plot([wq0*ones(@{H},1) oo_.endo_simul(get_index('w_over_q'),1:@{H})']); title('w/q'); 
subplot(2,3,5); plot([sq0*ones(@{H},1) oo_.endo_simul(get_index('s_over_q'),1:@{H})']); title('s/q'); 
subplot(2,3,6); plot([rq0*ones(@{H},1) oo_.endo_simul(get_index('r_over_q'),1:@{H})']); title('r/q');

// ========================= g =========================
// Permanent
@#eval(BASE_INIT)
shocks; var g; periods 1:@{T0-1}, @{T0}:@{H}; values 0.2, 0.4; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('g — Permanent increase'))

// Once-off
@#eval(BASE_INIT)
shocks; var g; periods 1:@{T0-1}, @{T0}, @{T0+1}:@{H}; values 0.2, 0.4, 0.2; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('g — Once-off spike'))

// ========================= tau_c =========================
// Permanent
@#eval(BASE_INIT)
shocks; var tau_c; periods 1:@{T0-1}, @{T0}:@{H}; values 0.0, 0.2; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('tau_c — Permanent increase'))

// Once-off
@#eval(BASE_INIT)
shocks; var tau_c; periods 1:@{T0-1}, @{T0}, @{T0+1}:@{H}; values 0.0, 0.2, 0.0; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('tau_c — Once-off spike'))

// ========================= tau_i =========================
// Permanent
@#eval(BASE_INIT)
shocks; var tau_i; periods 1:@{T0-1}, @{T0}:@{H}; values 0.0, 0.2; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('tau_i — Permanent increase'))

// Once-off
@#eval(BASE_INIT)
shocks; var tau_i; periods 1:@{T0-1}, @{T0}, @{T0+1}:@{H}; values 0.0, 0.2, 0.0; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('tau_i — Once-off spike'))

// ========================= tau_k =========================
// Permanent
@#eval(BASE_INIT)
shocks; var tau_k; periods 1:@{T0-1}, @{T0}:@{H}; values 0.0, 0.2; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('tau_k — Permanent increase'))

// Once-off
@#eval(BASE_INIT)
shocks; var tau_k; periods 1:@{T0-1}, @{T0}, @{T0+1}:@{H}; values 0.0, 0.2, 0.0; end;
perfect_foresight_setup(periods=@{H});
perfect_foresight_solver;
@#eval(PLOT_FIG('tau_k — Once-off spike'))
