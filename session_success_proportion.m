%%
mouseID_to_analyze = 'CB005';
path_to_all_sessions = fullfile('S:\all_analysis_results\', mouseID_to_analyze);
filename = load_latest_file('ds_all', 'ds*', path_to_all_sessions,'justname');

ds_all = readtable(filename);

%%
% fit the model for SF (logistic regression)
% only for this mouse
ds_all = ds_all(strcmp(ds_all.mouseID,mouseID_to_analyze),:);
ds_all = ds_all(~isnan(ds_all.SF),:);
ds = ds_all(ds_all.session_index == 6,:);

%%

f1=figure;
ax = gca;
color_wc = [0.8500, 0.3250, 0.0980];
color_wo = [0, 0.4470, 0.7410];

%yyaxis right
for i=1:height(ds)
    this_result=(ds(i,:).SF*1.1)-0.05;
    if ds(i,:).cued ==1
        p1=plot(ds(i,:).trial_index,this_result, 'o','Color',color_wc,'MarkerFaceColor',color_wc,'MarkerSize',7);
    elseif ds(i,:).cued ==0
        p2=plot(ds(i,:).trial_index,this_result, 'o','Color',color_wo,'MarkerFaceColor',color_wo,'MarkerSize',7);
    end
    hold on
end


clear Output
clear mid_trial_of_this_block
A = ds.SF;
window_size = 10;

%yyaxis left
%figure;
for idx = 1:(length(ds.SF)-window_size + 1)
    mid_trial_of_this_block(idx) = (ds.trial_index(idx)+ds.trial_index(idx+window_size-1))/2;
    Block = ds.SF(idx:idx+window_size-1);
    Output(idx) = sum(Block)/length(Block);
    
    hold on
end
%'Marker','square','MarkerSize',8,'MarkerFaceColor','k'
p3=plot(mid_trial_of_this_block,Output,'Marker','square','LineWidth',2,'Color','k','MarkerFaceColor','k','MarkerSize',4);

legend([p1 p2 p3],{'CUE','NOCUE','Success Proportion'},'Location','northeast')

xlim([0 ds(height(ds),:).trial_index+1])
ylim([-0.05 1.05])
xlabel('trial index')
ylabel('proportion success')
title(strcat(mouseID_to_analyze, {' '},'060521','sliding window size =10'))
set(ax,'fontname','Arial')
set(ax,'FontSize',12); % make text larger

yticks([-0.05 0 0.2 0.4 0.6 0.8 1 1.05])
yticklabels(ax,{'failure','0', '0.2', '0.4', '0.6', '0.8', '1','success'})
f1.Units= 'centimeters';
f1.Position = [0.5,2,28,7];
set(f1, 'color', 'none'); 
