function trajectory_struct = new_get_disturbance_onset(trajectory_struct,trial,mouseID,date_of_experiment,trials_to_exclude)
%%
% get disturbance onset based on the previous trajectory struct
% TODO make sure get the newest desired one
if strcmp(mouseID,'CB005')
    search_path = fullfile('S:\new_analysis_results\',mouseID, date_of_experiment,'trajectory_struct_020*');
elseif strcmp(mouseID, 'CB006')
    search_path = fullfile('S:\new_analysis_results\',mouseID, date_of_experiment,'trajectory_struct_01*');
elseif strcmp(mouseID,'CB010')
    search_path = fullfile('S:\new_analysis_results\',mouseID, date_of_experiment,'trajectory_struct_021*');
    
end

file_to_load=dir(fullfile(search_path));

if length(file_to_load) > 1
    [~,I] = max([file_to_load(:).datenum]);
    if ~isempty(I)
        file_to_load = file_to_load(I);
    end
end
previous=load(fullfile(file_to_load.folder, file_to_load.name));

for trial_ind=1:length(trial)
    if find(trials_to_exclude==trial_ind)
        continue
    end
    if trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D'
        trajectory_struct(trial_ind).processed.disturbance_onset = previous.trajectory_struct(trial_ind).processed.disturbance_onset;
    end
end
end
