
// ----------------------------------------------------------------------------
// Full Equilibrium System (k predetermined) — Clean, with LaTeX & long names
// Convention example: tex_name='c_t', long_name='Consumption'
// ----------------------------------------------------------------------------

var
    c        
    k        
    q        
    r        
    w        
    R        
    s        
    // Auxiliaries for plotting
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

parameters
    beta   
    delta  
    A      
    alpha  
    gamma  
    ;

beta  = 0.95;
delta = 0.2;
A     = 1.0;
alpha = 0.33;
gamma = 2.0;

model;
    // Resource constraint with predetermined capital:
    // c_t = A k_{t-1}^α + (1-δ)k_{t-1} - k_t - g_t
    c = A*k(-1)^alpha + (1 - delta)*k(-1) - k - g;

    // Recursive pricing for q:
    q = q(-1) * beta * (c/c(-1))^(-gamma) * (1 + tau_c(-1)) / (1 + tau_c);

    // Marginal conditions using k_{t-1}
    r = q * A * alpha * k(-1)^(alpha - 1);
    w = q * ( A * k(-1)^alpha - k(-1) * A * alpha * k(-1)^(alpha - 1) );

    // Return consistent with Section 4 timing (11.3.8e + 11.3.8g)
    R = ((1 + tau_c(-1)) / (1 + tau_c)) * ( ((1 - tau_i) / (1 - tau_i(-1))) * (1 - delta)
        + ((1 - tau_k) / (1 - tau_i(-1))) * A * alpha * k(-1)^(alpha - 1) );

    // Saving return
    s = q * ( (1 - tau_k) * A * alpha * k(-1)^(alpha - 1) + (1 - delta) );

    // Euler
    c^(-gamma) = beta * c(+1)^(-gamma) * R;

    // Auxiliaries for plotting (so we don't have to compute with indices later)
    w_over_q = w / q;
    s_over_q = s / q;
    r_over_q = r / q;
    RBIG     = c^(-gamma) / ( beta * c(+1)^(-gamma) ); // should equal R
end;

initval;
    g     = 0.2;
    tau_c = 0.0;
    tau_i = 0.0;
    tau_k = 0.0;

    // Initial guesses
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

endval;
    g     = 0.2;
    tau_c = 0.0;
    tau_i = 0.0;
    tau_k = 0.0;

    // Initial guesses
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

steady;
check;

perfect_foresight_setup(periods = 100);
perfect_foresight_solver;
