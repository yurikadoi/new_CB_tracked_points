clear all

mouseID_to_analyze = 'CB010';
path_to_all_sessions = fullfile('S:\all_analysis_results\', mouseID_to_analyze);
filename = load_latest_file('ds_all', 'ds*', path_to_all_sessions,'justname');

ds_all = readtable(filename);
ds = ds_all;

%ds = ds_all(find(ds_all.session_index >=6),:);
%ds = ds(~isnan(ds.SF),:);
%ds = ds(~isnan(ds.max_distance),:);

all_session_C = {};
all_session_SFs_C = {};
max_length = 0;
for i=1:16
    this_session_maxes = (ds(find(ds.session_index ==i),:).max_distance)';
    %this_session_maxes = (ds(find(ds.session_index ==i),:).mean_distance)';
    all_session_C = [all_session_C; {this_session_maxes}];
    this_session_SFs = (ds(find(ds.session_index ==i),:).SF)';
    all_session_SFs_C = [all_session_SFs_C; {this_session_SFs}];
    
    if length(this_session_maxes) > max_length
        max_length = length(this_session_maxes);

    end
end


% pad with NaNs
all_session_C = cellfun(@(x)[x(1:end) NaN(1,max_length-length(x))],all_session_C,'UniformOutput',false);
all_session_SFs_C = cellfun(@(x)[x(1:end) NaN(1,max_length-length(x))],all_session_SFs_C,'UniformOutput',false);
% make a matrix
all_session_M = cell2mat(all_session_C);
all_session_SFs_M = cell2mat(all_session_SFs_C);
[rowSF,colSF] = find(all_session_SFs_M==1);

[nr,nc] = size(all_session_M);

M_to_plot = [all_session_M nan(nr,1); nan(1,nc+1)];
f1=figure;
pcolor(M_to_plot);
hold on
plot(colSF+0.5, rowSF+0.5, 'w*')
ax = gca;
colormap('winter')
cb = colorbar
shading flat;
set(ax, 'ydir', 'reverse');
set(ax,'color',0*[1 1 1]);
xlabel('trial index')
ylabel('session index')
title(strcat(mouseID_to_analyze,'max nose distance'))
f1.Units= 'centimeters';
f1.Position = [0.5,2,30,11];



cb.Label.String = 'max nose distance';
cb.FontSize = 14;
set(ax,'fontname','Arial')
set(ax,'FontSize',14); % make text larger


pax = axis(ax);
yticks(ax,[1.5:1:17])

yticklabels(ax,strtrim(cellstr(num2str([1:1:16]'))'))
xticks(ax,[10.5:10:ceil(pax(2)/10)*10]);
xticklabels(ax,strtrim(cellstr(num2str([10:10:ceil(pax(2)/10)*10]'))'))

% vl1 = line(ax,[pax(1) pax(2)],[6 6]);
% set(vl1,'Color','m','LineStyle','--','LineWidth',3);
% 
% vl1 = line(ax,[pax(1) pax(2)],[2 2]);
% set(vl1,'Color','m','LineStyle','--','LineWidth',3);
