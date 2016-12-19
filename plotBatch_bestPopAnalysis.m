cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Raul')
d = dir('1501_taskRelated_alpha*.mat');

structNames = {'location', 'direction'};%, 'color'}; 

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
        
        maxBE(i) = totalEnsemblePerf{i}(end);
        maxBSU(i) = totalSingleNeuron{i}(end);
        
        clear perfEnsemble_reg perfSingleUnit_reg ipsiPref bestEnsemble_reg contraPref noLocPref upPref downPref noDirPref bestSingleUnit_reg
    end
    
   
    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf);
    minSize = min(sizes);

    % concatenate
    ensemblePerf = [totalEnsemblePerf{1}(1:minSize), totalEnsemblePerf{2}(1:minSize), ...
        totalEnsemblePerf{3}(1:minSize), totalEnsemblePerf{4}(1:minSize)];%, totalEnsemblePerf{5}(1:minSize)];

    singleNeuron = [totalSingleNeuron{1}(1:minSize), totalSingleNeuron{2}(1:minSize), ...
        totalSingleNeuron{3}(1:minSize), totalSingleNeuron{4}(1:minSize)];%, totalSingleNeuron{5}(1:minSize)];
    
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
    ylim([40 90])
    xlim([0 minSize])
    
    xlim([0 minSize])
    ylabel('SVM Performance (%)')
    xlabel('Ensemble Size')
    legend([h3, h4, h1, h2],'shuffled Ensemble','shuffled SU','Best Ensemble Raul','Best SU Raul') 

    yyaxis right
    plot(minSize,[mean(maxBE), mean(maxBSU)],'o')
    ylim([40 90])
    xlim([0 minSize])
    
    % compute significant difference between ensemble and single units and
    % plot line where p<0.05
    for i = 1:length(ensemblePerf)
        [~,p(i)] = ttest(ensemblePerf(i,:),singleNeuron(i,:));
    end
        p2 = bestPopStats(shuffledSingleNeuron2,singleNeuron,minSize,size(shuffledSingleNeuron2,2),length(d));
        p3 = bestPopStats(shuffledEnsemble2,ensemblePerf,minSize,size(shuffledSingleNeuron2,2),length(d));
    
    if strcmp(structNames{l}, 'color')
        mL_plot_sigLine(p, 1:minSize,'g',2)
        mL_plot_sigLine(p2, 1:minSize,'r',4)
        mL_plot_sigLine(p3, 1:minSize,'b',6)
        
    elseif strcmp(structNames{l}, 'location')
        mL_plot_sigLine(p, 1:minSize,'g',42)
        mL_plot_sigLine(p2, 1:minSize,'r',44)
        mL_plot_sigLine(p3, 1:minSize,'b',46)
        
        for k = 1:length(d)
            %plot(1:length(ensembleIndex{k}), 100*individUnitPerf{k}(ensembleIndex{k}),'-k')  
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
        end 
        
     elseif strcmp(structNames{l}, 'direction')
        mL_plot_sigLine(p, 1:minSize,'g',42)
        mL_plot_sigLine(p2, 1:minSize,'r',44)
        mL_plot_sigLine(p3, 1:minSize,'b',46)
        
        for k = 1:length(d)
            for m = 1:length(ensembleIndex{k})
                f= plot(m, individUnitPerf{k}(ensembleIndex{k}(m)),'o');
                if ismember(ensembleIndex{k}(m),upInd{k})
                    set(f,'MarkerEdgeColor','y','MarkerFaceColor','y')
                elseif ismember(ensembleIndex{k}(m),downInd{k})
                    set(f,'MarkerEdgeColor','g','MarkerFaceColor','g')
                elseif ismember(ensembleIndex{k}(m),noDirInd{k})
                    set(f,'MarkerEdgeColor','k','MarkerFaceColor','k')
                end
            end
        end   
        
    end
    clear maxBE maxBSU
end
%%
clear p p2 p3 
cd('/Users/Theda/Documents/MATLAB/Scripts Theda/mat-files/Sergio')
d = dir('1612_taskRelated_alpha*.mat');

structNames = {'location', 'direction'};%, 'color'};  

