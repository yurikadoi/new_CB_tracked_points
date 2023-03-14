
trials_to_exclude =[];
%trials_to_exclude =[57 58 59 60 61];
X=[];
Y_mean=[];
Y_max = [];
Y_median=[];
Area_under = [];
for trial_ind=1:length(trial)
    if find(trials_to_exclude==trial_ind)
        continue
    end
    
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D')
        if isfield(trajectory_struct(trial_ind).processed,'noseDist_bs_corrected') && ~isempty(trajectory_struct(trial_ind).processed.noseDist_bs_corrected)
            %             if trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450) > 15
            %
            %                 %plot(trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450:500-1))
            %                 %hold on
            %                 trial_ind
            %             continue
            %             end
            if strcmp(trial(trial_ind).results.SF, 'Ineligible')
                trial_ind
                continue
            end
            
            X=[X trial_ind];
            Y_mean=[Y_mean mean(trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450:500-1))];
            Y_max=[Y_max max(trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450:500-1))];
            Y_median=[Y_median median(trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450:500-1))];
            
            x_area = [450:1:500-1];
            y_area = trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450:500-1)';
            A = trapz (x_area, y_area);
            Area_under = [Area_under A];
        end
    end
end

f1=figure;
ax1 = axes ;
subplot(4,1,1)
plot(X,Y_mean,'-o')
title('mean')
xticks([0:1:length(trial)])

subplot(4,1,2)
plot(X,Y_median,'-o')
xticks([0:1:length(trial)])
title('median')

subplot(4,1,3)
plot(X, Area_under,'-o')
xticks([0:1:length(trial)])
title('Area')

subplot(4,1,4)
plot(X,Y_max,'-o')
xticks([0:1:length(trial)])
title('Max')

sgtitle(strcat(mouseID, date_of_experiment))
% f1=figure;
% ax1 = axes ;
% plot(ax1,X,Y_mean,'-o')
% xticks(ax1,[0:1:length(trial)])
%
% f2=figure;
% ax2 = axes ;
% plot(X, Area_under,'-o')
% xticks(ax2,[0:1:length(trial)])
%
% f3=figure;
% ax3 = axes ;
% plot(ax3,X,Y_max,'-o')
% xticks(ax3,[0:1:length(trial)])
%%
for trial_ind=1:length(trial)
    if find(trials_to_exclude==trial_ind)
        continue
    end
    
    if (trial(trial_ind).results.sdci == 'S' || trial(trial_ind).results.sdci == 'D')
        if ~isempty(trajectory_struct(trial_ind).processed.max_noseDist)
            
            
            plot(trajectory_struct(trial_ind).processed.noseDist_bs_corrected(450:500-1))
            hold on
            
        end
    end
end
xticks(ax1,[0:1:length(trial)])