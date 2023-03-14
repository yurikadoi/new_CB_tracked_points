function [noseDist,plot_skip] = get_relative_nose(trial_ind, trajectory_struct, disturbance_onset)
%%
%trial_ind =11
plot_skip=0;
disturbance_onset = trajectory_struct(trial_ind).processed.disturbance_onset;
org_spoutX = trajectory_struct(trial_ind).spoutX(disturbance_onset-450:disturbance_onset+150-1);
jumpcorrected_spoutX = correct_jumps(org_spoutX,'X');
org_spoutY = trajectory_struct(trial_ind).spoutY(disturbance_onset-450:disturbance_onset+150-1);
jumpcorrected_spoutY = correct_jumps(org_spoutY,'Y');

% retrieve noseDist
relative_noseX=trajectory_struct(trial_ind).noseX(disturbance_onset-450:disturbance_onset+150-1) - jumpcorrected_spoutX;
relative_noseY=trajectory_struct(trial_ind).noseY(disturbance_onset-450:disturbance_onset+150-1) - jumpcorrected_spoutY;
relative_nose = sqrt((relative_noseX.^2)+(relative_noseY.^2));
baseline = mean(relative_nose(1:400));
noseDist_bs_corrected = relative_nose- baseline;

% check if jump happens before or after reaching 450
%noseX = trajectory_struct(trial_ind).noseX(disturbance_onset:disturbance_onset+50-1);
diff_noseDist_bs_corrected = diff(noseDist_bs_corrected);
nose_jump_indexes = find(abs(diff_noseDist_bs_corrected) > 70);


% TODO add something when the first jump is detected later than max-calc
% window

if ~isempty(nose_jump_indexes)
    %     trial_ind
    %     relative_nose(nose_jump_indexes(1))
    if noseDist_bs_corrected(nose_jump_indexes(1)) > 450
        exceed_ind=find(noseDist_bs_corrected > 450);
        noseDist_bs_corrected(exceed_ind(1):end)=450;
    else
        %trial_ind;
        if nose_jump_indexes(1)>500
            noseDist_bs_corrected(find(noseDist_bs_corrected > 450))=450;
            % there is jump but no effect for calculating max
        else
            plot_skip=1;
        end
        
        
    end
else
    % if there is no jump, and if max is more than 450, plataeu it on 450
    noseDist_bs_corrected(find(noseDist_bs_corrected > 450))=450;
end
% if ~isempty(nose_jump_indexes)
%     trial_ind
%     figure;
%     plot(noseX)
%     hold on
%     plot(diff_noseX)
%     title(trial_ind)
% end

noseDist=noseDist_bs_corrected;

%figure;
%plot(noseDist)
%hold on
%plot(trajectory_struct(trial_ind).noseLH(disturbance_onset-450:disturbance_onset+150-1)*100)
end
