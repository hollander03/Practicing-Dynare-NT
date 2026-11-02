% Reviewer-only comparison of the short and full code paths.
% Run from the executed full-example directory, with tools/ on the path.
% Set simple_dir to the executed short-example directory before calling.
assert(exist('simple_dir','var')==1, ...
    'Set simple_dir to the folder containing the executed short examples.');
files=dir(fullfile(simple_dir,'s*.mod'));
for j=1:numel(files)
    [~,stem]=fileparts(files(j).name);
    if startsWith(stem,'s02') || startsWith(stem,'s03'), continue; end
    result=load(fullfile(simple_dir,stem,'Output',[stem '_results.mat']));
    k=result.oo_.endo_simul(strcmp(result.M_.endo_names,'k'),1:40)';
    c=result.oo_.endo_simul(strcmp(result.M_.endo_names,'c'),2:41)';
    outstem=stem;
    if contains(stem,'gamma02'), outstem='s05_03_05_g_gamma_comparison'; end
    if contains(stem,'yields')
        data=load(fullfile('output',[outstem '.mat']));
        cons=result.oo_.endo_simul(strcmp(result.M_.endo_names,'c'),2:302);
        beta=result.M_.params(strcmp(result.M_.param_names,'beta'));
        q=beta.^(0:300).*(cons/cons(1)).^(-2);
        assert(max(abs(q-data.q))<1e-4,'Yield price path differs');
        assert(all(isfinite(data.yields(:))),'Nonfinite yields');
        fprintf('OUTPUT_MATCH %s prices/yields\n',stem);
    else
        data=load(fullfile('output',[outstem '.mat']));
        discrepancy=max(abs([k c]-data.paths(:,1:2)),[],'all');
        assert(discrepancy<1e-4,'Full and short allocations differ');
        assert(all(isfinite(data.paths(:))),'Nonfinite panel data');
        if contains(stem,'taun')
            policy=result.oo_.exo_simul(2:41,strcmp(result.M_.exo_names,'taun'));
            assert(max(abs(policy-data.paths(:,end)))<1e-12,'Wrong policy alignment');
        elseif startsWith(stem,'s05')
            if contains(stem,'tauc'), name='tauc'; elseif contains(stem,'tauk'), name='tauk'; else, name='g'; end
            policy=result.oo_.exo_simul(2:41,strcmp(result.M_.exo_names,name));
            assert(max(abs(policy-data.paths(:,end)))<1e-12,'Wrong policy alignment');
        end
        fprintf('OUTPUT_MATCH %s max_k_c=%.3g\n',stem,discrepancy);
    end
end

% The two code paths must use identical artificial observations.
for section=2:3
    short_data=load(fullfile(simple_dir,sprintf('s0%d_simudata.mat',section)));
    full_data=load(sprintf('s0%d_simudata.mat',section));
    assert(isequal(short_data,full_data),'Artificial data differ');
    fprintf('DATA_MATCH section %d\n',section);
end
