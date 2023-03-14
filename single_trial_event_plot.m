%%
%extract_event_timings
nidaq_csv_name = strcat('S:\events\', mouseID, '\', date_of_experiment, '\nidaq.csv');
nidaq_data = readmatrix(nidaq_csv_name); % readmatrix func is faster than load func
%%
%figure;
%ax3=gca;
%trial_ind = 95;
disturbance_onset = trajectory_struct(trial_ind).processed.disturbance_onset;

DAQ_disturbance_onset = trial(trial_ind).daq_events.esync.onset(disturbance_onset);
time_range = [DAQ_disturbance_onset-500:DAQ_disturbance_onset+750-1];

lick_onsets = zeros(trial(trial_ind).daq_events.time_end - trial(trial_ind).daq_events.time_start + 1);
lick_onsets = lick_onsets + 0.02;
lick_onsets(trial(trial_ind).daq_events.lick.onset)=0.5;
water_onsets=zeros(trial(trial_ind).daq_events.time_end - trial(trial_ind).daq_events.time_start + 1);
water_onsets = water_onsets + 0.01;
water_onsets(trial(trial_ind).daq_events.water.onset)=1;
ax3 = subplot(4,1,4);
color_1='#0000FF';%color for water
color_2 = '#77AC30';%color for lick
colororder({color_1,color_2})
yyaxis left
hp3=plot(water_onsets(time_range),'Color',color_1); % water
ylim(ax3,[0 1])
yticks(ax3,[0 1])
yticklabels(ax3,{'nowater','water'})
yyaxis right
hold on
hp4=plot(lick_onsets(time_range),'Color',color_2);%lick
ylim(ax3,[0 1])
yticks(ax3,[0 0.5])
yticklabels(ax3,{'nolick','licked'})


%hold on
%hp4=plot(nidaq_data(time_range,3)*0.5); %lick
set(hp3,'LineWidth',2)
set(hp4,'LineWidth',2)

xmax = 1250;
xlim(ax3,[0 xmax])
xticks(ax3,[0:250:xmax])
xticklabels(ax3,strtrim(cellstr(num2str([-500:250:(xmax-500)]'))'))
xlabel(ax3, 'time [msec]')


set(ax3,'fontname','Arial')
set(ax3,'FontSize',12); % make text larger

% CH0 = nidaq_data(:,2), water
% CH1 = nidaq_data(:,3), lick sensor

