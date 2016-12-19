
d = dir('0404_alpha*.mat');
nShufs = 10;

for s = 2:length(d)
       
    dat = load(d(s).name, 'allFR','taskRelated','location');
    allFR = dat.allFR(:,dat.taskRelated);
    label = dat.location;
    [nTrials, nNeur] = size(allFR);
    
    [bestEnsemble_perf, bestEnsemble_ind] = optimal_ensemble(allFR, label);
    bestEnsemble_perf_SHUF = nan(nShufs, nNeur);
    bestEnsemble_ind_SHUF = nan(nShufs, nNeur);
    
    % create 10 shuffles (no noise correlations)
    uc = unique(label);
    
    allFRr = cell(nShufs,1);
    
    for j = 1:nShufs
        allFRr{j} = allFR;
        for i = 1:length(uc)
            t = find(label == uc(i));    
            for ni = 1:nNeur
                t2 = t(randperm(length(t)));
                allFRr{j}(t2,ni) = allFR(t,ni);
            end
        end
        [bestEnsemble_perf_SHUF(j,:), bestEnsemble_ind_SHUF(j,:)] = optimal_ensemble(allFRr{j}, label);
    end
    
    save(d(s).name, 'bestEnsemble_perf','bestEnsemble_perf_SHUF','bestEnsemble_ind','bestEnsemble_ind_SHUF','-append')
    clearvars -except d nShufs s

end