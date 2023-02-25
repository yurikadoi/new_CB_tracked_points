%%
% new function to get the trial indexes to manually calc max and store
% maxes
%convert pixels to mm
% 1 pixel = 0.18mm
pix_to_mm = 0.18;
indexes__to_be_manually_corrected = [];
for trial_ind=1:length(trial)
    % exclude trials that I already know are inelgible
    
    if find(trials_to_exclude==trial_ind)
        continue
    end
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D') %&& trial(trial_ind).arduino_events.trial_type ==1
        
        % retrieve disturbance onset
        disturbance_onset = trajectory_struct(trial_ind).processed.disturbance_onset;
        [noseDist_to_plot,plot_skip]=get_relative_nose(trial_ind, trajectory_struct, disturbance_onset);
        if plot_skip==1
            %store it as manual max calclation
            if noseDist_to_plot(450)*pix_to_mm > (450/2)*pix_to_mm
                trial_ind
                trajectory_struct(trial_ind).processed.max_noseDist = [];
                trial(trial_ind).results.SF = 'Ineligible';
            else
                indexes__to_be_manually_corrected = [indexes__to_be_manually_corrected trial_ind];
            end
            
            
        else
            
            trajectory_struct(trial_ind).processed.noseDist_bs_corrected = noseDist_to_plot.*pix_to_mm;
            trajectory_struct(trial_ind).processed.max_noseDist = max(noseDist_to_plot(450:(500-1)).*pix_to_mm);
            
            %maybe make a criteria to remove from the analysis when mouse nose is
            %already too far away from some threshold at the time of disturbance
            % change the result.SF of that trial to 'ineligible'(incomplete but disturbanced trial)
            if noseDist_to_plot(450)*pix_to_mm > (450/2)*pix_to_mm
                trial_ind
                trajectory_struct(trial_ind).processed.max_noseDist = [];
                trial(trial_ind).results.SF = 'Ineligible';
                
            end
        end
    end
end
indexes__to_be_manually_corrected
%%
%f=figure;
ax1 = axes ;
X=[];
Y=[];
for trial_ind=1:length(trial)
    if find(trials_to_exclude==trial_ind)
        continue
    end
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D')
        if ~isempty(trajectory_struct(trial_ind).processed.max_noseDist)
            % exclude trials that I already know are inelgible
            X=[X trial_ind];
            Y=[Y trajectory_struct(trial_ind).processed.max_noseDist];
            if trajectory_struct(trial_ind).processed.max_noseDist>80
                trial_ind
            end
        end
    end
end
plot(ax1,X,Y,'-o')
xticks(ax1,[0:1:length(trial)])

hold on
%%
% save updated trial and trajectory_struct in matfile with timestamp
% save trial struct with timestamp
dt = datestr(now, 'mmddyy_HHMMSS');
save_filename = fullfile(new_path_to_save, strcat('trial_events_', dt, '.mat'));
save(save_filename, 'trial');
%%
mouseID = 'CB005';
date_of_experiment = '061421';
new_path_to_save = fullfile('S:\all_analysis_results\', mouseID, date_of_experiment);

dt = datestr(now, 'mmddyy_HHMMSS');
save_filename = fullfile(new_path_to_save, strcat('trajectory_struct_', dt, '.mat'));
save(save_filename, 'trajectory_struct');



