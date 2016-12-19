%
d = dir('1612   _taskRelated_alpha*.mat');

for s = 1:length(d)

    load(d(s).name, 'currFR','location', 'perfEnsemble_reg','perfSingleUnit_reg','bestEnsemble_reg','bestSingleUnit_reg')
    label = location;
    %currFR = allFR(:,taskRelated);
    allFR = currFR;
    [nTrials, nNeur] = size(allFR);
    
    % create 10 shuffles (no noise correlations)
%     uc = unique(label);
%     nShufs = 1;
%     allFRr = cell(nShufs,1);
%     
%     for j = 1:nShufs
%         allFRr{j} = allFR;
%         for i = 1:length(uc)
%             t = find(label == uc(i));    
%             for ni = 1:nNeur
%                 t2 = t(randperm(length(t)));
%                 allFRr{j}(t2,ni) = allFR(t,ni);
%             end
%         end
%     end

    bestEnsemble2 = [];
    perfEnsemble2 = [];
    bestSingleUnit2 = zeros(nNeur,1);
    perfSingleUnit2 = zeros(nNeur,1);
    
    % run SVM for each individual unit
    for j = 1:nNeur

        [~,sessAcc]=LD_ClassifyDataLinear2(allFR(:,j), label,'kfold',10,'normalize',true,'normalizetype','midrange');
        bestSingleUnit2(j) = mean(sessAcc);
    end
    
    % run BSU ensemble building
    [~, ind] = sort(bestSingleUnit2, 'descend');
    perfSingleUnit2 = zeros(nNeur,1);
    for i = 1:length(ind)
        [~, sessAcc] =  LD_ClassifyDataLinear2(allFR(:,ind(1:i)), label, 'kfold',10,'normalize',true,'normalizetype','midrange');
        perfSingleUnit2(i) = mean(sessAcc);
    end

    % identify the unit that yields best SVM performance and keep track of it -
    % this makes up the most informative ensemble
    [bestPerf, bestInd] = max(bestSingleUnit2);
    bestEnsemble2 = [bestEnsemble2; bestInd];
    perfEnsemble2 = [perfEnsemble2; bestPerf];

    % run through remaining units
    for k = 1:nNeur
        perf = zeros(nNeur,1);
        for i = 1:nNeur

            % skip units that are already in the most informative ensemble
            if ismember(i,bestEnsemble2)
                continue
            end

            currFR = [allFR(:,bestEnsemble2), allFR(:,i)];
            [~,sessAcc]=LD_ClassifyDataLinear2(currFR, label,'kfold',10,'normalize',true,'normalizetype','midrange');
            
            perf(i) = mean(sessAcc);
        end

        % identify the added unit that yielded the best performance and add it to
        % most informative ensemble
        [bestPerformance, bestIndex] = max(perf);
        bestEnsemble2 = [bestEnsemble2; bestIndex];
        perfEnsemble2 = [perfEnsemble2; bestPerformance];
    end

    % store in a structure & save
    bestEnsemble_reg.location = bestEnsemble2(1:end-1);
    perfEnsemble_reg.location = perfEnsemble2(1:end-1);
    bestSingleUnit_reg.location = bestSingleUnit2;
    perfSingleUnit_reg.location = perfSingleUnit2;

    save(d(s).name, 'bestEnsemble_reg', 'perfEnsemble_reg', 'bestSingleUnit_reg', 'perfSingleUnit_reg','-append')  
    
%%    
% shuffPerfEnsemble = zeros(nNeur, nShufs);
% for b = 1%:nShufs
%     
%     shuffPerfEnsemble2 = [];
%     shuffBestEnsemble2 = [];
%     shuffBestSingleUnit2 = zeros(nNeur,1);
%     
%     % run SVM for each individual unit
%     for j = 1:nNeur
% 
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFRr{b}(:,j), label,'kfold',10,'normalize',true,'normalizetype','midrange');
%         shuffBestSingleUnit2(j) = mean(sessAcc);
%     end
% 
%     % [~, ind] = sort(singleNeuronInfo2, 'descend');
%     % perfSingleUnit2 = zeros(nNeur,1);
%     % for i = 1:length(ind)
%     %     perfSingleUnit2(i) =  1-svmClassify(allFR(:,ind(1:i)), label, 10);
%     % end
% 
%     % identify the unit that yields best SVM performance and keep track of it -
%     % this makes up the most informative ensemble
%     [bestPerf, bestInd] = max(shuffBestSingleUnit2);
%     shuffPerfEnsemble2 = [shuffPerfEnsemble2; bestPerf];
%     shuffBestEnsemble2 = [shuffBestEnsemble2; bestInd];
% 
%     % run through remaining units
%     for k = 1:nNeur
%         
%         perf = zeros(nNeur,1);
%         
%         for i = 1:nNeur
% 
%             % skip units that are already in the most informative ensemble
%             if ismember(i,shuffBestEnsemble2)
%                 continue
%             end
% 
%             currFR = [allFRr{b}(:,shuffBestEnsemble2), allFRr{b}(:,i)];
%             [~,sessAcc]=LD_ClassifyDataLinear2(currFR, label,'kfold',10,'normalize',true,'normalizetype','midrange');
%             
%             perf(i) = mean(sessAcc);
%         end
% 
%         % identify the added unit that yielded the best performance and add it to
%         % most informative ensemble
%         [bestPerformance, bestIndex] = max(perf);
%         shuffPerfEnsemble2 = [shuffPerfEnsemble2; bestPerformance];
%         shuffBestEnsemble2 = [shuffBestEnsemble2; bestInd];
%     end
% 
%     % store in a structure & save
%     shuffPerfEnsemble(:,b) = shuffPerfEnsemble2(1:end-1);
%     % singleNeuronInfo.location = bestSingleUnit2;
%     % singleNeuronPerf.location = perfSingleUnit2;
% end
% 
%     shuffPerfEnsemble_reg.location = mean(shuffPerfEnsemble,2);
%     
%     save(d(s).name, 'shuffPerfEnsemble_reg','-append')
%     %diplay('done')
end