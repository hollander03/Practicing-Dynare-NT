// This program replicates figure 11.3.1 from chapter 11 of RMT2 by
// Ljungqvist and Sargent.

// oo_.endo_simul records the simulated endogenous variables in alphabetical order
// ys0_ records the initial steady state
// ys_ records the terminal steady state
// We check that these line up at the end points
// Note: oo_.endo_simul has ys0_ in the first column, ys_ in the last column, which explains
// why it has 102 elements.
// The sample of size 100 is in between.

// Warning: All endogenous variables dated time t are treated as jump variables
// in Dynare. So k in the program corresponds to k_{t+1}
// and the same timing holds for the taxes.

// Declares the endogenous variables
var c k;
// Declares the exogenous variables
// investment tax credit, consumption tax, capital tax, government spending
varexo taui tauc tauk g;

parameters bet gam del alpha A;

bet = .95; // discount factor
gam = 2;   // CRRA parameter
del = .2;  // depreciation rate
alpha = .33; // capital’s share
A = 1;     // productivity

// Alignment convention:
// g tauc taui tauk are now columns of oo_.exo_simul. Because of a bad design decision
// the date of oo_.exo_simul(1,:) doesn’t necessarily match the date in oo_.endo_simul.
// Whether they match depends on the number of lag periods in endogenous versus
// exogenous variables.
// In this example they match because tauc(-1) and taui(-1) enter the model.

// These decisions and the timing conventions mean that oo_.endo_simul(:,1) records the
// initial steady state, while oo_.endo_simul(:,102) records the terminal steady state
// values. For j > 2, oo_.endo_simul(:,j) records [c(j-1) .. k(j-1) .. G(j-1)] where k(j-1)
// means end of period capital in period j-1, which equals k(j) in chapter 11
// notation. Note that the jump in G occurs in oo_.endo_simul(:,11), which confirms this
// timing. The jump occurs now in oo_.exo_simul(11,1)

model;
// equation 11.3.8.a
k = A*k(-1)^alpha + (1-del)*k(-1) - c - g;
// equation 11.3.8e + 11.3.8.g
c^(-gam) = bet*(c(+1)^(-gam))*((1+tauc(-1))/(1+tauc))*((1-taui)*(1-del)/(1-taui(-1)) + ((1-tauk)/(1-taui(-1)))*alpha*A*k(-1)^(alpha-1));
end;

initval;
k = 1.5; c = 0.6; g = 0.2; tauc = 0; taui = 0; tauk = 0;
end;
steady; // Compute initial steady state
ys0_ = oo_.steady_state; // Save initial steady state

endval; // The following values determine the new steady state after the shocks
k = 1.5; c = 0.6; g = .2; tauc = 0; taui = 0; tauk = 0.2;
end;
steady; // Compute terminal steady state
ys_ = oo_.steady_state; // Save terminal steady state

// The following lines produce a g sequence with a once and for all jump in g shocks
// we use shocks to undo that for the first 9 periods and leave g at its initial value of 0.2
shocks;
var tauk;
periods 1:9;
values 0.2;
end;

// Now solve the model
perfect_foresight_setup(periods=100);
perfect_foresight_solver;

// Check that initial and terminal steady states line up
disp(oo_.endo_simul(:,1) - ys0_(:));
disp(oo_.endo_simul(:,102) - ys_(:));

// Compute the initial steady state for consumption to later do the plots
co = ys0_(1); // c is the 1st endogenous variable
ko = ys0_(2); // k is the 2nd endogenous variable
// g is in oo_.exo_simul(:,1) since it is stored in alphabetical order
go = oo_.exo_simul(1,1);

// The following equations compute the other endogenous variables used in the plots below
// These equations were taken from page 333 of RMT2
rbig0 = 1/bet;
rbig = oo_.endo_simul(1,2:101).^(-gam)./(bet*oo_.endo_simul(1,3:102).^(-gam));
rq0 = alpha*A*ko^(alpha-1);
rq = alpha*A*oo_.endo_simul(2,1:100).^(alpha-1);
wq0 = A*ko^alpha - ko*alpha*A*ko^(alpha-1);
wq = A*oo_.endo_simul(2,1:100).^alpha - oo_.endo_simul(2,1:100).*alpha*A.*oo_.endo_simul(2,1:100).^(alpha-1);
sq0 = (1-oo_.exo_simul(1,4))*A*alpha*ko^(alpha-1) + (1-del);
sq = (1-oo_.exo_simul(1:100,4)')*A*alpha.*oo_.endo_simul(2,1:100).^(alpha-1) + (1-del);

// Now we plot the responses of the endogenous variables to the shock
figure;
subplot(2,3,1); plot([ko*ones(100,1) oo_.endo_simul(2,1:100)']); title('k');
subplot(2,3,2); plot([co*ones(100,1) oo_.endo_simul(1,2:101)']); title('c');
subplot(2,3,3); plot([rbig0*ones(100,1) rbig']); title('R');
subplot(2,3,4); plot([wq0*ones(100,1) wq']); title('w/q');
subplot(2,3,5); plot([sq0*ones(100,1) sq']); title('s/q');
subplot(2,3,6); plot([rq0*ones(100,1) rq']); title('r/q');