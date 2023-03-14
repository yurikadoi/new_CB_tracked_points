%%
%first load matfiles before running this
%%
clear all
disp('------------------')
mouseID = 'CB005';
fps = 200;
date_of_experiment = '060521';
path_to_save = fullfile('S:\all_analysis_results\', mouseID, date_of_experiment);
trials_to_exclude = [];
trials_to_exclude = get_trials_to_exclude(mouseID, date_of_experiment);
% assume trial struct and trajectory struct are already created and saved
% load trial struct and trajectroy struct if not loaded yet
loaded_ouput = load_latest_file('trial', 'trial_events*', path_to_save);
trial = loaded_ouput.trial;
loaded_ouput = load_latest_file('trajectory_struct', 'trajectory_struct*', path_to_save);
trajectory_struct = loaded_ouput.trajectory_struct;

%
f1=figure;
%ax1 = axes ;
X1=[];
Y1=[];
for trial_ind=1:length(trial)
    if find(trials_to_exclude==trial_ind)
        continue
    end
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D')
        if ~isempty(trajectory_struct(trial_ind).processed.max_noseDist)
            % exclude trials that I already know are inelgible
            X1=[X1 trial_ind/length(trial)];
            Y1=[Y1 trajectory_struct(trial_ind).processed.max_noseDist];
            if trajectory_struct(trial_ind).processed.max_noseDist>80
                trial_ind
            end
        end
    end
end
%
disp('------------------')
mouseID = 'CB005';
fps = 200;
date_of_experiment = '061721';
path_to_save = fullfile('S:\all_analysis_results\', mouseID, date_of_experiment);
trials_to_exclude = [];
trials_to_exclude = get_trials_to_exclude(mouseID, date_of_experiment);
% assume trial struct and trajectory struct are already created and saved
% load trial struct and trajectroy struct if not loaded yet
loaded_ouput = load_latest_file('trial', 'trial_events*', path_to_save);
trial = loaded_ouput.trial;
loaded_ouput = load_latest_file('trajectory_struct', 'trajectory_struct*', path_to_save);
trajectory_struct = loaded_ouput.trajectory_struct;
%
%ax1 = axes ;
X2=[];
Y2=[];
for trial_ind=1:length(trial)
    if find(trials_to_exclude==trial_ind)
        continue
    end
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D')
        if ~isempty(trajectory_struct(trial_ind).processed.max_noseDist)
            % exclude trials that I already know are inelgible
            X2=[X2 trial_ind/length(trial)];
            Y2=[Y2 trajectory_struct(trial_ind).processed.max_noseDist];
            if trajectory_struct(trial_ind).processed.max_noseDist>80
                trial_ind
            end
        end
    end
end


color_1=[0.9290, 0.6940, 0.1250];%yellowish color
%color_1=[0.6350 0.0780 0.1840];%redish color
color_2=[0.4940, 0.1840, 0.5560];%purple ish color	
%color_2=[0.4660 0.6740 0.1880];%greenish color
ax1=gca;
plot(ax1,X1,Y1,'-o','LineWidth',2,'Color',color_1)
hold on
plot(ax1,X2,Y2,'-o','LineWidth',2,'Color',color_2)
ylim([0 90])
ylabel("max nose distance")
xlabel("normalized trial index")
%title("CB005 max nose distances of every perturbation trials")
set(ax1,'fontname','Arial')
set(ax1,'FontSize',12); % make text larger
legend("first day of large pert.(session #6)","last day of large pert.(session #16)",'Location','northoutside')
%xticks(ax1,[0:1:length(trial)])
%%
f1=gcf
f1.Units= 'centimeters';
f1.Position = [0.5,2,30,10];
%%
set(f1, 'color', 'none');    
set(ax1, 'color', 'none');

