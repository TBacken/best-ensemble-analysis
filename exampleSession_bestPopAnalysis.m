cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Sergio')
d = dir('1612_taskRelated_alpha*.mat');

structNames = {'direction'};%, 'color'}; 

for l = 1:length(structNames)
    
    totalEnsemblePerf = cell(1,4);
    totalSingleNeuron = cell(1,4);
    ensembleIndex = cell(1,4);
    individUnitPerf = cell(1,4);
    
    ipsiInd = cell(1,4);
    contraInd = cell(1,4);
    noLocInd = cell(1,4);
    
    upInd = cell(1,4);
    downInd = cell(1,4);
    noDirInd = cell(1,4);
    
    % load shuffled data 
    if ~strcmp(d(1).name, '1501_taskRelated_alpha1605.mat')
        load('1501_taskRelated_alpha1605.mat')
    elseif strcmp(d(1).name, '1501_taskRelated_alpha1605.mat')
        load(d(1).name, 'shuffledEnsemble','shuffledSingleNeuron')
    end

    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg','ipsiPref','bestEnsemble_reg','contraPref','noLocPref','upPref','downPref','noDirPref','bestSingleUnit_reg')

        totalEnsemblePerf{i} = perfEnsemble_reg.(structNames{l});
        totalSingleNeuron{i} = perfSingleUnit_reg.(structNames{l});
        ensembleIndex{i} = bestEnsemble_reg.(structNames{l});
        individUnitPerf{i} = bestSingleUnit_reg.(structNames{l});
        
        ipsiInd{i} = ipsiPref;
        contraInd{i} = contraPref;
        noLocInd{i} = noLocPref;
        
        upInd{i} = upPref;
        downInd{i} = downPref;
        noDirInd{i} = noDirPref;
        
        clear bestPerfEnsemble singleNeuronPerf ipsiPref mostInformativeEnsemble contraPref noLocPref upPref downPref noDirPref singleNeuronInfo
    end

    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf);
    minSize = min(sizes);

    % concatenate
    if strcmp(structNames,'location')
        ensemblePerf = [totalEnsemblePerf{3}];
        singleNeuron = [totalSingleNeuron{3}];
    elseif strcmp(structNames,'direction')
        ensemblePerf = [totalEnsemblePerf{5}];
        singleNeuron = [totalSingleNeuron{5}];
    end
    
    shuffledSingleNeuron2 = shuffledSingleNeuron.(structNames{l})(1:minSize,:);
    shuffledEnsemble2 = shuffledEnsemble.(structNames{l})(1:minSize,:);

    % plot
    figure
    hold on
    mu = mean(ensemblePerf,2);
    sigma = std(ensemblePerf,0,2)/sqrt(length(d));
    plotPatchSDF(mu', sigma','r',0)
    h1 = plot(mu,'r');

    mu2 = mean(singleNeuron,2);
    sigma2 = std(singleNeuron,0,2)/sqrt(length(d));
    plotPatchSDF(mu2', sigma2','b',0)
    h2 = plot(mu2,'b');
    
    mu3 = 100*mean(shuffledEnsemble2,2);
    sigma3 = 100*std(shuffledEnsemble2,0,2)/sqrt(length(d));
    plotPatchSDF(mu3', sigma3','k',0)
    h3 = plot(mu3,'k');
    
    mu4 = 100*mean(shuffledSingleNeuron2,2);
    sigma4 = 100*std(shuffledSingleNeuron2,0,2)/sqrt(length(d));
    plotPatchSDF(mu4', sigma4',[0.5 0.5 0.5],0)
    h4 = plot(mu4,'color',[0.5 0.5 0.5]);
    ylim([40 92])
    
    if strcmp(structNames,'direction')
        for k = 5
            plot(1:length(ensembleIndex{k}), individUnitPerf{k}(ensembleIndex{k}),'-k')  
            for m = 1:length(ensembleIndex{k})
                f = plot(m, individUnitPerf{k}(ensembleIndex{k}(m)),'o');
                if ismember(ensembleIndex{k}(m),upInd{k})
                    set(f,'MarkerEdgeColor','r','MarkerFaceColor','r')
                elseif ismember(ensembleIndex{k}(m),downInd{k})
                    set(f,'MarkerEdgeColor','b','MarkerFaceColor','b')
                elseif ismember(ensembleIndex{k}(m),noDirInd{k})
                    set(f,'MarkerEdgeColor','k','MarkerFaceColor','k')
                end
            end      

            [~,ind] = sort(individUnitPerf{k},'descend');

            plot(1:length(ensembleIndex{k}), sort(individUnitPerf{k},'descend'),'-r')  
            for m = 1:length(ensembleIndex{k})
                f = plot(m, individUnitPerf{k}(ind(m)),'o');
                if ismember(ensembleIndex{k}(m),upInd{k})
                    set(f,'MarkerEdgeColor','r','MarkerFaceColor','r')
                elseif ismember(ensembleIndex{k}(m),downInd{k})
                    set(f,'MarkerEdgeColor','b','MarkerFaceColor','b')
                elseif ismember(ensembleIndex{k}(m),noDirInd{k})
                    set(f,'MarkerEdgeColor','k','MarkerFaceColor','k')
                end
            end 
        end 
        
    elseif strcmp(structNames,'location')
        for k = 3
            plot(1:length(ensembleIndex{k}), individUnitPerf{k}(ensembleIndex{k}),'-k')  
            for m = 1:length(ensembleIndex{k})
                f = plot(m, individUnitPerf{k}(ensembleIndex{k}(m)),'o');
                if ismember(ensembleIndex{k}(m),ipsiInd{k})
                    set(f,'MarkerEdgeColor','r','MarkerFaceColor','r')
                elseif ismember(ensembleIndex{k}(m),contraInd{k})
                    set(f,'MarkerEdgeColor','b','MarkerFaceColor','b')
                elseif ismember(ensembleIndex{k}(m),noLocInd{k})
                    set(f,'MarkerEdgeColor','k','MarkerFaceColor','k')
                end
            end      

            [~,ind] = sort(individUnitPerf{k},'descend');

            plot(1:length(ensembleIndex{k}), sort(individUnitPerf{k},'descend'),'-r')  
            for m = 1:length(ensembleIndex{k})
                f = plot(m, individUnitPerf{k}(ind(m)),'o');
                if ismember(ensembleIndex{k}(m),ipsiInd{k})
                    set(f,'MarkerEdgeColor','r','MarkerFaceColor','r')
                elseif ismember(ensembleIndex{k}(m),contraInd{k})
                    set(f,'MarkerEdgeColor','b','MarkerFaceColor','b')
                elseif ismember(ensembleIndex{k}(m),noLocInd{k})
                    set(f,'MarkerEdgeColor','k','MarkerFaceColor','k')
                end
            end 
        end 
    end
end
