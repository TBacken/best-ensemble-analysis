cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Raul')
d = dir('1501_taskRelated_alpha*.mat');

structNames = {'location', 'direction'}; 

for l = 1:length(structNames)
    
    R_maxEnsemblePerf.(structNames{l}) = nan(length(d),1);
    R_maxEnsembleInd.(structNames{l}) = nan(length(d),1);
    
    R_maxSUPerf.(structNames{l}) = nan(length(d),1);
    R_maxSUInd.(structNames{l}) = nan(length(d),1);
    
    R_totalEnsembleSize = nan(length(d),1);
    minSize = 94;
    
    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg')

        R_maxEnsemblePerf.(structNames{l})(i,1) = max(perfEnsemble_reg.(structNames{l}));
        [~,R_maxEnsembleInd.(structNames{l})(i,1)] = min(abs(perfEnsemble_reg.(structNames{l})(1:minSize) - 0.9*R_maxEnsemblePerf.(structNames{l})(i,1)));
        
        R_maxSUPerf.(structNames{l})(i,1) = max(perfSingleUnit_reg.(structNames{l}));
        [~,R_maxSUInd.(structNames{l})(i,1)] = min(abs(perfSingleUnit_reg.(structNames{l})(1:minSize) - 0.9*R_maxSUPerf.(structNames{l})(i,1)));
 

        R_totalEnsembleSize(i,1) = length(perfEnsemble_reg.(structNames{l}));
        clear perfEnsemble_reg perfSingleUnit_reg
    end
    
%     R_pInd.(structNames{l}) = signrank(R_maxEnsembleInd.(structNames{l}), R_maxSUInd.(structNames{l}));
%     R_pPerf.(structNames{l}) = signrank(R_maxEnsemblePerf.(structNames{l}), R_maxSUPerf.(structNames{l}));
end

%%
cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Sergio')
d = dir('1612_taskRelated_alpha*.mat');

structNames = {'location', 'direction'}; 

for l = 1:length(structNames)
    
    S_maxEnsemblePerf.(structNames{l}) = nan(length(d),1);
    S_maxEnsembleInd.(structNames{l}) = nan(length(d),1);
    
    S_maxSUPerf.(structNames{l}) = nan(length(d),1);
    S_maxSUInd.(structNames{l}) = nan(length(d),1);
    
    S_totalEnsembleSize = nan(length(d),1);
    minSize = 61;
    
    for i = 1:length(d)
        load(d(i).name, 'perfEnsemble_reg','perfSingleUnit_reg')

%         [S_maxEnsemblePerf.(structNames{l})(i,1),  S_maxEnsembleInd.(structNames{l})(i,1)] = max(perfEnsemble_reg.(structNames{l})(1:minSize));
%         [S_maxSUPerf.(structNames{l})(i,1),  S_maxSUInd.(structNames{l})(i,1)] = max(perfSingleUnit_reg.(structNames{l})(1:minSize));

        S_maxEnsemblePerf.(structNames{l})(i,1) = max(perfEnsemble_reg.(structNames{l}));
        [~,S_maxEnsembleInd.(structNames{l})(i,1)] = min(abs(perfEnsemble_reg.(structNames{l})(1:minSize) - 0.9*S_maxEnsemblePerf.(structNames{l})(i,1)));
        
        S_maxSUPerf.(structNames{l})(i,1) = max(perfSingleUnit_reg.(structNames{l}));
        [~,S_maxSUInd.(structNames{l})(i,1)] = min(abs(perfSingleUnit_reg.(structNames{l})(1:minSize) - 0.9*S_maxSUPerf.(structNames{l})(i,1)));
 
        
        S_totalEnsembleSize(i,1) = length(perfEnsemble_reg.(structNames{l}));
        clear perfEnsemble_reg perfSingleUnit_reg
    end
    
%     S_pInd.(structNames{l}) = signrank(S_maxEnsembleInd.(structNames{l}), S_maxSUInd.(structNames{l}));
%     S_pPerf.(structNames{l}) = signrank(S_maxEnsemblePerf.(structNames{l}), S_maxSUPerf.(structNames{l}));
end

%% plot median max decoding accuracy per monkey

for l = 1:2
    subplot(1,2,l)
    muE = median(R_maxEnsemblePerf.(structNames{l}));
    sigmaE = std(R_maxEnsemblePerf.(structNames{l}));

    muSU = median(R_maxSUPerf.(structNames{l}));
    sigmaSU = std(R_maxSUPerf.(structNames{l}));
    
    barweb([muSU, muE],[sigmaSU, sigmaE]);
    ylim([50 100])
    title(['Raul Post Cue ' structNames{l}])
end

figure
for l = 1:2
 
    subplot(1,2,l)
    muE = median(S_maxEnsemblePerf.(structNames{l}));
    sigmaE = std(S_maxEnsemblePerf.(structNames{l}));

    muSU = median(S_maxSUPerf.(structNames{l}));
    sigmaSU = std(S_maxSUPerf.(structNames{l}));
    
    barweb([muSU, muE],[sigmaSU, sigmaE]);
    ylim([50 100])
    title(['Sergio Post Cue ' structNames{l}])
end
%% stats for performance
% compare ensemble performance within monkeys
pRLoc = signrank(R_maxEnsemblePerf.location, R_maxSUPerf.location)
pRDir = signrank(R_maxEnsemblePerf.direction, R_maxSUPerf.direction)

pSLoc = signrank(S_maxEnsemblePerf.location, S_maxSUPerf.location)
pSDir = signrank(S_maxEnsemblePerf.direction, S_maxSUPerf.direction)

% compare ensemble performances across monkeys within classes
tmp = [S_maxEnsemblePerf.location; R_maxEnsemblePerf.location];
tmp2 = [S_maxSUPerf.location; R_maxSUPerf.location];
pPerfLoc = signrank(tmp,tmp2)

tmp3 = [S_maxEnsemblePerf.direction; R_maxEnsemblePerf.direction];
tmp4 = [S_maxSUPerf.direction; R_maxSUPerf.direction];
pPerfDir = signrank(tmp3,tmp4)

% compare pooled BE vs BSU
pPerf = signrank([tmp;tmp3],[tmp2;tmp4])

%% stats for indices
% compare indices within monkeys
pRLoc = signrank(R_maxEnsembleInd.location, R_maxSUInd.location)
pRDir = signrank(R_maxEnsembleInd.direction, R_maxSUInd.direction)

pSLoc = signrank(S_maxEnsembleInd.location, S_maxSUInd.location)
pSDir = signrank(S_maxEnsembleInd.direction, S_maxSUInd.direction)

% compare indices across monkeys within classes
tmp = [S_maxEnsembleInd.location; R_maxEnsembleInd.location];
tmp2 = [S_maxSUInd.location; R_maxSUInd.location];
pIndLoc = signrank(tmp,tmp2)

tmp3 = [S_maxEnsembleInd.direction; R_maxEnsembleInd.direction];
tmp4 = [S_maxSUInd.direction; R_maxSUInd.direction];
pIndDir = signrank(tmp3,tmp4)

% compare pooled BE vs BSU
pInd = signrank([tmp;tmp3],[tmp2;tmp4])