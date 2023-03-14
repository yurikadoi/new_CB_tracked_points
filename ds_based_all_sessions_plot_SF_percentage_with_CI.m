%%
%ds_based_all_sessions_plot_SF_percentage_with_CI
clear all
close all
mouseID_to_analyze = 'CB010';
path_to_all_sessions = fullfile('S:\all_analysis_results\', mouseID_to_analyze);
filename = load_latest_file('ds_all', 'ds*', path_to_all_sessions,'justname');

ds_all = readtable(filename);

session_range_indexes=[1:1:13];
%ax = gca;
myAlpha = 0.05;% for confidence interval
% define some constants for our column names
%%

f1 = figure;
CUE_COND=1; SESSION_ID=2; PROP=3; CILO=4; CIHI=5;
for i = 1:length(session_range_indexes)
    
    ds = ds_all(find(ds_all.session_index ==i),:);
    wc_s = length(find(ds.cued==1 & ds.SF==1));
    wc_f = length(find(ds.cued==1 & ds.SF==0));
    wo_s = length(find(ds.cued==0 & ds.SF==1));
    wo_f = length(find(ds.cued==0 & ds.SF==0));
    
    
    
    % binofit for with cue trials
    k = (i*2-1);
    [pHat,pCI] = binofit(wc_s,wc_s+wc_f,myAlpha);
    allDataProp(k,PROP) = pHat;
    allDataProp(k,[CILO,CIHI]) = pCI;
    allDataProp(k,CUE_COND)=1;
    allDataProp(k,SESSION_ID) = i;
    % binofit for without cue trials
    k = (i*2);
    [pHat,pCI] = binofit(wo_s,wo_s+ wo_f,myAlpha);
    allDataProp(k,PROP) = pHat;
    allDataProp(k,[CILO,CIHI]) = pCI;
    allDataProp(k,CUE_COND)=0;
    allDataProp(k,SESSION_ID) = i;
    
end
% % logical for indexing:
stimIdx = logical(allDataProp(:,CUE_COND));
% modified from Rick's shockthemonkey coed
% % NOTE: The 'errorbar' function plots error bars that are L(i) + U(i) long.
% % That is, it doesn't treat our CI as an interval, but rather as a distance
% % from the mean to the end of each error bar. So we need to subtract each
% % from the mean:
allDataProp(:,CILO) = allDataProp(:,PROP) - allDataProp(:,CILO); % lower error bar
allDataProp(:,CIHI) = allDataProp(:,CIHI) - allDataProp(:,PROP); % upper error bar
%

% % Now plot:

color_wc = [0.8500, 0.3250, 0.0980];
color_wo = [0, 0.4470, 0.7410];

h2=errorbar(allDataProp(~stimIdx,SESSION_ID),allDataProp(~stimIdx,PROP),...
    allDataProp(~stimIdx,CILO),allDataProp(~stimIdx,CIHI),'Color',color_wo,'Marker','o','MarkerFaceColor',color_wo,...
    'MarkerSize',8,'LineWidth',1,'LineStyle', 'none');

hold on
h1=errorbar(allDataProp(stimIdx,SESSION_ID),allDataProp(stimIdx,PROP),...
    allDataProp(stimIdx,CILO),allDataProp(stimIdx,CIHI),'Color',color_wc,'Marker','o','MarkerFaceColor',color_wc,...
    'MarkerSize',8,'LineWidth',1,'LineStyle', 'none');

xlabel('session index'); ylabel('Proportion success');


xlim([0 (length(session_range_indexes)+1)])
xticks([1:length(session_range_indexes)]);
xticklabels([1:(length(session_range_indexes))]);


ax = axis;
axis([ax(1),ax(2),0,1]);
%legend([h1,h2],'with cue','without cue','Location','northeastoutside');
title(strcat(mouseID_to_analyze,' Proportion Success, 95% CI'));
%
f1.Units= 'centimeters';
f1.Position = [0.5,2,30,13];
%set(gca,'FontSize',12); % make text larger


ax = gca;
ymax = 1;
set(ax,'fontname','Arial')
set(ax,'FontSize',12); % make text larger
%%
% add shading for CB0010
area0=area([0 1.5] ,[ymax ymax]);
area0.FaceColor = 'c';
area0.FaceAlpha = 0.1;
area0.LineStyle = 'none';
area0.DisplayName = 'easy';

area1=area([1.5 5.5] ,[ymax ymax]);
area1.FaceColor = 'g';
area1.FaceAlpha = 0.1;
area1.LineStyle = 'none';
area1.DisplayName = 'easy';

area2=area([5.5 14] ,[ymax ymax]);
area2.FaceColor = 'y';
area2.FaceAlpha = 0.1;
area2.LineStyle = 'none';
area2.DisplayName = 'hard';
%%
% add shading for CB005,006
ymax = 1;
area1=area([0 5.5] ,[ymax ymax]);
area1.FaceColor = 'g';
area1.FaceAlpha = 0.1;
area1.LineStyle = 'none';
area1.DisplayName = 'easy';

area2=area([5.5 17] ,[ymax ymax]);
area2.FaceColor = 'y';
area2.FaceAlpha = 0.1;
area2.LineStyle = 'none';
area2.DisplayName = 'hard';
