var y ${y}$ (long_name='output') 
    c ${c}$ (long_name='consumption')
    n ${n}$ (long_name='hours') 
    v ${v}$ (long_name='investment') 
    k ${k}$ (long_name='capital')
    r ${r}$ (long_name='real rate') 
    z ${z}$ (long_name='TFP')
    g ${g}$ (long_name='gov purchases');

varexo epsilon_z    ${\epsilon_z}$     (long_name='TFP shock')
       epsilon_g    ${\epsilon_g}$     (long_name='Gov shock');

parameters rho    ${\rho}$   (long_name='capital share')
           bet    ${\beta}$  (long_name='discount factor')
           delt   ${\delta}$ (long_name='depreciation rate')
           psi    ${\psi}$   (long_name='persistence TFP shock')
           eta    ${\eta}$   (long_name='risk aversion')
           omeg   ${\omeg}$   (long_name='persistence Gov shock')
           sigmae_z ${\sigma_{e}}$ (long_name='i.i.d TFP shock')
           sigmae_g ${\sigma_{g}}$ (long_name='i.i.d Gov shock')
           GY;

rho = 0.3;
bet = 0.99;
delt = 0.016;
psi = 0.95;
omeg = 0.95;
eta = 1.5;
sigmae_z = 0.01;
sigmae_g = 0.01;
GY = 0.19;

model(linear);

#R = 1/bet;
#KY = rho/(R - (1-delt));
#CY = 1 - KY*delt - GY;

[name='Resource constraint'] 
y = CY*c + delt*KY*v + GY*g;             

[name='Euler equation']
(1/eta)*r(+1) = c(+1) - c;

[name='Labor FOC']
eta*c = y - n;                      

[name='real interest rate/firm FOC capital']
r = rho*(1/KY)*(y - k(-1));

[name='Law of motion capital'] 
k = (1-delt)*k(-1) + delt*v;             

[name='production function']
y = z + rho*k(-1) + (1-rho)*n;         

[name='exogenous TFP process']
z = psi*z(-1) + epsilon_z;

[name='exogenous Gov process']
g = omeg*g(-1) + epsilon_g;

end;

steady;
check;

shocks;
var epsilon_z; stderr sigmae_z;
var epsilon_g; stderr sigmae_g;
end;

%%stoch_simul(order=1, periods=200, graph_format=fig, nodisplay);
stoch_simul(order=1);

%%figure;
%%plot(0:options_.irf, [0 oo_.irfs.y_epsilon_g]*100, 'b-', 'LineWidth', 1.5); hold on;
%%plot(0:options_.irf, [0 oo_.irfs.c_epsilon_g]*100, 'r-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.v_epsilon_g]*100, 'g-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.k_epsilon_g]*100, 'm-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.n_epsilon_g]*100, 'c-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.r_epsilon_g]*100, 'k-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.g_epsilon_g]*100, 'y-', 'LineWidth', 1.5);
%%title('Impulse Responses to a Government Purchases Shock');
%%legend('Output', 'Consumption', 'Investment', 'Capital', 'Employment', 'Rate of Return', 'Government Purchases');
%%ylabel('Percentage Deviations from Steady State (%)');
%%xlabel('Quarters After Shock');
%%grid on;
%%hold off;

%%figure;
%%plot(0:options_.irf, [0 oo_.irfs.y_epsilon_z]*100, 'b-', 'LineWidth', 1.5); hold on;
%%plot(0:options_.irf, [0 oo_.irfs.c_epsilon_z]*100, 'r-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.v_epsilon_z]*100, 'g-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.k_epsilon_z]*100, 'm-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.n_epsilon_z]*100, 'c-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.r_epsilon_z]*100, 'k-', 'LineWidth', 1.5);
%%plot(0:options_.irf, [0 oo_.irfs.g_epsilon_z]*100, 'y-', 'LineWidth', 1.5);
%%title('Impulse Responses to a TFP Shock');
%%legend('Output', 'Consumption', 'Investment', 'Capital', 'Employment', 'Rate of Return', 'TFP');
%%ylabel('Percentage Deviations from Steady State (%)');
%%xlabel('Quarters After Shock');
%%grid on;
%%hold off;

