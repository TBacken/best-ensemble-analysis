cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Raul')
d = dir('1501_taskRelated_alpha*.mat');

structNames = {'location', 'direction'}; 

figure
for l = 1:length(structNames)
    
    totalEnsemblePerf = cell(1,4);
    totalSingleNeuron = cell(1,4);

    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg')

        totalEnsemblePerf{i} = perfEnsemble_reg.(structNames{l});
        totalSingleNeuron{i} = perfSingleUnit_reg.(structNames{l});

        clear perfEnsemble_reg perf_singleUnit_reg
    end

    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf);
    minSize = min(sizes);

    % concatenate
    ensemblePerf = [totalEnsemblePerf{1}(1:minSize), totalEnsemblePerf{2}(1:minSize), ...
        totalEnsemblePerf{3}(1:minSize), totalEnsemblePerf{4}(1:minSize)];%, totalEnsemblePerf{5}(1:minSize)];

    singleNeuron = [totalSingleNeuron{1}(1:minSize), totalSingleNeuron{2}(1:minSize), ...
        totalSingleNeuron{3}(1:minSize), totalSingleNeuron{4}(1:minSize)];%, totalSingleNeuron{5}(1:minSize)];
    
    subplot(1,2,l)
    muE = max(ensemblePerf);
    sigmaE = std(muE);
    
    muSU = max(singleNeuron);
    sigmaSU = std(muSU);
    
%     maxE = max(ensemblePerf); I used to add this when I plotted the
%     average performance, but now I plot the max performance
%     sigMaxE = std(maxE);
    
    barweb([median(muSU), median(muE)],[sigmaSU, sigmaE]);
    
    if l == 1
        title(['Raul Post Cue ' structNames{l}])
    else
        title([structNames{l}])
    end
    
    if l == 3
        ylim([0 50])
    else
        ylim([50 100])
    end
    
    p = signrank(muE, muSU)

end

%%
cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Sergio')
d = dir('1612_taskRelated_alpha*.mat');

structNames = {'location', 'direction'}; 

figure
for l = 1:length(structNames)
    
    totalEnsemblePerf = cell(1,4);
    totalSingleNeuron = cell(1,4);

    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg')

        totalEnsemblePerf{i} = perfEnsemble_reg.(structNames{l})(1:end-1);
        totalSingleNeuron{i} = perfSingleUnit_reg.(structNames{l})(1:end);

        clear perfEnsemble_reg perfSingleUnit_reg
    end

    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf);
    minSize = min(sizes);

    % concatenate
    ensemblePerf = [totalEnsemblePerf{1}(1:minSize), totalEnsemblePerf{2}(1:minSize), ...
        totalEnsemblePerf{3}(1:minSize), totalEnsemblePerf{4}(1:minSize), totalEnsemblePerf{5}(1:minSize)];

    singleNeuron = [totalSingleNeuron{1}(1:minSize), totalSingleNeuron{2}(1:minSize), ...
        totalSingleNeuron{3}(1:minSize), totalSingleNeuron{4}(1:minSize), totalSingleNeuron{5}(1:minSize)];
    
    subplot(1,2,l)
    muE = max(ensemblePerf);
    sigmaE = std(muE);
    
    muSU = max(singleNeuron);
    sigmaSU = std(muSU);
%     
%     maxE = max(ensemblePerf); see above
%     sigMaxE = std(maxE);
    
    barweb([median(muSU), median(muE)],[sigmaSU, sigmaE]);
    
    if l == 1
        title(['Sergio Post Cue ' structNames{l}])
    else
        title([structNames{l}])
    end
    
    if l == 3
        ylim([0 50])
    else
        ylim([50 100])
    end
    
    p = signrank(max(ensemblePerf), max(singleNeuron))

end