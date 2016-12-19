

structNames = {'location', 'direction'}; 

for l = 1:length(structNames)
    
    clear ensemble ensemblePerf singleNeuron single totalEnsemblePerf totalSingleNeuron
    
    cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Raul')
    d = dir('1501_taskRelated_alpha*.mat');
    
    totalEnsemblePerf = cell(1,4);
    totalSingleNeuron = cell(1,4);
    
    % load shuffled data 
    if ~strcmp(d(1).name, '1501_taskRelated_alpha1605.mat')
        load('1501_taskRelated_alpha1605.mat')
    elseif strcmp(d(1).name, '1501_taskRelated_alpha1605.mat')
        load(d(1).name, 'shuffledEnsemble','shuffledSingleNeuron')
    end

    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg')

        totalEnsemblePerf{i} = perfEnsemble_reg.(structNames{l});
        totalSingleNeuron{i} = perfSingleUnit_reg.(structNames{l});

        clear perfEnsemble_reg perfSingleUnit_reg
    end

    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf);
    minSize1 = min(sizes);

    % concatenate
    ensemble = [totalEnsemblePerf{1}(1:minSize1), totalEnsemblePerf{2}(1:minSize1), ...
        totalEnsemblePerf{3}(1:minSize1), totalEnsemblePerf{4}(1:minSize1)];%, totalEnsemblePerf{5}(1:minSize)];

    single = [totalSingleNeuron{1}(1:minSize1), totalSingleNeuron{2}(1:minSize1), ...
        totalSingleNeuron{3}(1:minSize1), totalSingleNeuron{4}(1:minSize1)];%, totalSingleNeuron{5}(1:minSize)];

    cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Sergio')
    d = dir('1612_taskRelated_alpha*.mat');
    
    totalEnsemblePerf2 = cell(1,5);
    totalSingleNeuron2 = cell(1,5);

    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg')

        totalEnsemblePerf2{i} = perfEnsemble_reg.(structNames{l});
        totalSingleNeuron2{i} = perfSingleUnit_reg.(structNames{l});

        clear bestPerfEnsemble singleNeuronPerf
    end

    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf2);
    minSize2 = min(sizes);
    
    % concatenate
    ensemblePerf = [totalEnsemblePerf2{1}(1:minSize2), totalEnsemblePerf2{2}(1:minSize2), ...
        totalEnsemblePerf2{3}(1:minSize2), totalEnsemblePerf2{4}(1:minSize2), totalEnsemblePerf2{5}(1:minSize2)];

    singleNeuron = [totalSingleNeuron2{1}(1:minSize2), totalSingleNeuron2{2}(1:minSize2), ...
        totalSingleNeuron2{3}(1:minSize2), totalSingleNeuron2{4}(1:minSize2), totalSingleNeuron2{5}(1:minSize2)];
    
    
    for i = 1:min(minSize1,minSize2)
        [~,p(i)] = ttest2(single(i,:), singleNeuron(i,:));
        [~,p2(i)] = ttest2(ensemble(i,:), ensemblePerf(i,:));
    end

    numSigDiffSU = length(find(p<0.05))
    numSigDiffEns = length(find(p2<0.05))
    
end


