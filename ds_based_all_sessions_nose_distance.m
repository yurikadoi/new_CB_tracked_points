% %ds_based_all_sessions_nose_distance
%%
%ds_based_all_sessions_plot_SF_percentage_with_CI
clear all
close all
mouseID_to_analyze = 'CB005';
path_to_all_sessions = fullfile('S:\all_analysis_results\', mouseID_to_analyze);
filename = load_latest_file('ds_all', 'ds*', path_to_all_sessions,'justname');

ds_all = readtable(filename);

session_range_indexes=[1:1:16];
f1 = figure;
%ax = gca;
%%
type_flag=0;

color_wc = [0.8500, 0.3250, 0.0980];
color_wo = [0, 0.4470, 0.7410];
% loop each session
cum_trial_count = 1;
%%
for i = 1:length(session_range_indexes)
    this_session_maxes=[];
    this_session_max_sum = 0;
    this_session_count = 0;
    ds = ds_all(find(ds_all.session_index ==i),:);
    this_session_maxes = ds(find(ds.cued==type_flag),:).max_distance;
    this_session_mean = mean(this_session_maxes,'omitnan');
    this_session_ste = std(this_session_maxes,'omitnan')/sqrt(length(this_session_maxes));
    if type_flag==1
        p1=errorbar(i,this_session_mean,this_session_ste,'Color',color_wc,'Marker','o','MarkerFaceColor',color_wc,'MarkerSize',8,'LineWidth',1);
    elseif type_flag==0
        p2=errorbar(i,this_session_mean,this_session_ste,'Color',color_wo,'Marker','o','MarkerFaceColor',color_wo, 'MarkerSize',8,'LineWidth',1);
        
    end
    hold on
    
end
%%
ax=gca;
f1.Units= 'centimeters';
f1.Position = [0.5,2,30,13];

xlabel('session #')
ylabel('Nose Distance [mm]')
title(strcat(mouseID_to_analyze,' Session averages of nose max distances with SE'))
xlim([0 (length(session_range_indexes)+1)])
xticks([1:(length(session_range_indexes))]);
xticklabels([1:(length(session_range_indexes))]);
ymax = 70;
ylim([0 ymax])
set(ax,'fontname','Arial')
set(ax,'FontSize',12); % make text larger

% % add shading for CB010
% ax = axis;
% area0=area([0 1.5] ,[ax(4) ax(4)]);
% area0.FaceColor = 'c';
% area0.FaceAlpha = 0.1;
% area0.LineStyle = 'none';
% area0.DisplayName = 'easy';
%
% area1=area([1.5 5.5] ,[ax(4) ax(4)]);
% area1.FaceColor = 'g';
% area1.FaceAlpha = 0.1;
% area1.LineStyle = 'none';
% area1.DisplayName = 'easy';
%
% area2=area([5.5 14] ,[ax(4) ax(4)]);
% area2.FaceColor = 'y';
% area2.FaceAlpha = 0.1;
% area2.LineStyle = 'none';
% area2.DisplayName = 'hard';


%

% %%add shading for CB005,006
ax = axis;
area1=area([0 5.5] ,[ax(4) ax(4)]);
area1.FaceColor = 'g';
area1.FaceAlpha = 0.1;
area1.LineStyle = 'none';
area1.DisplayName = 'easy';

area2=area([5.5 17] ,[ax(4) ax(4)]);
area2.FaceColor = 'y';
area2.FaceAlpha = 0.1;
area2.LineStyle = 'none';
area2.DisplayName = 'hard';

%set(f1, 'color', 'none');
%legend([area1 area2],{'easy disturbance','hard disturbance'},'Location','northeast');
%%
%legend([p1 p2 area1 area2],{'with cue','without cue','easy','hard'},'Location','northeast');
%%
legend([area0 area1 area2],{'easiest disturbance', 'easy disturbance','hard disturbance'},'Location','northeast');
%%
legend([p1 p2 area0 area1 area2],{'with cue','without cue','easiest','easy','hard'},'Location','northeast');
