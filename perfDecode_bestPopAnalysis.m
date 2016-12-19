clear all
close all

d = dir('1912_hitsAndErrors_alpha*.mat');
d2 = dir('1501_taskRelated_alpha*.mat');
d3 = dir('2909_alpha*.mat');

% for i = 1:length(d)
%     
%     load(d(i).name, 'allFR','outcome','location');
%     load(d2(i).name, 'perfEnsemble_reg','bestEnsemble_reg','behaviorDecode_reg');
%     load(d3(i).name, 'taskRelated');
% 
%     label = location;
% %     label(direction==3) = 1;
% %     label(direction==4) = 2;
%     allFR = allFR(:,taskRelated);
%     
%     [~, ind] = max(perfEnsemble_reg.location);
%     maxEnsemble = bestEnsemble_reg.location(1:ind);
%     
%     for j = 1:100    
%         
%         % all outcomes 
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(:,maxEnsemble), label,'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         error_true(j,i) = mean(sessAcc);
%         
%         shuffL = randperm(length(label));
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(:,maxEnsemble), label(shuffL),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         shuff_true(j,i) = mean(sessAcc);
%         
%         % hit trials only
%         ind = find(outcome==0); % 0 for Sergio, 22 for Raul
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(ind,maxEnsemble), label(ind),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         error_hits(j,i) = mean(sessAcc);
%         
%         shuffL = ind(randperm(length(ind)));
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(ind,maxEnsemble), label(shuffL),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         shuff_hits(j,i) = mean(sessAcc);
%         
%         % error trials only
%         ind2 = find(outcome~=0);
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(ind2,maxEnsemble), label(ind2),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         error_errors(j,i) = mean(sessAcc);
%         
%         shuffL = ind2(randperm(length(ind2)));
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(ind2,maxEnsemble), label(shuffL),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         shuff_errors(j,i) = mean(sessAcc);
% 
%         % when he responded to distractor instead
%         ind3 = find(outcome==-7); % -7 for Sergio, 16 for Raul
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(ind3,maxEnsemble), label(ind3),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         error_falsePos(j,i) = mean(sessAcc);
% 
%         shuffL = ind3(randperm(length(ind3)));
%         [~,sessAcc]=LD_ClassifyDataLinear2(allFR(ind3,maxEnsemble), label(shuffL),'kfold',10,'normalize',true,'normalizetype','midrange','subsample',true,'numsubsample',1);
%         shuff_falsePos(j,i) = mean(sessAcc);
%     end
%     
%     behaviorDecode_reg.trueT.loc = error_true;
%     behaviorDecode_reg.hits.loc = error_hits;
%     behaviorDecode_reg.errors.loc = error_errors;
%     behaviorDecode_reg.falsePos.loc = error_falsePos;
%     
%     behaviorDecode_reg.shuff.trueT.loc = shuff_true;
%     behaviorDecode_reg.shuff.hits.loc = shuff_hits;
%     behaviorDecode_reg.shuff.errors.loc = shuff_errors;
%     behaviorDecode_reg.shuff.falsePos.loc = shuff_falsePos;
%     
%     save(d2(i).name, 'behaviorDecode_reg','-append')
%     
% end

%%

% true = [];
% hits = [];
% errors = [];
% falsePos = [];
% 
% for i = length(d)
    load(d2(end).name, 'behaviorDecode_reg')
%     
%     true = [true; behaviorDecode_reg.trueT.loc];
%     hits = [hits; behaviorDecode_reg.hits.loc];
%     errors = [errors; behaviorDecode_reg.errors.loc];
%     falsePos = [falsePos; behaviorDecode_reg.falsePos.loc];
% end
%
% stats
pTH = rr_exact_test(behaviorDecode_reg.trueT.loc, behaviorDecode_reg.hits.loc);
pTE = rr_exact_test(behaviorDecode_reg.trueT.loc, behaviorDecode_reg.errors.loc);
pTFP = rr_exact_test(behaviorDecode_reg.trueT.loc, behaviorDecode_reg.falsePos.loc);
pEFP = rr_exact_test(behaviorDecode_reg.errors.loc, behaviorDecode_reg.falsePos.loc);
pTS = rr_exact_test(behaviorDecode_reg.trueT.loc, behaviorDecode_reg.shuff.trueT.loc);
pHS = rr_exact_test(behaviorDecode_reg.hits.loc, behaviorDecode_reg.shuff.hits.loc);
pES = rr_exact_test(behaviorDecode_reg.errors.loc, behaviorDecode_reg.shuff.errors.loc);
pFPS = rr_exact_test(behaviorDecode_reg.falsePos.loc, behaviorDecode_reg.shuff.falsePos.loc);

pTH = mean(pTH);
pTE = mean(pTE);
pTFP = mean(pTFP);
pEFP = mean(pEFP);
pES = mean(pES);
pFPS = mean(pFPS);
pHS = mean(pHS);
pTS = mean(pTS);

% for plotting
muT = mean(behaviorDecode_reg.trueT.loc);
muH = mean(behaviorDecode_reg.hits.loc);
muE = mean(behaviorDecode_reg.errors.loc);
muFP = mean(behaviorDecode_reg.falsePos.loc);

sigT = std(muT);
sigH = std(muH);
sigE = std(muE);
sigFP = std(muFP);

barweb([mean(muT), mean(muH), mean(muE), mean(muFP)], [sigT, sigH, sigE, sigFP]);
legend('true location','hit trials','error trials','false positives')
p{1} = ['p TH = ', num2str(pTH)];
p{2} = ['p TE = ', num2str(pTE)];
p{3} = ['p TFP = ', num2str(pTFP)];
p{4} = ['p EFP = ', num2str(pEFP)];
p{5} = ['p ES = ', num2str(pES)];
p{6} = ['p FPS = ', num2str(pFPS)];
p{7} = ['p HS = ', num2str(pHS)];
p{8} = ['p TS = ', num2str(pTS)];
textbp(p)
ylabel('decoding accuracy (%)')
ylim([0 100])
xlim([0.5 1.5])
saveas(gcf, 'R_decodeBehavior_location_alpha','epsc');