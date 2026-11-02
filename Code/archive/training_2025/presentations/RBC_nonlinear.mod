@#define LOGUTILITY = 1

var
  y     ${Y}$        (long_name='output')
  c     ${C}$        (long_name='consumption')
  k     ${K}$        (long_name='capital')
  l     ${L}$        (long_name='labor')
  a     ${A}$        (long_name='productivity')
  g     ${G}$        (long_name='government spending')   // new shock
  r     ${R}$        (long_name='interest Rate')
  w     ${W}$        (long_name='wage')
  iv    ${I}$        (long_name='investment')
  mc    ${MC}$       (long_name='marginal Costs')
  %tau   ${T}$        (long_name='Tax / Transfer')   // NEW
;

%model_local_variable
%  uc    ${U_t^C}$
%  ucp   ${E_t U_{t+1}^C}$
%  ul    ${U_t^L}$
%  fk    ${f_t^K}$
%  fl    ${f_t^L}$



varexo
  epsa  ${\varepsilon^A}$   (long_name='Productivity Shock')
  epsg  ${\varepsilon^G}$   (long_name='Government Spending Shock')  // shock
  %epstau  ${\varepsilon^T}$   (long_name='Tax Shock');  // NEW
;

parameters
  BETA  ${\beta}$  (long_name='Discount Factor')
  DELTA ${\delta}$ (long_name='Depreciation Rate')
  GAMMA ${\gamma}$ (long_name='Consumption Utility Weight')
  PSI   ${\psi}$   (long_name='Labor Disutility Weight')
  @#if LOGUTILITY == 0
  ETAC  ${\eta^C}$ (long_name='Risk Aversion')
  ETAL  ${\eta^L}$ (long_name='Inverse Frisch Elasticity')
  @#endif
  ALPHA ${\alpha}$ (long_name='Output Elasticity of Capital')
  RHOA  ${\rho^A}$ (long_name='TFP persistence')
  RHOG ${\rho^G}$ (long_name='Government spending persistence')
  %RHOTAU ${\rho^T}$   (long_name='Tax Shock persistence')
  sigmae
;

% Parameter calibration
ALPHA = 0.35;
BETA  = 0.99;
DELTA = 0.025;
GAMMA = 1;
PSI   = 1.6;
RHOA  = 0.9;
RHOG = 0.8;  %// persistence of government spending
%RHOTAU = 0.5;   // moderate persistence
@#if LOGUTILITY == 0
ETAC  = 2;
ETAL  = 1;
@#endif
sigmae = 1;

model;
%marginal utility of consumption and labor
@#if LOGUTILITY == 1
  #uc  = GAMMA*c^(-1);
  #ucp  = GAMMA*c(+1)^(-1);
  #ul = -PSI*(1-l)^(-1);
@#else
  #uc  = GAMMA*c^(-ETAC);
  #ucp  = GAMMA*c(+1)^(-ETAC);
  #ul = -PSI*(1-l)^(-ETAL);
@#endif

%marginal products of production
#fk = ALPHA*y/k(-1);
#fl = (1-ALPHA)*y/l;

% intertemporal optimality (Euler)
uc = BETA*ucp*(1-DELTA + r(+1)) ; %% + eps_b // add on RHS for an example "preference shock" // check changing r(+1) to r
% labor supply
w = -ul/uc; %% l1  = - (1/ETAL)*w1 + (ETAC/ETAL)*c1
% capital accumulation
k = (1-DELTA)*k(-1) + iv;
% market clearing
%y = c + iv ;  
y = c + g + iv ;                    %% + eps_g // add on RHS for an example "government spending shock"
%y = (c- tau) + g + iv ;            %%Personal income tax/ transfer shock

% production function
y = a*k(-1)^ALPHA*l^(1-ALPHA);
% marginal costs
mc = 1;
% labor demand
w = mc*fl;
% capital demand
r = mc*fk;
% total factor productivity
log(a) = RHOA*log(a(-1)) + epsa;
log(g) = RHOG*log(g(-1)) + epsg;
%log(tau) = RHOTAU*log(tau(-1)) + epstau;
end;

%-------------------------------------------- %
% Steady State Computation (Homework Exercise)%
%-------------------------------------------- %

initval; 
 a = 1;     % TFP level normalised to one            %
 mc = 1;    % perfect competition                    %
 r = 0.03;  % interest rate for RBC models           %  
 l = 1/3;   % steady state labour work 8 hours a day %
 y = 1.2;   % steady state output usually above one  %
 c = 0.9;   % market clearing y = c + i              %
 iv = 0.35; % does not necessarily need to add up    %  
 k = 12;    % capital is ten times output            %
 w = 2.25;  
 g = 0.1;   %small initial government spending
 %tau = 0.1;   % baseline taxes
end;

shocks;
var epsa = sigmae^2;  // stderr 0.01; // var(sigmae) = 0.01^2
var epsg = sigmae^2;    // 1% s.d. government spending shock

end;

resid;
steady;     % dynare compute steady state %
check;

stoch_simul(order=1, periods=150); // , nograph , nodisplay , periods=150

%----------------------------------------------------------------
% Plot IRFs to a 1.0% s.d. technology shock
%----------------------------------------------------------------

%----------------------------------------------------------------
% Plot IRFs to technology (epsa) and government spending (epsg) shocks
%----------------------------------------------------------------
figure

% --- Output ---
subplot(3,3,1)
plot([0:options_.irf], [0 oo_.irfs.y_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.y_epsg], 'r--', 'LineWidth',1.2);
title('Output')
legend('Tech shock','Govt shock')
ylabel('% dev. from steady state')

% --- Consumption ---
subplot(3,3,2)
plot([0:options_.irf], [0 oo_.irfs.c_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.c_epsg], 'r--', 'LineWidth',1.2);
title('Consumption')

% --- Capital ---
subplot(3,3,3)
plot([0:options_.irf], [0 oo_.irfs.k_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.k_epsg], 'r--', 'LineWidth',1.2);
title('Capital')

% --- Employment ---
subplot(3,3,4)
plot([0:options_.irf], [0 oo_.irfs.l_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.l_epsg], 'r--', 'LineWidth',1.2);
title('Labor')

% --- Technology & Govt Spending processes ---
subplot(3,3,5)
plot([0:options_.irf], [0 oo_.irfs.a_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.g_epsg], 'r--', 'LineWidth',1.2);
title('Shocks (A and G)')

% --- Interest Rate ---
subplot(3,3,6)
plot([0:options_.irf], [0 oo_.irfs.r_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.r_epsg], 'r--', 'LineWidth',1.2);
title('Interest Rate')

% --- Wage ---
subplot(3,3,7)
plot([0:options_.irf], [0 oo_.irfs.w_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.w_epsg], 'r--', 'LineWidth',1.2);
title('Wage')

% --- Investment ---
subplot(3,3,8)
plot([0:options_.irf], [0 oo_.irfs.iv_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.iv_epsg], 'r--', 'LineWidth',1.2);
title('Investment')

% --- Marginal Costs ---
subplot(3,3,9)
plot([0:options_.irf], [0 oo_.irfs.mc_epsa], 'b-', 'LineWidth',1.2); hold on
plot([0:options_.irf], [0 oo_.irfs.mc_epsg], 'r--', 'LineWidth',1.2);
title('Marginal Costs')

sgtitle('Impulse Responses: Technology vs Government Spending shocks')


write_latex_definitions;
write_latex_parameter_table;
write_latex_original_model;
%write_latex_dynamic_model;
write_latex_static_model;
collect_latex_files;

if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
warning('TeX-File did not compile; you need to compile it manually')
end

