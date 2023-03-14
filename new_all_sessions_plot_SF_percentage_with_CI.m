%%
%all_sessions_plot_SF_percentage_with_CI
clear all
close all
mouseID = 'CB006';
cameraID = '4';
DLC_config_name = '-Camera 4 (#63774)DLC_resnet50_CB005_006_010_Camera4Feb13shuffle1_1030000_filtered';
path_to_all_sessions = fullfile('S:\all_analysis_results\', mouseID);
date_list = get_list_of_subdirectory_names(path_to_all_sessions);
f1 = figure;
%ax = gca;
myAlpha = 0.05;% for confidence interval
% define some constants for our column names
CUE_COND=1; SESSION_ID=2; PROP=3; CILO=4; CIHI=5;
for date_index = 1:length(date_list)
    %disp('-------------')
    date_of_experiment = date_list{date_index};
    path_to_this_date = fullfile(path_to_all_sessions,date_of_experiment);
    % load trial struct for this date
    loaded_ouput = load_latest_file('trial', 'trial_events*', path_to_this_date);
    trial = loaded_ouput.trial;
    session.wc_s = [];
    session.wc_f = [];
    session.wo_s = [];
    session.wo_f = [];
    % get trial indexes for with-cue success/failure and without-cue
    % success failure
    for trial_ind = 1:length(trial)
        
        if ~isfield(trial(trial_ind).results,'SF') || strcmp(trial(trial_ind).results.sdci,'A')
            continue
        else
            if trial(trial_ind).arduino_events.trial_type == 1 && strcmp(trial(trial_ind).results.SF, 'Success')
                %with cue success trial
                session.wc_s = [session.wc_s trial_ind];
            elseif trial(trial_ind).arduino_events.trial_type == 1 && strcmp(trial(trial_ind).results.SF, 'Failure')
                %with cue failure trial
                session.wc_f = [session.wc_f trial_ind];
                
            elseif trial(trial_ind).arduino_events.trial_type == 2 && strcmp(trial(trial_ind).results.SF, 'Success')
                %without cue success trial
                session.wo_s = [session.wo_s trial_ind];
                
            elseif trial(trial_ind).arduino_events.trial_type == 2 && strcmp(trial(trial_ind).results.SF, 'Failure')
                %without cue failure trial
                session.wo_f = [session.wo_f trial_ind];
                
            else
                trial_ind
            end
        end
        
        
    end
    
    % binofit for with cue trials
    k = (date_index*2-1);
    [pHat,pCI] = binofit(length(session.wc_s),(length(session.wc_s)+ length(session.wc_f)),myAlpha);
    allDataProp(k,PROP) = pHat;
    allDataProp(k,[CILO,CIHI]) = pCI;
    allDataProp(k,CUE_COND)=1;
    allDataProp(k,SESSION_ID) = date_index;
    % binofit for without cue trials
    k = (date_index*2);
    [pHat,pCI] = binofit(length(session.wo_s),(length(session.wo_s)+ length(session.wo_f)),myAlpha);
    allDataProp(k,PROP) = pHat;
    allDataProp(k,[CILO,CIHI]) = pCI;
    allDataProp(k,CUE_COND)=0;
    allDataProp(k,SESSION_ID) = date_index;
    
    
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


xlim([0 (length(date_list)+1)])
xticks([1:(length(date_list))]);
xticklabels([1:(length(date_list))]);


ax = axis;
axis([ax(1),ax(2),0,1]);
%legend([h1,h2],'with cue','without cue','Location','northeastoutside');
title(strcat(mouseID,' Proportion Success, 95% CI'));
%
f1.Units= 'centimeters';
f1.Position = [0.5,2,30,13];
%set(gca,'FontSize',12); % make text larger


ax = gca;
ymax = 1;
set(ax,'fontname','Arial')
set(ax,'FontSize',12); % make text larger

% add shading for CB0010
% area0=area([0 1.5] ,[ymax ymax]);
% area0.FaceColor = 'c';
% area0.FaceAlpha = 0.1;
% area0.LineStyle = 'none';
% area0.DisplayName = 'easy';
% 
% area1=area([1.5 5.5] ,[ymax ymax]);
% area1.FaceColor = 'g';
% area1.FaceAlpha = 0.1;
% area1.LineStyle = 'none';
% area1.DisplayName = 'easy';
% 
% area2=area([5.5 14] ,[ymax ymax]);
% area2.FaceColor = 'y';
% area2.FaceAlpha = 0.1;
% area2.LineStyle = 'none';
% area2.DisplayName = 'hard';

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
