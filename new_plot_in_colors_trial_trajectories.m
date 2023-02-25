function new_plot_in_colors_trial_trajectories(trajectory_struct,trial,trials_to_exclude,mouseID,date_of_experiment,fps)
%plot nose distance timecourse to determine signal quality
%%
f1 = figure;
ax = gca;

count = 1;% track the index of eligible trials
num_of_lines = 0;%number of lines in the plots
plotted_trial_indexes = [];

for trial_ind=1:length(trial)
    % exclude trials that I already know are inelgible
    
    if find(trials_to_exclude==trial_ind)
        continue
    end
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D') %&& trial(trial_ind).arduino_events.trial_type ==1
        if ~isfield(trajectory_struct(trial_ind),'processed') || isempty(trajectory_struct(trial_ind).processed) || ~isfield(trajectory_struct(trial_ind).processed,'noseDist_bs_corrected')
        else
            noseDist_to_plot = trajectory_struct(trial_ind).processed.noseDist_bs_corrected;
            frames = size(noseDist_to_plot);
            time = frames_to_time(frames,fps);
            
            % plot every 3 eligible trials
            %if mod(count,10)==9 %&& max(noseDist_to_plot)>10
            if mod(count,3)==2 %&& max(noseDist_to_plot(450:501))>450%|| mod(trial_ind,90)==0
                
                hold(ax,'on')
                hp = plot(ax,time,noseDist_to_plot);
                %[M,I] = max(noseDist_to_plot)
                set(hp,'LineWidth',2)
                hold(ax,'off')
                
                ylim(ax,[-10 90])
                %ylim([-10 50])
                xlim(ax,[350 550]*5)
                %xlim([250 600]*5)
                
                xticks(ax,[350:50:550]*5)
                %xticks([0:100:1000])
                xticklabels(ax,strtrim(cellstr(num2str([-100:50:250]'*5))'))
                %xticklabels(strtrim(cellstr(num2str([-500:100:500]'))'))
                
                num_of_lines = num_of_lines +1;
                plotted_trial_indexes = [plotted_trial_indexes trial_ind];
                
            end
            count = count + 1;
        end
    end
end
%%
xlabel(ax,'time [msec]')
ylabel(ax,'nose distance [mm]')
%title(strcat(mouseID, {' '},date_of_experiment,' distance between nose and toe mid point every 3 trials'))
title(ax,strcat(mouseID, {' '},date_of_experiment,'nose distance'))

colororder(f1,hot(num_of_lines))
nLines = length(findall(ax,'Type','line'));
% Produce a colormap based on the ColorOrder of the axis
cmap = ax.ColorOrder;
cmap = repmat(cmap, ceil(nLines/size(cmap,1)), 1);
colormap(ax,cmap(1:nLines,:));

cb = colorbar(ax);
%legend for color bar

if num_of_lines > 1
    caxis(ax,[1 num_of_lines])
    set(cb,'Ticks',[1:1:num_of_lines],'TickLabels',plotted_trial_indexes,'FontSize',10)
    cb.Label.String = 'trial #';
    cb.FontSize = 12;
end



% add line for evaluation
% Add lines for the duratrion where I will be using to calc mean and max
pax = axis(ax);
vl1 = line(ax,[450 450]*5,[pax(3) pax(4)]);
vl2 = line(ax,[500 500]*5,[pax(3) pax(4)]);

set(vl1,'Color','m','LineStyle','--','LineWidth',1);
set(vl2,'Color','m','LineStyle','--','LineWidth',1);
hold on
area2=area(ax,[450 500]*5 ,[pax(4) pax(4)],pax(3));
area2.FaceColor = 'm';
area2.FaceAlpha = 0.1;
area2.LineStyle = 'none';

f1.Units= 'centimeters';
f1.Position = [1,2,14,11];
set(ax,'Color',[0.8,0.8,0.8])% make the background gray
set(ax,'fontname','Arial')
set(ax,'FontSize',12); % make text larger
%%
set(f1, 'color', 'none');    
% colorbar part is modified from https://www.mathworks.com/matlabcentral/answers/472898-create-plot-with-multiple-overlayed-lines-where-colorbar-corresponds-to-color-of-line
end