for l = 1:length(structNames)
    
    totalEnsemblePerf = cell(1,5);
    totalSingleNeuron = cell(1,5);
    ensembleIndex = cell(1,5);
    individUnitPerf = cell(1,5);
    
    ipsiInd = cell(1,5);
    contraInd = cell(1,5);
    noLocInd = cell(1,5);
    
    upInd = cell(1,5);
    downInd = cell(1,5);
    noDirInd = cell(1,5);

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
        
        maxBE(i) = totalEnsemblePerf{i}(end);
        maxBSU(i) = totalSingleNeuron{i}(end);

        clear perfEnsemble_reg perfSingleUnit_reg ipsiPref bestEnsemble_reg contraPref noLocPref upPref downPref noDirPref bestSingleUnit_reg
    end

    % only take min number of units across all recording days
    sizes = cellfun(@length, totalEnsemblePerf);
    minSize = min(sizes);
    
    % concatenate
    ensemblePerf = [totalEnsemblePerf{1}(1:minSize), totalEnsemblePerf{2}(1:minSize), ...
        totalEnsemblePerf{3}(1:minSize), totalEnsemblePerf{4}(1:minSize), totalEnsemblePerf{5}(1:minSize)];

    singleNeuron = [totalSingleNeuron{1}(1:minSize), totalSingleNeuron{2}(1:minSize), ...
        totalSingleNeuron{3}(1:minSize), totalSingleNeuron{4}(1:minSize), totalSingleNeuron{5}(1:minSize)];
    
    shuffledSingleNeuron2 = shuffledSingleNeuron.(structNames{l})(1:minSize,:);
    shuffledEnsemble2 = shuffledEnsemble.(structNames{l})(1:minSize,:);
    
    %plot
    figure, hold on
    mu3 = 100*mean(shuffledEnsemble2,2);
    sigma3 = 100*std(shuffledEnsemble2,0,2)/sqrt(length(d));
    plotPatchSDF(mu3', sigma3','k',0)
    h3 = plot(mu3,'k');
    
    mu4 = 100*mean(shuffledSingleNeuron2,2);
    sigma4 = 100*std(shuffledSingleNeuron2,0,2)/sqrt(length(d));
    plotPatchSDF(mu4', sigma4',[0.5 0.5 0.5],0)
    h4 = plot(mu4,'color',[0.5 0.5 0.5]);
    
    mu = mean(ensemblePerf,2);
    sigma = std(ensemblePerf,0,2)/sqrt(length(d));
    plotPatchSDF(mu', sigma','m',0)
    h5 = plot(mu,'m');

    mu2 = mean(singleNeuron,2);
    sigma2 = std(singleNeuron,0,2)/sqrt(length(d));
    plotPatchSDF(mu2', sigma2','c',0)
    h6 = plot(mu2,'c');
    
    if strcmp(structNames{l}, 'color')
        ylim([0 40])
    else
        ylim([40 90])
    end
    
    xlim([0 minSize])
    ylabel('SVM Performance (%)')
    xlabel('Ensemble Size')
    legend([h3, h4, h5, h6],'shuffled Ensemble','shuffled SU','Best Ensemble Sergio','Best SU Sergio') 

    yyaxis right
    plot(minSize,[mean(maxBE), mean(maxBSU)],'o')
    ylim([40 90])
    xlim([0 minSize])
    
    % plot line where p<0.05
    for i = 1:length(ensemblePerf)
        [~,p(i)] = ttest(ensemblePerf(i,:),singleNeuron(i,:));
    end
        p2 = bestPopStats(shuffledSingleNeuron2,singleNeuron,minSize,size(shuffledSingleNeuron2,2),length(d));
        p3 = bestPopStats(shuffledEnsemble2,ensemblePerf,minSize,size(shuffledSingleNeuron2,2),length(d));
    
   if strcmp(structNames{l}, 'color')
        mL_plot_sigLine(p, 1:minSize,'g',2)
        mL_plot_sigLine(p2, 1:minSize,'r',4)
        mL_plot_sigLine(p3, 1:minSize,'b',6)
        
    elseif strcmp(structNames{l}, 'location')
        mL_plot_sigLine(p, 1:minSize,'g',42)
        mL_plot_sigLine(p2, 1:minSize,'c',43)
        mL_plot_sigLine(p3, 1:minSize,'m',45)
        
        for k = 1:length(d)
            for m = 1:length(ensembleIndex{k})
                f = plot(m, individUnitPerf{k}(ensembleIndex{k}(m)),'o');
                if ismember(m,upInd{k})
                    set(f,'MarkerEdgeColor','m','MarkerFaceColor','r')
                elseif ismember(m,downInd{k})
                    set(f,'MarkerEdgeColor','c','MarkerFaceColor','c')
                elseif ismember(m,noDirInd{k})
                    set(f,'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
                end
            end
        end 
        
     elseif strcmp(structNames{l}, 'direction')
        mL_plot_sigLine(p, 1:minSize,'g',42)
        mL_plot_sigLine(p2, 1:minSize,'c',43)
        mL_plot_sigLine(p3, 1:minSize,'m',45)
        
        for k = 1:length(d)
            %plot(1:length(ensembleIndex{k}), 100*individUnitPerf{k}(ensembleIndex{k}),'-k') 
            for m = 1:length(ensembleIndex{k})
                f= plot(m, individUnitPerf{k}(ensembleIndex{k}(m)),'-o');
                if ismember(m,upInd{k})
                    set(f,'MarkerEdgeColor',[1 0.65 0],'MarkerFaceColor',[1 0.65 0])
                elseif ismember(m,downInd{k})
                    set(f,'MarkerEdgeColor',[0 0.4 0],'MarkerFaceColor',[0 0.4 0])
                elseif ismember(m,noDirInd{k})
                    set(f,'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5])
                end
            end
        end   
        
    end
end