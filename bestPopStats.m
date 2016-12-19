
function p = bestPopStats(dist1, dist2, nEnsemble, nShuf, nDays)

p = nan(1, nEnsemble);

for i = 1:nEnsemble
    
    true_dist = nan(nDays,1);
    
    shuf_dist = dist1(i,:); % just for a single ensemble size
    shuf_dist = repmat(shuf_dist,nDays,1); % replicate for multiple days
    
    for j = 1:nDays
        true_dist(j) = dist2(i,j); % just for a single sample
    end
    true_dist = repmat(true_dist,1,nShuf); % replicate for multiple samples (= numShuf)
    
    p(1,i) = rr_exact_test(true_dist(:), shuf_dist(:)); % exact test on distribution of differences
end