// ======================================================================
// rbc_tax_model.mod — FIXED VERSION (no syntax errors)
// ======================================================================

var y c i k n w r t g z;
varexo eps_pers eps_once;

parameters beta delta alpha chi eta rho_z sigma_pers sigma_once tau_k tau_n Gbar;

// Parameters
beta      = 0.99;
delta     = 0.025;
alpha     = 0.33;
chi       = 1.0;
eta       = 2.0;
rho_z     = 0.95;
sigma_pers= 0.007;
sigma_once= 0.01;
tau_k     = 0.30;
tau_n     = 0.20;
Gbar      = 0.20;

model;

// 1) Production
y = exp(z) * k(-1)^alpha * n^(1-alpha);

// 2) Wage
w = (1-alpha) * y / n;

// 3) Rental rate of capital
r = alpha * y / k(-1);

// 4) Resource constraint
y = c + i + g;

// 5) Capital accumulation
k = (1-delta) * k(-1) + i;

// 6) Euler equation
1/c = beta * (1/c(+1)) * ((1 - tau_k) * r(+1) + 1 - delta);

// 7) Labor-supply FOC
(1 - tau_n) * w / c = chi * n^eta;

// 8) Government budget
tau_k * r * k(-1) + tau_n * w * n = g + t;

// 9) Fiscal rule for g
g = Gbar * y;

// 10) TFP process
z = rho_z * z(-1) + eps_pers + eps_once;

end;

// -------------------- Initial steady-state guesses ---------------------
initval;
z = 0;
eps_pers = 0;
eps_once = 0;

k = 10;
n = 0.3;

y = exp(z) * k^alpha * n^(1-alpha);
r = alpha * y / k;
w = (1-alpha) * y / n;

g = Gbar * y;
t = tau_k_
