function [bestEnsemble_perf, bestEnsemble_ind] = optimal_ensemble(allFR, label)

    [~, nNeur] = size(allFR);
    bestEnsemble_ind = nan(nNeur,1);
    bestEnsemble_perf = nan(nNeur,1);

    for iter = 1:nNeur-1
        
        search_neurons = setdiff(1:nNeur, bestEnsemble_ind); % searchable neurons
        nsearch = length(search_neurons);
        search_acc = nan(nsearch, 1); 
        
        for j = 1:nsearch
            curr_ensemble_ind = cat(1, bestEnsemble_ind, search_neurons(j));
            nnan = ~isnan(curr_ensemble_ind);
            curr_ensemble = allFR(:, curr_ensemble_ind(nnan));
            [~,tmp] = LD_ClassifyDataLinear2(curr_ensemble, label,...
                'kfold',10,'normalize',true,'normalizetype','midrange');
            search_acc(j) = mean(tmp);
        end
        
        [M,mi] = max(search_acc);
        bestEnsemble_perf(iter) = M;
        bestEnsemble_ind(iter) = search_neurons(mi);
    end 
end
