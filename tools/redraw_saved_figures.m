% Redraw the workbook's plots from saved values, without running Dynare.
% The full .mod files produce the same panels when models are run afresh.
repo_root=fileparts(fileparts(mfilename('fullpath')));
snapshot_dir=fullfile(repo_root,'Code','full_replications','results_snapshot');
figure_dir=fullfile(repo_root,'figures');

% Stochastic impulse responses saved before the estimation step.
for section=2:3
    data=load(fullfile(snapshot_dir,sprintf('s0%d_irfs.mat',section)));
    if section==2
        series={'c','k','lab','z'}; shock='e'; columns=2;
        labels={'Consumption, c_t','Capital choice, k_t','Hours, l_t','Log productivity, z_t'};
        filename='s02_02_growth_irfs';
    else
        series={'c1','c2','k1','k2','a1','a2'}; shock='e1'; columns=3;
        labels={'Log consumption, c_{1,t}','Log consumption, c_{2,t}', ...
                'Log capital, k_{1,t}','Log capital, k_{2,t}', ...
                'Log productivity, a_{1,t}','Log productivity, a_{2,t}'};
        filename='s03_02_twocountry_irfs';
    end
    figure('Position',[100 100 1000 600]);
    for panel=1:numel(series)
        subplot(2,columns,panel);
        response=data.irfs.([series{panel} '_' shock]);
        plot(0:40,[0;response(:)],'b','LineWidth',1.2);
        title(labels{panel}); xlabel('Periods (0 = pre-shock)');
    end
    print(gcf,fullfile(figure_dir,[filename '.png']),'-dpng','-r150');
    close(gcf);
end

% Each MAT file contains the values plotted by one fiscal experiment.
files=[dir(fullfile(snapshot_dir,'s04*.mat'));dir(fullfile(snapshot_dir,'s05*.mat'))];
for example=1:numel(files)
    [~,stem]=fileparts(files(example).name);
    if contains(stem,'yields'), continue; end
    data=load(fullfile(snapshot_dir,files(example).name));
    if startsWith(stem,'s04')
        labels={'Capital, k_{t-1}','Consumption, c_t','Gross return, R_{t+1}', ...
                'Real wage, w_t','Capital payoff, s_t','Rental yield, r_t'};
    elseif startsWith(stem,'s05_04')
        policy='taun'; if contains(stem,'_01_g'), policy='g'; end
        labels={'Capital, k_{t-1}','Consumption, c_t','Gross return, R_{t+1}', ...
                'Real wage','Hours, n_t',policy};
    else
        policy='g';
        if contains(stem,'tauc'), policy='tauc'; elseif contains(stem,'tauk'), policy='tauk'; end
        labels={'Capital, k_{t-1}','Consumption, c_t','Gross return, R_{t+1}', ...
                'Rental yield, r_t',policy};
    end
    figure('Position',[100 100 1000 600]);
    for panel=1:size(data.paths,2)
        subplot(2,3,panel);
        if contains(stem,'gamma_comparison')
            plot(data.time,data.baseline(panel)*ones(40,1),'--k', ...
                 data.time,data.gamma2_paths(:,panel),'b', ...
                 data.time,data.paths(:,panel),'-.r','LineWidth',1.2);
        else
            plot(data.time,data.baseline(panel)*ones(40,1),'--k', ...
                 data.time,data.paths(:,panel),'b','LineWidth',1.2);
        end
        title(labels{panel}); xlabel('Time t');
    end
    if contains(stem,'gamma_comparison')
        legend('Initial steady state','gamma=2','gamma=0.2');
    end
    print(gcf,fullfile(figure_dir,[stem '.png']),'-dpng','-r150');
    close(gcf);
end

% The yield-curve exercise reuses the spending experiment's consumption path.
data=load(fullfile(snapshot_dir,'s05_03_06_yields.mat'));
spending=load(fullfile(snapshot_dir,'s05_03_01_g.mat'));
time=spending.time;
figure('Position',[100 100 1000 600]);
subplot(2,3,1);
plot(time,spending.baseline(2)*ones(40,1),'--k',time,spending.paths(:,2),'b');
title('Consumption'); xlabel('Time t');
subplot(2,3,2);
plot(time,data.discount.^(0:39),'--k',time,data.q(1:40),'b');
title('Dated price, q_t'); xlabel('Time t');
subplot(2,3,3);
plot(time,-log(data.discount)*ones(40,1),'--k',time,data.short_rate(1:40),'b');
title('Continuously compounded short rate'); xlabel('Time t');
subplot(2,3,4);
plot(1:40,data.yields(:,1),'b',1:40,data.yields(:,11),'-.r', ...
     1:40,data.yields(:,61),'--k');
title('Yield curves'); xlabel('Maturity'); legend('t=0','t=10','t=60');
subplot(2,3,5);
plot(time,spending.baseline(5)*ones(40,1),'--k',time,spending.paths(:,5),'b');
title('Government spending'); xlabel('Time t');
print(gcf,fullfile(figure_dir,'s05_03_06_yields.png'),'-dpng','-r150');
close(gcf);
fprintf('Redrew 17 PNG figures from saved values. No model simulations or estimations were run.\n');
