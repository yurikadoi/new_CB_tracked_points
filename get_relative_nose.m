function [noseDist,plot_skip] = get_relative_nose(trial_ind, trajectory_struct, disturbance_onset)
%%
%trial_ind =84
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

if ~isempty(nose_jump_indexes)
    %     trial_ind
    %     relative_nose(nose_jump_indexes(1))
    if noseDist_bs_corrected(nose_jump_indexes(1)) > 450
        exceed_ind=find(noseDist_bs_corrected > 450);
        noseDist_bs_corrected(exceed_ind(1):end)=450;
        
        %disp('max450')
    else
%         trial_ind;
%         noseDist_bs_corrected(nose_jump_indexes(1));
%         diff_noseDist_bs_corrected(nose_jump_indexes(1));
        plot_skip=1;
        
%         f2=figure;
%         plot(noseDist_bs_corrected)
%         title(trial_ind)
%         f2.Units= 'centimeters';
%         f2.Position = [30,12,16,12];
%         hold off
        
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

function jumpcorrected_spout = correct_jumps(org_spout,coordinate)

jumpcorrected_spout = org_spout;
diff_jumpcorrected_spout=diff(jumpcorrected_spout);
jump_indexes = find(abs(diff_jumpcorrected_spout) > 15);
peri_perturb_JI = jump_indexes(find(jump_indexes > 450 & jump_indexes < 485));
post_perturb_JI = jump_indexes(find(jump_indexes >= 485));
pre_perturb_JI = jump_indexes(find(jump_indexes <= 450));
if strcmp(coordinate,'Y') && ~isempty(pre_perturb_JI)
    if abs(20-jumpcorrected_spout(pre_perturb_JI(1)+1)) < abs(20-jumpcorrected_spout(pre_perturb_JI(1)))
        
        jumpcorrected_spout(pre_perturb_JI(1):pre_perturb_JI(end)) = jumpcorrected_spout(pre_perturb_JI(1)+1);
    else
        jumpcorrected_spout(pre_perturb_JI(1)+1:pre_perturb_JI(end)) = jumpcorrected_spout(pre_perturb_JI(1));
        
    end
end
for i=1:length(post_perturb_JI)
    jumpcorrected_spout(post_perturb_JI(i)+1:end) = jumpcorrected_spout(post_perturb_JI(1));
end

if length(peri_perturb_JI) ==2
    num_of_points = peri_perturb_JI(2) - peri_perturb_JI(1);
    start_edge = jumpcorrected_spout(peri_perturb_JI(1));
    end_edge = jumpcorrected_spout(peri_perturb_JI(2)+1);
    increment = (end_edge - start_edge)/num_of_points;
    for j =1:num_of_points
        jumpcorrected_spout(peri_perturb_JI(1)+j) = jumpcorrected_spout(peri_perturb_JI(1)) + increment*j;
        
    end
end
if length(peri_perturb_JI) ==3
    num_of_points = peri_perturb_JI(3) - peri_perturb_JI(1);
    start_edge = jumpcorrected_spout(peri_perturb_JI(1));
    end_edge = jumpcorrected_spout(peri_perturb_JI(3)+1);
    increment = (end_edge - start_edge)/num_of_points;
    for j =1:num_of_points
        jumpcorrected_spout(peri_perturb_JI(1)+j) = jumpcorrected_spout(peri_perturb_JI(1)) + increment*j;
        
    end
end
end