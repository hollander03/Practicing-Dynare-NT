% Independent numerical checks on saved Dynare allocations; no plots.
files=[dir('s04*.mod');dir('s05*.mod')];
residual_tolerance=1e-5; % Matches the ordinary solver accuracy used in class.
for jj=1:numel(files)
    [~,stem]=fileparts(files(jj).name);
    result=load(fullfile(stem,'Output',[stem '_results.mat']));
    mm=result.M_; oo=result.oo_;
    p=@(name) mm.params(strcmp(mm.param_names,name));
    v=@(name) oo.endo_simul(strcmp(mm.endo_names,name),:);
    ex=@(name) oo.exo_simul(:,strcmp(mm.exo_names,name))';
    beta=p('beta'); delta=p('delta'); alpha=p('alpha'); A=p('A'); gamma=p('gamma');
    c=v('c'); k=v('k'); g=ex('g'); tc=ex('tauc'); tk=ex('tauk');
    if any(strcmp(mm.exo_names,'taui'))
        ti=ex('taui');
    else
        ti=zeros(size(c)); % Section 5 has no investment subsidy.
    end
    ix=2:301; % Actual simulation periods, including the final solved period.
    if any(strcmp(mm.endo_names,'n'))
        n=v('n'); tn=ex('taun');
        labour=p('B')*c(ix).^gamma.*(1+tc(ix)) ...
             -(1-tn(ix))*(1-alpha)*A.*k(ix-1).^alpha.*n(ix).^(-alpha);
        assert(max(abs(labour))<residual_tolerance,'Labour FOC residual too large');
    else
        n=ones(size(c));
    end
    resource=c(ix)-(A*k(ix-1).^alpha.*n(ix).^(1-alpha) ...
             +(1-delta)*k(ix-1)-k(ix)-g(ix));
    return_next=(1+tc(ix))./(1+tc(ix+1)).* ...
        ((1-ti(ix+1))*(1-delta)+(1-tk(ix+1)).*A*alpha.* ...
         k(ix).^(alpha-1).*n(ix+1).^(1-alpha))./(1-ti(ix));
    euler=c(ix).^(-gamma)-beta*c(ix+1).^(-gamma).*return_next;
    assert(max(abs(resource))<residual_tolerance,'Resource residual too large');
    assert(max(abs(euler))<residual_tolerance,'Euler residual too large');
    assert(max(abs(oo.endo_simul(:,301)-oo.endo_simul(:,302)))<1e-5, ...
        'Final solved period not near terminal steady state');
    if startsWith(stem,'s04_03_05') || startsWith(stem,'s04_03_06') || startsWith(stem,'s05_03_04')
        assert(max(abs(oo.endo_simul(:,1)-oo.endo_simul(:,302)))<1e-6, ...
            'Pulse terminal steady state differs from initial');
    end
    fprintf('PATH_PASS %s resource=%.3g euler=%.3g\n',stem,max(abs(resource)),max(abs(euler)));
end
