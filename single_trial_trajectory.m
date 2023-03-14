%%
%CB005 060521 trial 92(success), trial 95 (failure)
f1 = figure;

count = 1;% track the index of eligible trials
num_of_lines = 0;%number of lines in the plots
plotted_trial_indexes = [];

trial_ind = 95;
disturbance_onset = trajectory_struct(92).processed.disturbance_onset;
perturbation_to_plot = smooth(trajectory_struct(92).L_barendX(disturbance_onset-450:disturbance_onset+150-1)*(-1));
pert_min = min(perturbation_to_plot);
pert_max = max(perturbation_to_plot);

noseDist_to_plot = trajectory_struct(trial_ind).processed.noseDist_bs_corrected;


frames = size(noseDist_to_plot);
time = frames_to_time(frames,fps);

%pos1 = [0 0 0.3 0.3];
%ax1=subplot('Position',pos1);
ax1 = subplot(4,1,[1 2]);
hp1 = plot(ax1,time,noseDist_to_plot,'k');
set(hp1,'LineWidth',2)

%pos2 = [0.5 0.15 0.4 0.7];
%ax2=subplot('Position',pos2);
ax2 = subplot(4,1,3);
hp2 = plot(ax2,time,perturbation_to_plot,'k');
set(hp2,'LineWidth',2)

this_xmax = 600;
xlim(ax1,[350 this_xmax]*5)
xticks(ax1,[350:50:this_xmax]*5)
xticklabels(ax1,strtrim(cellstr(num2str([-100:50:this_xmax-300]'*5))'))

xlim(ax2,[350 600]*5)
xticks(ax2,[350:50:600]*5)
xticklabels(ax2,strtrim(cellstr(num2str([-100:50:this_xmax-300]'*5))'))

% xlim(ax1,[350 550]*5)
% xticks(ax1,[350:50:550]*5)
% xticklabels(ax1,strtrim(cellstr(num2str([-100:50:250]'*5))'))
ylim(ax1,[-10 90])
ylabel(ax1,'nose distance [mm]')

% xlim(ax2,[350 550]*5)
% xticks(ax2,[350:50:550]*5)
% xticklabels(ax2,strtrim(cellstr(num2str([-100:50:250]'*5))'))
ylim(ax2,[pert_min pert_max])
yticks(ax2,[pert_min pert_max])
yticklabels(ax2,{'0','18'})
%ylabel(ax2,'displacement [mm]')
ylabel(ax2,{'platform';'disp. [mm]'})

set(ax1,'fontname','Arial')
set(ax1,'FontSize',12); % make text larger
set(ax2,'fontname','Arial')
set(ax2,'FontSize',12); % make text larger

f1.Units= 'centimeters';
f1.Position = [1,2,30,13];
%%
%trial 92
ind_to_add_markers=[450 474 484 500]% 550]%  [551 575 585 600 650];
set(hp1,'MarkerIndices',ind_to_add_markers+1)
set(hp1,'Marker','square','MarkerSize',8,'MarkerFaceColor','k')
%%
%trial 95
ind_to_add_markers=[450 474 487 500]% 550];% [737 761 774 786 836];
set(hp1,'MarkerIndices',ind_to_add_markers+1)
set(hp1,'Marker','square','MarkerSize',8,'MarkerFaceColor','k')

%%
xlabel(ax1,'time [msec]')
ylabel(ax1,'nose distance [mm]')
%title(strcat(mouseID, {' '},date_of_experiment,' distance between nose and toe mid point every 3 trials'))
title(ax1,strcat(mouseID, {' '},date_of_experiment,'nose distance trial',num2str(trial_ind)))
%%

% add line for evaluation
% Add lines for the duratrion where I will be using to calc mean and max
pax = axis(ax1);
vl1 = line(ax1,[450 450]*5,[pax(3) pax(4)]);
vl2 = line(ax1,[500 500]*5,[pax(3) pax(4)]);

set(vl1,'Color','m','LineStyle','--','LineWidth',1);
set(vl2,'Color','m','LineStyle','--','LineWidth',1);
hold on
area2=area(ax1,[450 500]*5 ,[pax(4) pax(4)],pax(3));
area2.FaceColor = 'm';
area2.FaceAlpha = 0.1;
area2.LineStyle = 'none';

f1.Units= 'centimeters';
f1.Position = [1,2,14,11];
set(ax1,'fontname','Arial')
set(ax1,'FontSize',12); % make text larger
%%
set(f1, 'color', 'none');
% colorbar part is modified from https://www.mathworks.com/matlabcentral/answers/472898-create-plot-with-multiple-overlayed-lines-where-colorbar-corresponds-to-color-of-line
